local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppEnums").AppPage
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/NavigationRodux")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpV2Wizard/RobloxAppNavigation").NavigationCommands

return function(p2)
	return function(object)
		local v5 = { name = appPage.AmpV2Wizard, extraProps = p2 }
		local v6

		if fFlagSignalsNavP3Dispatch then
			v6 = NavigationRodux.GetLegacyNavigationStore(false).getCurrentPage(false)
		else
			v6 = NavigationRodux.Selectors.selectCurrentLegacyPage(object:getState())
		end

		local extraProps = v6.extraProps
		local odpSessionId

		if p2.flow and p2.flow.name == "OdpCheckpointResume" then
			odpSessionId = p2.flow.props.odpSessionId
		end

		if
			odpSessionId
			and v6.name == appPage.AmpV2Wizard
			and extraProps
			and extraProps.flow
			and extraProps.flow.name == "OdpCheckpointResume"
			and extraProps.flow.props.odpSessionId == odpSessionId
		then
			return
		end

		local v7 = v6.name == appPage.GenericWebPage

		if fFlagSignalsNavP3Dispatch then
			if v7 then
				navigationCommands.fromWebView(navigationCommands.fromLegacyPage(v5), true)
			else
				navigationCommands.down(navigationCommands.fromLegacyPage(v5), true)
			end
		elseif v7 then
			object:dispatch(NavigationRodux.Thunks.NavigateFromWebView(v5, true))
		else
			object:dispatch(NavigationRodux.Thunks.NavigateDown(v5, true))
		end
	end
end
