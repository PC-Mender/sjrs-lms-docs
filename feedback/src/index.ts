interface Env {
  FEEDBACK_DB: D1Database;
  ALLOWED_ORIGIN: string;
  HASH_SECRET: string;
}

type VoteValue = 'up' | 'down';

interface SummaryResponse {
  pagePath: string;
  upCount: number;
  downCount: number;
  userVote: VoteValue | null;
  hasComment: boolean;
}

const COOKIE_NAME = 'sjrs_docs_feedback_visitor';
const COOKIE_MAX_AGE = 60 * 60 * 24 * 365;
const MAX_PAGE_PATH_LENGTH = 300;
const MAX_PAGE_TITLE_LENGTH = 200;
const MAX_COMMENT_LENGTH = 500;
const SUMMARY_RATE_LIMIT = { limit: 180, windowMs: 5 * 60 * 1000, prefix: 'summary' };
const VOTE_RATE_LIMIT = { limit: 20, windowMs: 15 * 60 * 1000, prefix: 'vote' };

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    validateEnv(env);

    const url = new URL(request.url);
    const origin = request.headers.get('Origin');
    const cookieVisitorId = getCookie(request.headers.get('Cookie'), COOKIE_NAME);
    const visitorId = cookieVisitorId ?? crypto.randomUUID();
    const needsVisitorCookie = !cookieVisitorId;

    if (request.method === 'OPTIONS') {
      return buildEmptyResponse(204, origin, env, needsVisitorCookie ? visitorId : null);
    }

    try {
      if (url.pathname === '/health' && request.method === 'GET') {
        return jsonResponse(
          { ok: true, service: 'sjrs-docs-feedback' },
          200,
          origin,
          env,
          needsVisitorCookie ? visitorId : null,
        );
      }

      if (url.pathname === '/api/v1/feedback/summary' && request.method === 'GET') {
        await enforceRateLimit(request, env, SUMMARY_RATE_LIMIT);

        const pagePath = normalizePagePath(url.searchParams.get('page'));
        const summary = await getSummary(env, visitorId, pagePath);

        return jsonResponse(summary, 200, origin, env, needsVisitorCookie ? visitorId : null, {
          'Cache-Control': 'private, max-age=30',
        });
      }

      if (url.pathname === '/api/v1/feedback/vote' && request.method === 'POST') {
        enforceAllowedOrigin(origin, env);
        await enforceRateLimit(request, env, VOTE_RATE_LIMIT);

        const payload = await parseVotePayload(request);
        const result = await saveVote(env, request, visitorId, payload);

        return jsonResponse(
          {
            ...result,
            message: 'Thanks for your feedback.',
          },
          200,
          origin,
          env,
          needsVisitorCookie ? visitorId : null,
          { 'Cache-Control': 'no-store' },
        );
      }

      return jsonResponse({ error: 'Not found' }, 404, origin, env, needsVisitorCookie ? visitorId : null);
    } catch (error) {
      if (error instanceof HttpError) {
        return jsonResponse({ error: error.message }, error.status, origin, env, needsVisitorCookie ? visitorId : null, {
          'Cache-Control': 'no-store',
        });
      }

      return jsonResponse(
        { error: 'Internal server error' },
        500,
        origin,
        env,
        needsVisitorCookie ? visitorId : null,
        { 'Cache-Control': 'no-store' },
      );
    }
  },
};

class HttpError extends Error {
  status: number;

  constructor(status: number, message: string) {
    super(message);
    this.status = status;
  }
}

function validateEnv(env: Env): void {
  if (!env.FEEDBACK_DB) {
    throw new HttpError(500, 'Feedback database binding is missing');
  }

  if (!env.ALLOWED_ORIGIN?.trim()) {
    throw new HttpError(500, 'ALLOWED_ORIGIN is not configured');
  }

  if (!env.HASH_SECRET?.trim()) {
    throw new HttpError(500, 'HASH_SECRET is not configured');
  }
}

function getCookie(cookieHeader: string | null, cookieName: string): string | null {
  if (!cookieHeader) return null;

  for (const cookie of cookieHeader.split(';')) {
    const [name, ...valueParts] = cookie.trim().split('=');
    if (name === cookieName) {
      return decodeURIComponent(valueParts.join('='));
    }
  }

  return null;
}

function setVisitorCookie(headers: Headers, visitorId: string): void {
  headers.append(
    'Set-Cookie',
    `${COOKIE_NAME}=${encodeURIComponent(visitorId)}; Max-Age=${COOKIE_MAX_AGE}; Path=/; HttpOnly; Secure; SameSite=None`,
  );
}

function buildCorsHeaders(origin: string | null, env: Env): Headers {
  const headers = new Headers();

  if (origin && origin === env.ALLOWED_ORIGIN) {
    headers.set('Access-Control-Allow-Origin', origin);
    headers.set('Access-Control-Allow-Credentials', 'true');
    headers.set('Access-Control-Allow-Methods', 'GET,POST,OPTIONS');
    headers.set('Access-Control-Allow-Headers', 'Content-Type');
    headers.append('Vary', 'Origin');
  }

  return headers;
}

function applySecurityHeaders(headers: Headers): void {
  headers.set('X-Frame-Options', 'DENY');
  headers.set('X-Content-Type-Options', 'nosniff');
  headers.set('Referrer-Policy', 'strict-origin-when-cross-origin');
  headers.set('Permissions-Policy', 'camera=(), microphone=(), geolocation=(), payment=(), usb=(), magnetometer=(), gyroscope=(), accelerometer=()');
  headers.set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains; preload');
  headers.set('Cross-Origin-Resource-Policy', 'cross-origin');
  headers.set('Content-Security-Policy', "default-src 'none'; frame-ancestors 'none'; base-uri 'none'; form-action 'none'");
}

function buildEmptyResponse(status: number, origin: string | null, env: Env, visitorId: string | null): Response {
  const headers = buildCorsHeaders(origin, env);
  if (visitorId) {
    setVisitorCookie(headers, visitorId);
  }
  applySecurityHeaders(headers);

  return new Response(null, { status, headers });
}

function jsonResponse(
  payload: unknown,
  status: number,
  origin: string | null,
  env: Env,
  visitorId: string | null,
  extraHeaders?: Record<string, string>,
): Response {
  const headers = buildCorsHeaders(origin, env);
  headers.set('Content-Type', 'application/json; charset=utf-8');

  if (visitorId) {
    setVisitorCookie(headers, visitorId);
  }

  applySecurityHeaders(headers);

  if (extraHeaders) {
    for (const [key, value] of Object.entries(extraHeaders)) {
      headers.set(key, value);
    }
  }

  return new Response(JSON.stringify(payload), { status, headers });
}

function enforceAllowedOrigin(origin: string | null, env: Env): void {
  if (!origin || origin !== env.ALLOWED_ORIGIN) {
    throw new HttpError(403, 'Origin not allowed');
  }
}

function normalizePagePath(pagePathRaw: string | null): string {
  const pagePath = (pagePathRaw ?? '').trim();

  if (!pagePath) {
    throw new HttpError(400, 'Page path is required');
  }

  if (!pagePath.startsWith('/') || pagePath.length > MAX_PAGE_PATH_LENGTH) {
    throw new HttpError(400, 'Invalid page path');
  }

  if (pagePath.includes('..')) {
    throw new HttpError(400, 'Invalid page path');
  }

  return pagePath;
}

function normalizePageTitle(pageTitleRaw: unknown): string {
  const pageTitle = String(pageTitleRaw ?? '').trim().replace(/\s+/g, ' ');

  if (!pageTitle) {
    throw new HttpError(400, 'Page title is required');
  }

  if (pageTitle.length > MAX_PAGE_TITLE_LENGTH) {
    throw new HttpError(400, 'Page title is too long');
  }

  return pageTitle;
}

function normalizeVote(voteRaw: unknown): VoteValue {
  if (voteRaw === 'up' || voteRaw === 'down') {
    return voteRaw;
  }

  throw new HttpError(400, 'Vote must be either up or down');
}

function normalizeComment(commentRaw: unknown, vote: VoteValue): string | null {
  const comment = typeof commentRaw === 'string' ? commentRaw.trim().replace(/\s+/g, ' ') : '';

  if (!comment) {
    return null;
  }

  if (vote !== 'down') {
    throw new HttpError(400, 'Comments are only accepted with a downvote');
  }

  if (comment.length > MAX_COMMENT_LENGTH) {
    throw new HttpError(400, 'Comment is too long');
  }

  return comment;
}

async function parseVotePayload(request: Request): Promise<{
  pagePath: string;
  pageTitle: string;
  vote: VoteValue;
  comment: string | null;
}> {
  const body = await request.json().catch(() => null) as Record<string, unknown> | null;
  if (!body) {
    throw new HttpError(400, 'Invalid JSON body');
  }

  const vote = normalizeVote(body.vote);

  return {
    pagePath: normalizePagePath(typeof body.pagePath === 'string' ? body.pagePath : null),
    pageTitle: normalizePageTitle(body.pageTitle),
    vote,
    comment: normalizeComment(body.comment, vote),
  };
}

async function saveVote(
  env: Env,
  request: Request,
  visitorId: string,
  payload: {
    pagePath: string;
    pageTitle: string;
    vote: VoteValue;
    comment: string | null;
  },
): Promise<SummaryResponse> {
  const visitorHash = await hashValue(env.HASH_SECRET, visitorId);
  const ipHash = await hashValue(env.HASH_SECRET, request.headers.get('CF-Connecting-IP') || 'unknown');
  const userAgentHash = await hashValue(env.HASH_SECRET, request.headers.get('User-Agent') || 'unknown');

  const existingVote = await env.FEEDBACK_DB.prepare(
    `SELECT id, vote
     FROM docs_feedback_votes
     WHERE page_path = ? AND visitor_hash = ?`,
  ).bind(payload.pagePath, visitorHash).first<{ id: number; vote: VoteValue } | null>();

  if (!existingVote) {
    await env.FEEDBACK_DB.prepare(
      `INSERT INTO docs_feedback_votes (
        page_path, page_title, vote, comment, visitor_hash, ip_hash, user_agent_hash
      ) VALUES (?, ?, ?, ?, ?, ?, ?)`,
    ).bind(
      payload.pagePath,
      payload.pageTitle,
      payload.vote,
      payload.comment,
      visitorHash,
      ipHash,
      userAgentHash,
    ).run();
  } else {
    await env.FEEDBACK_DB.prepare(
      `UPDATE docs_feedback_votes
       SET page_title = ?, vote = ?, comment = ?, ip_hash = ?, user_agent_hash = ?, updated_at = CURRENT_TIMESTAMP
       WHERE id = ?`,
    ).bind(
      payload.pageTitle,
      payload.vote,
      payload.comment,
      ipHash,
      userAgentHash,
      existingVote.id,
    ).run();
  }

  await refreshSummary(env, payload.pagePath);
  return getSummary(env, visitorId, payload.pagePath);
}

async function refreshSummary(env: Env, pagePath: string): Promise<void> {
  const counts = await env.FEEDBACK_DB.prepare(
    `SELECT
       COALESCE(SUM(CASE WHEN vote = 'up' THEN 1 ELSE 0 END), 0) AS upCount,
       COALESCE(SUM(CASE WHEN vote = 'down' THEN 1 ELSE 0 END), 0) AS downCount
     FROM docs_feedback_votes
     WHERE page_path = ?`,
  ).bind(pagePath).first<{ upCount: number; downCount: number }>();

  const upCount = Number(counts?.upCount ?? 0);
  const downCount = Number(counts?.downCount ?? 0);

  await env.FEEDBACK_DB.prepare(
    `INSERT INTO docs_feedback_summary (page_path, up_count, down_count, updated_at)
     VALUES (?, ?, ?, CURRENT_TIMESTAMP)
     ON CONFLICT(page_path) DO UPDATE SET
       up_count = excluded.up_count,
       down_count = excluded.down_count,
       updated_at = CURRENT_TIMESTAMP`,
  ).bind(pagePath, upCount, downCount).run();
}

async function getSummary(env: Env, visitorId: string, pagePath: string): Promise<SummaryResponse> {
  const visitorHash = await hashValue(env.HASH_SECRET, visitorId);

  const [summaryRow, voteRow] = await Promise.all([
    env.FEEDBACK_DB.prepare(
      `SELECT up_count, down_count
       FROM docs_feedback_summary
       WHERE page_path = ?`,
    ).bind(pagePath).first<{ up_count: number; down_count: number } | null>(),
    env.FEEDBACK_DB.prepare(
      `SELECT vote, comment
       FROM docs_feedback_votes
       WHERE page_path = ? AND visitor_hash = ?`,
    ).bind(pagePath, visitorHash).first<{ vote: VoteValue; comment: string | null } | null>(),
  ]);

  return {
    pagePath,
    upCount: Number(summaryRow?.up_count ?? 0),
    downCount: Number(summaryRow?.down_count ?? 0),
    userVote: voteRow?.vote ?? null,
    hasComment: Boolean(voteRow?.comment),
  };
}

async function enforceRateLimit(
  request: Request,
  env: Env,
  config: { limit: number; windowMs: number; prefix: string },
): Promise<void> {
  const ipHash = await hashValue(env.HASH_SECRET, request.headers.get('CF-Connecting-IP') || 'unknown');
  const now = Date.now();
  const threshold = now - config.windowMs;
  const rateKey = `${config.prefix}:${ipHash}`;

  await env.FEEDBACK_DB.prepare(
    `DELETE FROM docs_feedback_rate_limits
     WHERE rate_key = ? AND created_at < ?`,
  ).bind(rateKey, threshold).run();

  const current = await env.FEEDBACK_DB.prepare(
    `SELECT COUNT(*) AS request_count
     FROM docs_feedback_rate_limits
     WHERE rate_key = ? AND created_at >= ?`,
  ).bind(rateKey, threshold).first<{ request_count: number }>();

  const requestCount = Number(current?.request_count ?? 0);
  if (requestCount >= config.limit) {
    throw new HttpError(429, 'Too many requests');
  }

  await env.FEEDBACK_DB.prepare(
    `INSERT INTO docs_feedback_rate_limits (rate_key, created_at)
     VALUES (?, ?)`,
  ).bind(rateKey, now).run();
}

async function hashValue(secret: string, value: string): Promise<string> {
  const data = new TextEncoder().encode(`${secret}:${value}`);
  const digest = await crypto.subtle.digest('SHA-256', data);
  return [...new Uint8Array(digest)].map((byte) => byte.toString(16).padStart(2, '0')).join('');
}
