local module = require("@luauforge/bundled/hId")
local sduiErrorType = module.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = module.getActionTelemetryFieldValue

local module2 = require("@luauforge/bundled/hHI")
local module3 = require("@luauforge/bundled/hHP")
local module4 = require("@luauforge/bundled/hIg")
local module5 = require("@luauforge/bundled/hIl")
local module6 = require("@luauforge/bundled/hIe")
local module7 = require("@luauforge/bundled/hKh")

local viewMessage = module6.ViewMessage

local v5 = { "viewName" }

local v6 = { "isFreeTrial", "productId", "isRedirect" }

local v7 = {
	[viewMessage.RobloxPlusFreeTrial] = v6,
	[viewMessage.RobloxPlusSubscribe] = v6
}

local function SduiBuyRobuxPurchaseFlowTelemetryHandler(p2, p3, p4)
	local function field(p5, p6)
		return getActionTelemetryFieldValue(p2, p3, p5, p6)
	end
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "viewMessage", nil)
	local v8

	if typeof(actionTelemetryFieldValue) == "string" then
		v8 = v7[actionTelemetryFieldValue]
	end

	local actionTelemetryFieldValues, v9

	if v8 then
		actionTelemetryFieldValues = {}
		v9 = {}

		for k, v10 in v8 do
			local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, v10, nil)

			actionTelemetryFieldValues[v10] = actionTelemetryFieldValue2

			if actionTelemetryFieldValue2 ~= nil then
				v9[v10] = tostring(actionTelemetryFieldValue2)
			end
		end
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "counterName", nil)

	if typeof(actionTelemetryFieldValue2) == "string" and actionTelemetryFieldValue2 ~= "" then
		module3.trackCounter(actionTelemetryFieldValue2, v9)
	end

	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(
		p2,
		p3,
		module2.PurchaseFlowUuidField,
		nil
	)

	if typeof(actionTelemetryFieldValue3) ~= "string" or actionTelemetryFieldValue3 == "" then
		return
	end

	local v10 = {}

	for k, v11 in v5 do
		if getActionTelemetryFieldValue(p2, p3, v11, nil) == nil then
			table.insert(v10, v11)
		end
	end

	if #v10 > 0 then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "BuyRobuxPurchaseFlowTelemetryHandler",
				message = `Missing telemetry fields: {table.concat(v10, ", ")}`
			},
			p4.appPage
		)
		return
	end

	if
		module5
		and (actionTelemetryFieldValue == viewMessage.RobloxPlusSubscribe or actionTelemetryFieldValue == viewMessage.RobloxPlusFreeTrial or getActionTelemetryFieldValue(p2, p3, "viewName", nil) == module6.ViewName.GiftCard and actionTelemetryFieldValue == viewMessage.BuyNow)
	then
		module4.get(actionTelemetryFieldValue3, p4.dependencies.eventIngest).flushPendingImpressions()
	end

	module7(p4.dependencies.eventIngest, {
		purchaseFlowUuid = actionTelemetryFieldValue3,
		viewName = getActionTelemetryFieldValue(p2, p3, "viewName", nil),
		purchaseEventType = getActionTelemetryFieldValue(
			p2,
			p3,
			"purchaseEventType",
			module6.EventType.UserInput
		),
		viewMessage = actionTelemetryFieldValue,
		eventMetadata = actionTelemetryFieldValues
	})
end

return SduiBuyRobuxPurchaseFlowTelemetryHandler
