local module = require("@luauforge/bundled/hId")
local getSduiImpressionHandlerRegistry = module.getSduiImpressionHandlerRegistry

local function registerBuyRobuxSduiImpressions()
	local v5 = {
		[module.SduiImpressionEventType.buyRobuxImpressions] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKl")
			end,
			skipItemImpressionsLog = true
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v5)
end

return registerBuyRobuxSduiImpressions
