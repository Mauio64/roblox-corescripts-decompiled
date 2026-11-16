local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/hxb")
local module2 = require("@luauforge/bundled/hwW")
local module3 = require("@luauforge/bundled/hxc")

local viewName = module2.ViewName
local eventType = module2.EventType
local triggerContext = module2.TriggerContext

local v5 = module / 1000

local function toMetadataString(p2)
	local typeName = typeof(p2)

	if typeName == "string" then
		return p2
	end

	if typeName == "number" or typeName == "boolean" then
		return (tostring(p2))
	end

	return nil
end

local function createOrderedSet()
	local v6 = {}
	local set = {}
	return {
		add = function(p2): boolean
			if set[p2] then
				return false
			end

			set[p2] = true
			table.insert(v6, p2)
			return true
		end,
		values = function()
			return v6
		end
	}
end

local function encodeSeenSubscriptionProducts(list, p2)
	local v6 = table.create(#list)

	for k, item in list do
		table.insert(
			v6,
			`\{"subscriptionProductId":{HttpService:JSONEncode(item)},"subscriptionProductType":{HttpService:JSONEncode(p2[item])}}`
		)
	end

	return `[{table.concat(v6, ",")}]`
end

local function createPurchaseFlowTracker(data)
	local purchaseFlowUuid = data.purchaseFlowUuid
	local v6 = data.eventIngest
	local delay2 = data.delay or task.delay
	local clock = data.clock or os.clock

	local v7 = nil
	local pageStartedAt = data.pageStartedAt
	local getContextMetadata = data.getContextMetadata
	local v8 = {}

	local orderedSet = createOrderedSet()
	local orderedSet2 = createOrderedSet()
	local orderedSet3 = createOrderedSet()
	local v9 = {}
	local count = 0
	local v10 = false

	local function mergeInto(p2, items)
		if items == nil then
			return
		end

		for k, item in items do
			local typeName = typeof(item)

			if typeName ~= "string" then
				item = if typeName == "number" or typeName == "boolean" then tostring(item) else nil
			end

			if item ~= nil then
				p2[k] = item
			end
		end
	end

	local function trackFlow(productPurchaseImpression, userInput, p2, items)
		if v10 or v6 == nil then
			return
		end

		if v7 == nil then
			v7 = if productPurchaseImpression == viewName.PremiumPurchase then triggerContext.PremiumPurchase else triggerContext.RobuxPurchase
		end

		if getContextMetadata then
			local v11 = v8
			local contextMetadata = getContextMetadata()

			if contextMetadata ~= nil then
				for k, v12 in contextMetadata do
					local typeName = typeof(v12)

					if typeName ~= "string" then
						v12 = if typeName == "number" or typeName == "boolean" then tostring(v12) else nil
					end

					if v12 ~= nil then
						v11[k] = v12
					end
				end
			end
		end

		local v11 = v8

		if items ~= nil then
			for k, item in items do
				local typeName = typeof(item)

				if typeName ~= "string" then
					item = if typeName == "number" or typeName == "boolean" then tostring(item) else nil
				end

				if item ~= nil then
					v11[k] = item
				end
			end
		end

		module3(TelemetryService, {
			triggerContext = v7,
			purchaseFlowUuid = purchaseFlowUuid,
			viewName = productPurchaseImpression,
			purchaseEventType = userInput,
			viewMessage = p2,
			eventMetadata = table.clone(v8)
		})
	end

	local function flushImpressions()
		trackFlow(viewName.ProductPurchaseImpression, eventType.UserInput, nil, {
			seenProducts = table.concat(orderedSet2.values(), ","),
			seenSections = table.concat(orderedSet.values(), ","),
			seenSubscriptionProducts = encodeSeenSubscriptionProducts(orderedSet3.values(), v9)
		})
	end

	local function scheduleFlush()
		count += 1
		local v11 = count
		delay2(v5, function()
			if v11 == count then
				flushImpressions()
			end
		end)
	end

	return {
		setEventIngest = function(p2)
			if v6 == nil then
				v6 = p2
			end
		end,
		trackFlow = trackFlow,
		addSeenSection = function(p2)
			if orderedSet.add(p2) then
				count += 1
				local v11 = count
				delay2(v5, function()
					if v11 == count then
						flushImpressions()
					end
				end)
			end
		end,
		addSeenProduct = function(p2)
			if orderedSet2.add(p2) then
				count += 1
				local v11 = count
				delay2(v5, function()
					if v11 == count then
						flushImpressions()
					end
				end)
			end
		end,
		addSeenSubscriptionProduct = function(p2, p3)
			if orderedSet3.add(p2) then
				v9[p2] = p3
				count += 1
				local v11 = count
				delay2(v5, function()
					if v11 == count then
						flushImpressions()
					end
				end)
			end
		end,
		getSecondsSincePageStarted = function()
			if pageStartedAt == nil then
				return nil
			end

			return clock() - pageStartedAt
		end,
		destroy = function()
			v10 = true
			count += 1
		end
	}
end

return createPurchaseFlowTracker
