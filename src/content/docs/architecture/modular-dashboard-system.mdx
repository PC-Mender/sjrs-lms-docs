---
title: "Modular Dashboard System"
---

# Modular Dashboard System

## Overview

A centralized, configurable dashboard system that allows users to customize their dashboard layout, enable/disable widgets, and reorder tabs based on their preferences. This document covers both the architecture and implementation guide.

## Architecture Components

### 1. Widget Registry System

**Location:** `src/registry/dashboard-widgets.ts`

Central registry that defines all available dashboard widgets/tabs for each role.

```typescript
export interface DashboardWidgetConfig {
  id: string;                    // Unique widget identifier
  name: string;                  // Display name
  icon: React.ReactNode;         // Icon component
  component: React.ComponentType<any>; // Widget component
  roles: string[];               // Roles that can see this widget
  defaultEnabled: boolean;        // Default visibility
  category: 'overview' | 'navigation' | 'analytics' | 'tools' | 'system';
  order: number;                 // Default display order
  description?: string;          // Tooltip/help text
  requiresPermission?: {         // Optional permission check
    resource: string;
    action: string;
  };
}

export interface DashboardWidgetRegistry {
  [role: string]: DashboardWidgetConfig[];
}
```

### 2. Widget Configuration Storage

**Extends:** `UserPreferences.dashboard_widgets`

```typescript
export interface DashboardWidgets {
  // Widget visibility: { widgetId: enabled }
  enabled: Record<string, boolean>;
  
  // Tab order: [widgetId1, widgetId2, ...]
  tabOrder: string[];
  
  // Widget-specific settings
  settings: Record<string, any>;
}
```

### 3. Dashboard Component Structure

**Location:** `src/components/features/dashboard/ModularDashboard.tsx`

```typescript
interface ModularDashboardProps {
  role: string;
  widgets?: DashboardWidgetConfig[]; // Override default widgets
}
```

### 4. Widget Factory

**Location:** `src/factories/widget-factory.ts`

Dynamically loads and renders widgets based on user preferences.

### 5. Dashboard Settings UI

**Location:** `src/pages/settings/components/DashboardSettings.tsx`

Allows users to:
- Enable/disable widgets
- Reorder tabs
- Reset to defaults
- View widget descriptions

## Implementation Plan

### Phase 1: Core Infrastructure

1. **Widget Registry** (`src/registry/dashboard-widgets.ts`)
   - Define all widgets for each role
   - Export widget configurations

2. **Widget Types** (`src/types/dashboard-widgets.ts`)
   - Extend `DashboardWidgets` interface
   - Add widget configuration types

3. **Widget Factory** (`src/factories/widget-factory.ts`)
   - Load widgets based on registry
   - Filter by role and permissions
   - Apply user preferences

### Phase 2: Modular Dashboard Component

4. **ModularDashboard** (`src/components/features/dashboard/ModularDashboard.tsx`)
   - Tab-based layout (like Settings page)
   - Dynamic tab generation from registry
   - Respect user preferences

5. **Widget Wrapper** (`src/components/features/dashboard/widgets/WidgetWrapper.tsx`)
   - Error boundaries
   - Loading states
   - Widget settings

### Phase 3: User Customization

6. **Dashboard Settings** (`src/pages/settings/components/DashboardSettings.tsx`)
   - Toggle widgets on/off
   - Drag-and-drop reordering
   - Reset to defaults

7. **Preferences Integration**
   - Update `user-preferences.service.ts`
   - Sync with backend
   - Default configurations

### Phase 4: Widget Migration

8. **Convert Existing Widgets**
   - Stats Widget → Overview Tab
   - Quick Links → Navigation Tab
   - Analytics → Analytics Tab
   - Tools → Tools Tab
   - System Health → System Tab

## Widget Registry Example

```typescript
// src/registry/dashboard-widgets.ts

export const SUPERUSER_WIDGETS: DashboardWidgetConfig[] = [
  {
    id: 'overview',
    name: 'Overview',
    icon: <DashboardOutlined />,
    component: OverviewTab,
    roles: ['superuser'],
    defaultEnabled: true,
    category: 'overview',
    order: 1,
    description: 'System statistics and health summary'
  },
  {
    id: 'quick-links',
    name: 'Quick Links',
    icon: <LinkOutlined />,
    component: QuickLinksTab,
    roles: ['superuser'],
    defaultEnabled: true,
    category: 'navigation',
    order: 2,
    description: 'Quick navigation to system sections'
  },
  {
    id: 'analytics',
    name: 'Analytics',
    icon: <BarChartOutlined />,
    component: AnalyticsTab,
    roles: ['superuser'],
    defaultEnabled: true,
    category: 'analytics',
    order: 3,
    description: 'System analytics and reports'
  },
  {
    id: 'tools',
    name: 'Tools',
    icon: <ToolOutlined />,
    component: ToolsTab,
    roles: ['superuser'],
    defaultEnabled: true,
    category: 'tools',
    order: 4,
    description: 'Administrative tools and utilities'
  },
  {
    id: 'system-health',
    name: 'System Health',
    icon: <HeartOutlined />,
    component: SystemHealthTab,
    roles: ['superuser'],
    defaultEnabled: true,
    category: 'system',
    order: 5,
    description: 'Detailed system health metrics'
  }
];

export const DASHBOARD_REGISTRY: DashboardWidgetRegistry = {
  superuser: SUPERUSER_WIDGETS,
  admin: ADMIN_WIDGETS,
  librarian: LIBRARIAN_WIDGETS,
  // ... other roles
};
```

## Implementation Guide

### How It Works

#### 1. Widget Registration

Widgets are registered in `src/registry/dashboard-widgets.ts`:

```typescript
{
  id: 'overview',
  name: 'Overview',
  icon: <DashboardOutlined />,
  component: OverviewTab,
  roles: ['superuser'],
  defaultEnabled: true,
  category: 'overview',
  order: 1,
  description: 'System statistics and health summary'
}
```

#### 2. Widget Loading

The `useDashboardWidgets` hook:
- Gets user's role
- Loads widgets for that role
- Filters by permissions
- Applies user preferences (enabled/disabled, order)
- Returns ordered list of widgets

#### 3. User Preferences Storage

Widget preferences are stored in `UserPreferences.dashboard_widgets`:

```typescript
{
  enabled: {
    'overview': true,
    'analytics': false,  // User disabled this
    'tools': true
  },
  tabOrder: ['overview', 'tools', 'quick-links'],  // Custom order
  settings: {
    'analytics': { compact: true }
  }
}
```

#### 4. Dashboard Rendering

The ModularDashboard component:
- Uses `useDashboardWidgets` hook
- Renders widgets as tabs (like Settings page)
- Lazy loads widget components
- Handles errors gracefully

### Implementation Steps

#### Step 1: Create Tab Components

Create widget components in `src/components/features/dashboard/tabs/`:

- `OverviewTab.tsx` - Stats + System Health summary
- `QuickLinksTab.tsx` - Navigation buttons
- `AnalyticsTab.tsx` - Analytics widget
- `ToolsTab.tsx` - Administrative tools
- `SystemHealthTab.tsx` - Detailed system health

#### Step 2: Create Modular Dashboard Component

```typescript
// src/components/features/dashboard/ModularDashboard.tsx
import { useDashboardWidgets } from '../../../hooks/dashboard/useDashboardWidgets';
import { Card, Tabs, Spin } from 'antd';

export const ModularDashboard: React.FC = () => {
  const { orderedWidgets } = useDashboardWidgets();
  
  const tabItems = orderedWidgets.map(widget => ({
    key: widget.id,
    label: (
      <span>
        {widget.icon} {widget.name}
      </span>
    ),
    children: (
      <React.Suspense fallback={<Spin />}>
        <widget.component {...widget.props} />
      </React.Suspense>
    )
  }));
  
  return (
    <Card>
      <Tabs items={tabItems} defaultActiveKey={orderedWidgets[0]?.id} />
    </Card>
  );
};
```

#### Step 3: Create Dashboard Settings UI

```typescript
// src/pages/settings/components/DashboardSettings.tsx
import { useDashboardWidgets } from '../../../hooks/dashboard/useDashboardWidgets';
import { Switch, Space, Button } from 'antd';

export const DashboardSettings: React.FC = () => {
  const { availableWidgets, preferences, updatePreferences } = useDashboardWidgets();
  const { updatePreferences: updateUserPrefs } = useUserPreferences();
  
  const handleToggleWidget = async (widgetId: string, enabled: boolean) => {
    const newEnabled = { ...preferences.enabled, [widgetId]: enabled };
    await updateUserPrefs({
      dashboard_widgets: {
        ...preferences,
        enabled: newEnabled
      }
    });
  };
  
  return (
    <Space direction="vertical">
      {availableWidgets.map(widget => (
        <div key={widget.id}>
          <Switch
            checked={preferences.enabled[widget.id] ?? widget.defaultEnabled}
            onChange={(checked) => handleToggleWidget(widget.id, checked)}
          />
          <span>{widget.name}</span>
          <span>{widget.description}</span>
        </div>
      ))}
    </Space>
  );
};
```

#### Step 4: Update User Preferences Service

Extend `src/services/user-preferences.service.ts` to handle widget preferences:

```typescript
async updateDashboardWidgets(preferences: DashboardWidgetPreferences) {
  return this.updatePreferences({
    dashboard_widgets: preferences
  });
}
```

### Adding a New Widget

1. Create widget component in `src/components/features/dashboard/tabs/`
2. Register in `src/registry/dashboard-widgets.ts`
3. Add to appropriate role's widget array
4. Widget automatically appears in dashboard (if enabled)
5. Users can enable/disable via Settings

## Benefits

1. **Centralized Configuration**: All widgets defined in one place
2. **Role-Based**: Different widgets for different roles
3. **User Customizable**: Users can personalize their dashboard
4. **Modular**: Easy to add/remove widgets
5. **Type-Safe**: Full TypeScript support
6. **Permission-Aware**: Respects user permissions
7. **Extensible**: Easy to add new widgets

## Migration Strategy

1. Keep existing dashboard working
2. Create new modular system alongside
3. Migrate widgets one by one
4. Add settings UI for customization
5. Switch to modular system when ready
6. Remove old components

## Future Enhancements

- Drag-and-drop tab reordering
- Widget size customization
- Custom widget layouts
- Widget sharing between users
- Widget marketplace (community widgets)

