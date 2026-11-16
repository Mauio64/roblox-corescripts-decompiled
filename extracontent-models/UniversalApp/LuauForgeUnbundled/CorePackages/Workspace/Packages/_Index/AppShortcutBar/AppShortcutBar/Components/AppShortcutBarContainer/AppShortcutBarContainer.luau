local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Cryo")
local AppShortcutBar = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcutBar")
local AppStickyShortcutBar = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppStickyShortcutBar")

local useAppShortcutBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AppShortcutBar/AppShortcutBar/Components/AppShortcutBarContainer/useAppShortcutBarProps")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/UniversalAppPolicy").useAppPolicy

local fFlagEnableStickyShortcutBarOnAllPlatforms = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SharedFlags").FFlagEnableStickyShortcutBarOnAllPlatforms

function LUAUFORGE_MODULE_GLOBALS_bQb_AppShortcutBarContainer(p2)
	local joined = useAppShortcutBarProps()

	if not (useAppPolicy(function(p3)
		return p3.getStickyShortcutBarEnabled()
	end) or fFlagEnableStickyShortcutBarOnAllPlatforms) then
		return React.createElement(AppShortcutBar, joined)
	end

	local createElement = React.createElement

	if fFlagEnableStickyShortcutBarOnAllPlatforms then
		joined = Cryo.Dictionary.join(joined, {
			isLeftNavVisible = p2.isLeftNavVisible,
			currentPage = p2.currentPage
		})
	end

	return createElement(AppStickyShortcutBar, joined)
end

return LUAUFORGE_MODULE_GLOBALS_bQb_AppShortcutBarContainer
