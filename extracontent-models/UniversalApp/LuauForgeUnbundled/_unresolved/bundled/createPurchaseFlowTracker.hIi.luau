local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local module = require("@luauforge/bundled/hIj")
local module2 = require("@luauforge/bundled/hIk")
local module3 = require("@luauforge/bundled/hIl")
local module4 = require("@luauforge/bundled/hIe")
local module5 = require("@luauforge/bundled/hIm")

local viewName = module4.ViewName
local eventType = module4.EventType
local triggerContext = module4.TriggerContext

local v5 = module2 / 1000

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
	local v11 = false
	local clone = nil
	local v12 = false
	local v13 = nil
	local flag = false

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

	local function getImpressionMetadata()
		return {
			seenProducts = table.concat(orderedSet2.values(), ","),
			seenSections = table.concat(orderedSet.values(), ","),
			seenSubscriptionProducts = encodeSeenSubscriptionProducts(orderedSet3.values(), v9)
		}
	end

	local flushPendingImpressions
	local function trackFlow(productPurchaseImpression, userInput, p2, items)
		if flag or not module and v6 == nil then
			return
		end

		if v7 == nil then
			v7 = if productPurchaseImpression == viewName.PremiumPurchase then triggerContext.PremiumPurchase else triggerContext.RobuxPurchase
		end

		if module3 and v10 and userInput == eventType.ViewShown then
			local impressionMetadata = getImpressionMetadata()

			if v13 == nil then
				if productPurchaseImpression ~= viewName.ProductPurchase then
					flushPendingImpressions(false)
				end
			elseif
				impressionMetadata.seenProducts ~= v13.seenProducts
				or impressionMetadata.seenSections ~= v13.seenSections
				or impressionMetadata.seenSubscriptionProducts ~= v13.seenSubscriptionProducts
			then
				flushPendingImpressions(false)
			end
		end

		if getContextMetadata then
			local v14 = v8
			local contextMetadata = getContextMetadata()

			if contextMetadata ~= nil then
				for k, v15 in contextMetadata do
					local typeName = typeof(v15)

					if typeName ~= "string" then
						v15 = if typeName == "number" or typeName == "boolean" then tostring(v15) else nil
					end

					if v15 ~= nil then
						v14[k] = v15
					end
				end
			end
		end

		local v14 = v8

		if items ~= nil then
			for k, item in items do
				local typeName = typeof(item)

				if typeName ~= "string" then
					item = if typeName == "number" or typeName == "boolean" then tostring(item) else nil
				end

				if item ~= nil then
					v14[k] = item
				end
			end
		end

		if module3 then
			v12 = false
		end

		module5(TelemetryService, {
			triggerContext = v7,
			purchaseFlowUuid = purchaseFlowUuid,
			viewName = productPurchaseImpression,
			purchaseEventType = userInput,
			viewMessage = p2,
			eventMetadata = table.clone(v8)
		}, if module then v6 else nil)

		if module3 and userInput == eventType.ViewShown then
			v13 = getImpressionMetadata()
		end
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

		if module3 then
			v10 = true
			v11 = false

			if getContextMetadata then
				clone = table.clone(getContextMetadata())
				v12 = true
			end
		end

		local v14 = count
		delay2(v5, function()
			if v14 == count then
				if module3 then
					if module or v6 ~= nil then
						v10 = false
					else
						v11 = true
						return
					end
				end

				flushImpressions()
			end
		end)
	end

	flushPendingImpressions = function(p2)
		if flag or not v10 or not module and v6 == nil then
			return
		end

		count += 1
		v10 = false
		v11 = false

		if not p2 then
			flushImpressions()
			return
		end

		if clone then
			for k, v14 in clone do
				local typeName = typeof(v14)

				if typeName ~= "string" then
					v14 = if typeName == "number" or typeName == "boolean" then tostring(v14) else nil
				end

				if v14 ~= nil and (v12 or v8[k] == nil) then
					v8[k] = v14
				end
			end
		end

		local v14 = v8
		local impressionMetadata = getImpressionMetadata()

		if impressionMetadata ~= nil then
			for k, v15 in impressionMetadata do
				local typeName = typeof(v15)

				if typeName ~= "string" then
					v15 = if typeName == "number" or typeName == "boolean" then tostring(v15) else nil
				end

				if v15 ~= nil then
					v14[k] = v15
				end
			end
		end

		module5(TelemetryService, {
			triggerContext = v7 or triggerContext.RobuxPurchase,
			purchaseFlowUuid = purchaseFlowUuid,
			viewName = viewName.ProductPurchaseImpression,
			purchaseEventType = eventType.UserInput,
			eventMetadata = table.clone(v8)
		}, if module then v6 else nil)
	end

	return {
		setEventIngest = function(p2)
			if v6 == nil then
				v6 = p2

				if module3 and v6 ~= nil and v11 then
					flushPendingImpressions(false)
				end
			end
		end,
		trackFlow = trackFlow,
		getImpressionMetadata = getImpressionMetadata,
		flushPendingImpressions = function()
			flushPendingImpressions(false)
		end,
		addSeenSection = function(p2)
			if orderedSet.add(p2) then
				scheduleFlush()
			end
		end,
		addSeenProduct = function(p2)
			if orderedSet2.add(p2) then
				scheduleFlush()
			end
		end,
		addSeenSubscriptionProduct = function(p2, p3)
			if orderedSet3.add(p2) then
				v9[p2] = p3
				scheduleFlush()
			end
		end,
		getSecondsSincePageStarted = function()
			if pageStartedAt == nil then
				return nil
			end

			return clock() - pageStartedAt
		end,
		destroy = function()
			if module3 then
				flushPendingImpressions(true)
			end

			flag = true
			count += 1
		end
	}
end

return createPurchaseFlowTracker
