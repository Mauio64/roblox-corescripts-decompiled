local module = require("@luauforge/bundled/hwV")
local getSduiImpressionHandlerRegistry = module.getSduiImpressionHandlerRegistry

local function registerBuyRobuxSduiImpressions()
	local v5 = {
		[module.SduiImpressionEventType.buyRobuxImpressions] = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyV")
			end,
			skipItemImpressionsLog = true
		}
	}

	getSduiImpressionHandlerRegistry().registerImpressionHandlerConfigs(v5)
end

return registerBuyRobuxSduiImpressions
