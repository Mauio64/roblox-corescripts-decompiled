local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local AppShortcutBarParent = AppShortcutBar.Parent
local React = require(AppShortcutBarParent.React)
local AppShortcutBar2 = require(AppShortcutBar.Components.AppShortcutBar)
local AppStickyShortcutBar = require(AppShortcutBar.Components.AppStickyShortcutBar)
local useAppShortcutBarProps = require(script.Parent.useAppShortcutBarProps)
local useIsStickyShortcutBarEnabled = require(AppShortcutBar.Hooks).useIsStickyShortcutBarEnabled
local useAppPolicy = require(AppShortcutBarParent.UniversalAppPolicy).useAppPolicy
local SharedFlags = require(AppShortcutBarParent.SharedFlags)
local FFlagLuaAppEnableStickyShortcutBar = SharedFlags.FFlagLuaAppEnableStickyShortcutBar
local FFlagGuacStickyShortcutBarEnabled = SharedFlags.FFlagGuacStickyShortcutBarEnabled

function AppShortcutBarContainer() -- line: 15
	-- upvalues: useAppShortcutBarProps (copy), FFlagGuacStickyShortcutBarEnabled (copy), useAppPolicy (copy), FFlagLuaAppEnableStickyShortcutBar (copy), useIsStickyShortcutBarEnabled (copy), React (copy), AppStickyShortcutBar (copy), AppShortcutBar2 (copy)
	local v12 = useAppShortcutBarProps()
	local v13 = if not FFlagGuacStickyShortcutBarEnabled then if not FFlagLuaAppEnableStickyShortcutBar then nil else useIsStickyShortcutBarEnabled() else useAppPolicy(function(p1) -- line: 20
		return p1.getStickyShortcutBarEnabled()
	end)

	if (FFlagLuaAppEnableStickyShortcutBar or FFlagGuacStickyShortcutBarEnabled) and v13 then
		return React.createElement(AppStickyShortcutBar, v12)
	end

	return React.createElement(AppShortcutBar2, v12)
end

return AppShortcutBarContainer
