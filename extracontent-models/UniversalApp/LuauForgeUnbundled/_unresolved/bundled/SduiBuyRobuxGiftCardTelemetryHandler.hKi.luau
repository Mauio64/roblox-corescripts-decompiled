local getActionTelemetryFieldValue = require("@luauforge/bundled/hId").getActionTelemetryFieldValue

local module = require("@luauforge/bundled/hHI")
local module2 = require("@luauforge/bundled/hIg")
local module3 = require("@luauforge/bundled/hIl")
local module4 = require("@luauforge/bundled/hIe")
local module5 = require("@luauforge/bundled/hKh")

local function SduiBuyRobuxGiftCardTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, module.PurchaseFlowUuidField)

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	if module3 then
		module2.get(actionTelemetryFieldValue, p4.dependencies.eventIngest).flushPendingImpressions()
	end

	module5(p4.dependencies.eventIngest, {
		purchaseFlowUuid = actionTelemetryFieldValue,
		viewName = module4.ViewName.GiftCard,
		purchaseEventType = module4.EventType.UserInput,
		viewMessage = module4.ViewMessage.BuyNow
	})
end

return SduiBuyRobuxGiftCardTelemetryHandler
