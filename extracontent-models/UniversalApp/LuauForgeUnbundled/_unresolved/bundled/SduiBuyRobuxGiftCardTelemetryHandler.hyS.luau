local getActionTelemetryFieldValue = require("@luauforge/bundled/hwV").getActionTelemetryFieldValue

local module = require("@luauforge/bundled/hwC")
local module2 = require("@luauforge/bundled/hwW")
local module3 = require("@luauforge/bundled/hyR")

local function SduiBuyRobuxGiftCardTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, module.PurchaseFlowUuidField)

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	module3(p4.dependencies.eventIngest, {
		purchaseFlowUuid = actionTelemetryFieldValue,
		viewName = module2.ViewName.GiftCard,
		purchaseEventType = module2.EventType.UserInput,
		viewMessage = module2.ViewMessage.BuyNow
	})
end

return SduiBuyRobuxGiftCardTelemetryHandler
