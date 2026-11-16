local sduiErrorType = require("@luauforge/bundled/hwV").SduiErrors.SduiErrorType

local module = require("@luauforge/bundled/hwY")
local module2 = require("@luauforge/bundled/hwC")

local v5 = {}

local v6 = {
	Section = "BuyRobuxSection",
	Product = "BuyRobuxProduct",
	SubscriptionProduct = "BuyRobuxSubscriptionProduct"
}

local function toId(value)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	if typeof(value) == "number" then
		return (tostring(value))
	end

	return nil
end

local function reportError(p2, p3)
	p2.dependencies.logger.reportError(
		sduiErrorType.FailedToLogImpressions,
		{ name = "SduiBuyRobuxImpressionsHandler", message = p3 },
		p2.appPage
	)
end

local function SduiBuyRobuxImpressionsHandler(p2, items, p3, p4, p5)
	local v7 = p4 or v5
	local v8 = p3 or v5
	local v9 = v7[module2.PurchaseFlowUuidField]

	if typeof(v9) ~= "string" or v9 == "" then
		v9 = if typeof(v9) == "number" then tostring(v9) else nil
	end

	if v9 == nil then
		return
	end

	local contentType = v7.contentType

	if
		contentType == "BuyRobuxSection"
		or contentType == "BuyRobuxProduct"
		or contentType == "BuyRobuxSubscriptionProduct"
	then
		local v10 = module.get(v9, p2.dependencies.eventIngest)

		for k, item in items do
			local v11 = v8[item] or v5
			local id = v11.id

			if typeof(id) ~= "string" or id == "" then
				id = if typeof(id) == "number" then tostring(id) else nil
			end

			if id == nil then
				local formatted = `Missing id at index {item}`
				p2.dependencies.logger.reportError(
					sduiErrorType.FailedToLogImpressions,
					{ name = "SduiBuyRobuxImpressionsHandler", message = formatted },
					p2.appPage
				)
			elseif contentType == "BuyRobuxSection" then
				v10.addSeenSection(id)
			elseif contentType == "BuyRobuxProduct" then
				v10.addSeenProduct(id)
			else
				local subscriptionProductType = v11.subscriptionProductType
				v10.addSeenSubscriptionProduct(
					id,
					typeof(subscriptionProductType) ~= "string" and "" or subscriptionProductType
				)
			end
		end
	else
		local formatted = `Unknown contentType: {tostring(contentType)}`
		p2.dependencies.logger.reportError(
			sduiErrorType.FailedToLogImpressions,
			{ name = "SduiBuyRobuxImpressionsHandler", message = formatted },
			p2.appPage
		)
	end
end

return SduiBuyRobuxImpressionsHandler
