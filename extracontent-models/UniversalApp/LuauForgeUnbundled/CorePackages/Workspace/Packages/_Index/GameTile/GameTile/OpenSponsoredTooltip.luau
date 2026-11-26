local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppEnums")
local centralOverlayType = RobloxAppEnums.CentralOverlayType
local appPage = RobloxAppEnums.AppPage
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/CentralOverlay").Actions.SetCentralOverlay
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/NavigationRodux").Thunks.NavigateDown
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Responsive")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RobloxAppNavigation").NavigationCommands else nil

return function(p2)
	return function(object)
		if p2 ~= Responsive.Input.Touch then
			object:dispatch(setCentralOverlay(centralOverlayType.SponsoredTooltip))

			return
		end

		local v5 = { name = appPage.SponsoredTooltipPeekView }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end
