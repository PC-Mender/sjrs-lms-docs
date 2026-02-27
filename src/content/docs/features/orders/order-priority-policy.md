---
title: "Order Priority Policy"
---

# Order Priority Policy

## Purpose

Order priority is computed when an order is created and stored on the order record. This is used primarily for staff/superuser queues (sorting and triage), while keeping the frontend thin and the backend authoritative.

## Priority levels

The system stores one of the following priority levels on each order:

- `low`
- `normal`
- `high`
- `urgent`

## Signals and precedence

The policy currently uses a combination of risk signals and badge-based trust signals.

### 1. Risk demotions (evaluated first)

If enabled in the policy configuration, either of the following forces the order priority to `low`:

- User has one or more pending penalties
- User has one or more overdue loans

### 2. Trust promotions (evaluated only if not demoted)

If the order was not demoted to `low`, and the user has any badge key in `trust_badge_keys`, the priority is promoted to `high`.

### 3. Urgent promotions (evaluated only if not demoted)

If the order was not demoted to `low`, and the user has any badge key in `urgent_badge_keys`, the priority is promoted to `urgent`.

## Storage and auditability

When computed, the backend stores:

- `orders.priority`
- `orders.priority_reason` (JSON snapshot including inputs, rules applied, and the policy config version used)

## Configuration (Global)

The policy is global for the whole system and stored in D1:

- Table: `order_priority_policy_config` (single-row, `id = 1`)
- Migration: `sql/migrations/2026-02-20_add-order-priority-policy-config.sql`

A superuser UI is provided to edit this configuration.

## API

Superuser-only endpoints:

- `GET /api/v1/order-priority-policy`
- `PUT /api/v1/order-priority-policy`

## Implementation locations

- Computation policy: `functions/api/orders/policies/order-priority-policy.ts`
- CRUD API handler: `functions/api/order-priority-policy/index.ts`
- UI page: `src/pages/dashboard-superuser/order-priority-policy.tsx`
