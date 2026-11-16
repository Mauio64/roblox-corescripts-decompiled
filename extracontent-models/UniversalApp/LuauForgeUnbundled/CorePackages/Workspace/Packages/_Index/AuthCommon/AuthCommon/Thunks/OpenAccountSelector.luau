local centralOverlayType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").CentralOverlayType
local setCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/CentralOverlay").Actions.SetCentralOverlay
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/NavigationRodux").Thunks.NavigateDown
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").AppPage
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppNavigation").NavigationCommands else nil

return function(p2, p3, p4)
	return function(object)
		if not p3 then
			object:dispatch(setCentralOverlay(centralOverlayType.AccountSelector, p2))

			return
		end

		if p4 then
			object:dispatch(setCentralOverlay(centralOverlayType.AccountSwitcher, p2))
			return
		end

		local v5 = { name = appPage.AccountSelectorPeekView, extraProps = p2 }

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(navigateDown(v5))
		end
	end
end
