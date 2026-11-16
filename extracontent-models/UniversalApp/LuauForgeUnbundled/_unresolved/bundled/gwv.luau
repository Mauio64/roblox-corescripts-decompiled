local appPage = require("@luauforge/bundled/gvP").AppPage
local module = require("@luauforge/bundled/gww")
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/gvp").FFlagSignalsNavP3Dispatch
local navigationCommands = require("@luauforge/bundled/gwx").NavigationCommands

return function(p2)
	return function(object)
		local v5 = { name = appPage.AmpV2Wizard, extraProps = p2 }
		local v6

		if fFlagSignalsNavP3Dispatch then
			v6 = module.GetLegacyNavigationStore(false).getCurrentPage(false)
		else
			v6 = module.Selectors.selectCurrentLegacyPage(object:getState())
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
			object:dispatch(module.Thunks.NavigateFromWebView(v5, true))
		else
			object:dispatch(module.Thunks.NavigateDown(v5, true))
		end
	end
end
