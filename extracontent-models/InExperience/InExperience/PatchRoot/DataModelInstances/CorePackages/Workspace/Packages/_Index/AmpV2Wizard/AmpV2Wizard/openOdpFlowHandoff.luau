local parent = script.Parent.Parent
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local NavigationRodux = require(parent.NavigationRodux)
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local NavigationCommands = RobloxAppNavigation.NavigationCommands

return function(extraProps2)
	return function(object)
		local v = { name = AppPage.AmpV2Wizard, extraProps = extraProps2 }
		local v2

		if FFlagSignalsNavP3Dispatch then
			v2 = NavigationRodux.GetLegacyNavigationStore(false).getCurrentPage(false)
		else
			v2 = NavigationRodux.Selectors.selectCurrentLegacyPage(object:getState())
		end

		local extraProps = v2.extraProps
		local odpSessionId

		if extraProps2.flow and extraProps2.flow.name == "OdpCheckpointResume" then
			odpSessionId = extraProps2.flow.props.odpSessionId
		end

		if
			odpSessionId
			and v2.name == AppPage.AmpV2Wizard
			and extraProps
			and extraProps.flow
			and extraProps.flow.name == "OdpCheckpointResume"
			and extraProps.flow.props.odpSessionId == odpSessionId
		then
			return
		end

		local v3 = v2.name == AppPage.GenericWebPage

		if FFlagSignalsNavP3Dispatch then
			if v3 then
				NavigationCommands.fromWebView(NavigationCommands.fromLegacyPage(v), true)
			else
				NavigationCommands.down(NavigationCommands.fromLegacyPage(v), true)
			end
		elseif v3 then
			object:dispatch(NavigationRodux.Thunks.NavigateFromWebView(v, true))
		else
			object:dispatch(NavigationRodux.Thunks.NavigateDown(v, true))
		end
	end
end
