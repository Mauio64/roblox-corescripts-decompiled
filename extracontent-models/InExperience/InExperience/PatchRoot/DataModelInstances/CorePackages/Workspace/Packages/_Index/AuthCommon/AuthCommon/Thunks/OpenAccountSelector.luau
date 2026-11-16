local parent = script:FindFirstAncestor("AuthCommon").Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local CentralOverlayType = RobloxAppEnums.CentralOverlayType
local CentralOverlay = require(parent.CentralOverlay)
local SetCentralOverlay = CentralOverlay.Actions.SetCentralOverlay
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local RobloxAppEnums2 = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums2.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

return function(extraProps, p, p2)
	return function(object)
		if not p then
			object:dispatch(SetCentralOverlay(CentralOverlayType.AccountSelector, extraProps))

			return
		end

		if p2 then
			object:dispatch(SetCentralOverlay(CentralOverlayType.AccountSwitcher, extraProps))
			return
		end

		local v = { name = AppPage.AccountSelectorPeekView, extraProps = extraProps }

		if FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v))
		else
			object:dispatch(NavigateDown(v))
		end
	end
end
