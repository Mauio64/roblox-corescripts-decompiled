local parent = script:FindFirstAncestor("GameTile").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local AppPage = RobloxAppEnums.AppPage
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local Responsive = require(parent.Responsive)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

return function(p)
	return function(object)
		if p ~= Responsive.Input.Touch then
			object:dispatch(SetCentralOverlay(CentralOverlayType.SponsoredTooltip))

			return
		end

		local v = { name = AppPage.SponsoredTooltipPeekView }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v))
		else
			object:dispatch(NavigateDown(v))
		end
	end
end
