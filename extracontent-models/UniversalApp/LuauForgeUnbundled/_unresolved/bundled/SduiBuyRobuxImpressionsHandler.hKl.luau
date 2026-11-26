local module = require("@luauforge/bundled/hId")
local appPage = require("@luauforge/bundled/hHo").AppPage
local getSduiApiStore = require("@luauforge/bundled/hHx").getSduiApiStore
local sduiErrorType = module.SduiErrors.SduiErrorType

local module2 = require("@luauforge/bundled/hIg")
local module3 = require("@luauforge/bundled/hHI")
local module4 = require("@luauforge/bundled/hIc")
local module5 = require("@luauforge/bundled/hHZ")
local module6 = require("@luauforge/bundled/hIe")

local module7 = require("@luauforge/bundled/hHJ")

local defineFastString = game:DefineFastString(
	"BuyRobuxSduiReadinessExcludedSectionIds",
	module6.SectionType.Transfers
)

local set = {}

if module7 then
	for k in string.gmatch(defineFastString, "[^,%s]+") do
		set[k] = true
	end
end

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

local function isImpressionFromCurrentResponse(p2): boolean
	local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(appPage.BuyRobux, false)
	return dataUpdatedTimestamp ~= nil and p2.dataUpdatedTimestamp == dataUpdatedTimestamp
end

local function SduiBuyRobuxImpressionsHandler(data, items, p2, p3, p4)
	local v7 = p3 or v5
	local v8 = p2 or v5
	local v9 = v7[module3.PurchaseFlowUuidField]

	if typeof(v9) ~= "string" or v9 == "" then
		v9 = if typeof(v9) == "number" then tostring(v9) else nil
	end

	if module7 then
		local dataUpdatedTimestamp = getSduiApiStore().getDataUpdatedTimestamp(appPage.BuyRobux, false)
		local v10 = not (dataUpdatedTimestamp == nil) and data.dataUpdatedTimestamp == dataUpdatedTimestamp

		if not v10 then
			return
		end

		local v11 = module5()
		local purchase_flow_id = if v11 then v11.purchase_flow_id else nil

		if typeof(purchase_flow_id) ~= "string" or purchase_flow_id == "" then
			purchase_flow_id = if typeof(purchase_flow_id) == "number" then tostring(purchase_flow_id) else nil
		end

		v9 = purchase_flow_id or v9
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
		local v10 = module2.get(v9, data.dependencies.eventIngest)
		local v11 = false

		for k, item in items do
			local v12 = v8[item] or v5
			local id = v12.id

			if typeof(id) ~= "string" or id == "" then
				id = if typeof(id) == "number" then tostring(id) else nil
			end

			if id == nil then
				local formatted = `Missing id at index {item}`
				data.dependencies.logger.reportError(
					sduiErrorType.FailedToLogImpressions,
					{ name = "SduiBuyRobuxImpressionsHandler", message = formatted },
					data.appPage
				)
			elseif contentType == "BuyRobuxSection" then
				v10.addSeenSection(id)

				if
					module7
					and set[id] ~= true
					and id ~= module.SduiCollectionAnalyticsBuilder.DUMMY_ITEM_DATA.id
				then
					v11 = true
				end
			elseif contentType == "BuyRobuxProduct" then
				v10.addSeenProduct(id)
			else
				local subscriptionProductType = v12.subscriptionProductType
				v10.addSeenSubscriptionProduct(
					id,
					typeof(subscriptionProductType) ~= "string" and "" or subscriptionProductType
				)
			end
		end

		if module7 and v11 then
			module4().set(module3.PageScopeFieldHasRenderedSduiContent, true)
		end
	else
		local formatted = `Unknown contentType: {tostring(contentType)}`
		data.dependencies.logger.reportError(
			sduiErrorType.FailedToLogImpressions,
			{ name = "SduiBuyRobuxImpressionsHandler", message = formatted },
			data.appPage
		)
	end
end

return SduiBuyRobuxImpressionsHandler
