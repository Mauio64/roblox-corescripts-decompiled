local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local useIsStickyShortcutBarEnabled = require(script.useIsStickyShortcutBarEnabled)
local useAppShortcutBarHeight = require(script.useAppShortcutBarHeight)
local v4 = require(AppShortcutBar.Stores.GetShortcutBarStatusStore)(false)

return {
	useIsStickyShortcutBarEnabled = useIsStickyShortcutBarEnabled,
	useAppShortcutBarHeight = useAppShortcutBarHeight,
	useShortcutBarVisible = v4.useShortcutBarVisible
}
