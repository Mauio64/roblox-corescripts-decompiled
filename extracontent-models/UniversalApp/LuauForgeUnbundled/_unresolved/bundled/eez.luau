local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

return function()
	return function(object)
		local v5 = {
			name = module.GenericWebPage,
			detail = "https://en.help.roblox.com/hc/articles/7416652004884",
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5), nil)
		else
			object:dispatch(module2(v5, nil))
		end
	end
end
