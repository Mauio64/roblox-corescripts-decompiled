local AppShortcutBar = script:FindFirstAncestor("AppShortcutBar")
local parent = AppShortcutBar.Parent
local React = require(parent.React)
local Cryo = require(parent.Cryo)
local AppShortcutBar2 = require(AppShortcutBar.Components.AppShortcutBar)
local AppStickyShortcutBar = require(AppShortcutBar.Components.AppStickyShortcutBar)

local useAppShortcutBarProps = require(script.Parent.useAppShortcutBarProps)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableStickyShortcutBarOnAllPlatforms = SharedFlags.FFlagEnableStickyShortcutBarOnAllPlatforms

function AppShortcutBarContainer(p)
	local joined = useAppShortcutBarProps()

	if not (useAppPolicy(function(p2)
		return p2.getStickyShortcutBarEnabled()
	end) or FFlagEnableStickyShortcutBarOnAllPlatforms) then
		return React.createElement(AppShortcutBar2, joined)
	end

	local createElement = React.createElement

	if FFlagEnableStickyShortcutBarOnAllPlatforms then
		joined = Cryo.Dictionary.join(joined, {
			isLeftNavVisible = p.isLeftNavVisible,
			currentPage = p.currentPage
		})
	end

	return createElement(AppStickyShortcutBar, joined)
end

return AppShortcutBarContainer
