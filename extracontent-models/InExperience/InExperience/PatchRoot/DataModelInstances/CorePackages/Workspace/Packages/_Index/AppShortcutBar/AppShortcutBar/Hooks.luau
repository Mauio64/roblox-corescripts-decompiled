local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")

local useAppShortcutBarHeight = require(script.useAppShortcutBarHeight)
local useIsStickyShortcutBarEnabled = require(script.useIsStickyShortcutBarEnabled)
local GetShortcutBarStatusStore = require(AppShortcutBar.Stores.GetShortcutBarStatusStore)

return {
	useAppShortcutBarHeight = useAppShortcutBarHeight,
	useIsStickyShortcutBarEnabled = useIsStickyShortcutBarEnabled,
	useShortcutBarVisible = GetShortcutBarStatusStore(false).useShortcutBarVisible
}
