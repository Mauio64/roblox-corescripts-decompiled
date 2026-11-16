local module = require("@luauforge/bundled/dCp")
local module2 = require("@luauforge/bundled/dwL")
local module3 = require("@luauforge/bundled/eee")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dCu").NavigationCommands else nil

if require("@luauforge/bundled/edD")() then
	return function(p2, p3)
		module2.isType(p2, "string", "url")
		module2.isType(p3, "string", "titleKey")

		return function(object)
			local v5 = {
				name = module.GenericWebPage,
				detail = p2,
				extraProps = { titleKey = p3 }
			}

			if fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage(v5))
			else
				object:dispatch(module3(v5))
			end
		end
	end
end

return function(value, value2)
	assert(
		type(value) == "string",
		string.format("OpenWebview thunk expects url to be a string, was %s", (type(value)))
	)
	assert(
		type(value2) == "string",
		string.format("OpenWebview thunk expects title to be a string, was %s", (type(string)))
	)

	return function(object)
		local v5 = {
			name = module.GenericWebPage,
			detail = value,
			extraProps = { title = value2 }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(module3(v5))
		end
	end
end
