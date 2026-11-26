local module = require("@luauforge/bundled/dFu")
local module2 = require("@luauforge/bundled/ehB")
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3Dispatch
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local function openRefundPolicyLearnMorePage(p2)
	return function(object)
		local v5 = {
			name = module.GenericWebPage,
			detail = p2,
			extraProps = { title = "" }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v5))
		else
			object:dispatch(module2(v5))
		end
	end
end

return openRefundPolicyLearnMorePage
