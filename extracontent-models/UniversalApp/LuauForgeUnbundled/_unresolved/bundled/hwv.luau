local module = require("@luauforge/bundled/hww")

local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/hwx").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/hwy").NavigationCommands else nil

return {
	navigateDown = function(p2, callback)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(p2))
		else
			callback(module.Thunks.NavigateDown(p2))
		end
	end,
	navigateBack = function(callback)
		if fFlagSignalsNavP3Dispatch then
			navigationCommands.back()
		else
			callback(module.Thunks.NavigateBack())
		end
	end
}
