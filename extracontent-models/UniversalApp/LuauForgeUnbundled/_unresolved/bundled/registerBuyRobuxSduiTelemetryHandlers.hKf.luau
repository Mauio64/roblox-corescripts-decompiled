local getSduiTelemetryHandlerNameRegistry = require("@luauforge/bundled/hId").getSduiTelemetryHandlerNameRegistry

local function registerBuyRobuxSduiTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		BuyRobuxPurchaseFlow = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKg")
			end
		},
		BuyRobuxGiftCard = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKi")
			end
		},
		BuyRobuxCounter = {
			lazyHandler = function()
				return require("@luauforge/bundled/hKj")
			end
		}
	})
end

return registerBuyRobuxSduiTelemetryHandlers
