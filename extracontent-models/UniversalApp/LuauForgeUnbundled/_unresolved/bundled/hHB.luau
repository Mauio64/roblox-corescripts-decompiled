local module = require("@luauforge/bundled/hHC")

local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/hHD").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/hHE").NavigationCommands else nil

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
