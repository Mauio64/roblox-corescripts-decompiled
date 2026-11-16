local getSduiTelemetryHandlerNameRegistry = require("@luauforge/bundled/hwV").getSduiTelemetryHandlerNameRegistry

local function registerBuyRobuxSduiTelemetryHandlers()
	getSduiTelemetryHandlerNameRegistry().registerTelemetryHandlers({
		BuyRobuxPurchaseFlow = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyQ")
			end
		},
		BuyRobuxGiftCard = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyS")
			end
		},
		BuyRobuxCounter = {
			lazyHandler = function()
				return require("@luauforge/bundled/hyT")
			end
		}
	})
end

return registerBuyRobuxSduiTelemetryHandlers
