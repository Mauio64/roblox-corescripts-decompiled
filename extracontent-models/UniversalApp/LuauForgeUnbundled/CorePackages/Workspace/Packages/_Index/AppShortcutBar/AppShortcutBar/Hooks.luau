return {
	useAppShortcutBarHeight = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useAppShortcutBarHeight"),
	useIsStickyShortcutBarEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Hooks/useIsStickyShortcutBarEnabled"),
	useShortcutBarVisible = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Stores/GetShortcutBarStatusStore")(false).useShortcutBarVisible
}
