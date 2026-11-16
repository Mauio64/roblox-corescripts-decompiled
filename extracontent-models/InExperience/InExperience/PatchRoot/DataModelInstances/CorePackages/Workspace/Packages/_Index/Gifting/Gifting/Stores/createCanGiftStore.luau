local HttpService = game:GetService("HttpService")

local Gifting = script:FindFirstAncestor("Gifting")
local parent = Gifting.Parent

local DataHydration = require(parent.DataHydration)
local Promise = require(parent.Promise)
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

require(Gifting.Models.CanGiftResponseModel)
require(Gifting.Models.FindRecipientsResponseModel)
local GiftModelUtils = require(Gifting.Models.GiftModelUtils)
local postCanGift = require(Gifting.WebApi.postCanGift)
local postFindRecipients = require(Gifting.WebApi.postFindRecipients)
local itemGiftabilityCacheKey = require(Gifting.Stores.itemGiftabilityCacheKey)
require(Gifting.Types)

local DataStatus = DataHydration.DataStatus
local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey
local parseItemGiftabilityKey = itemGiftabilityCacheKey.parseItemGiftabilityKey

local function buildRecipientsKey(data)
	local v = {}

	for _, item in data.items do
		table.insert(v, buildItemGiftabilityKey(item))
	end

	return HttpService:JSONEncode({ v, data.searchTerm or "", data.cursor or "" })
end

local function createCanGiftStore(data)
	local v

	if data and data.postCanGift then
		v = data.postCanGift
	else
		v = postCanGift
	end

	local v2

	if data and data.postFindRecipients then
		v2 = data.postFindRecipients
	else
		v2 = postFindRecipients
	end

	local network

	if data then
		network = data.network
	else
		network = nil
	end

	local dataCache = createDataCache(45)

	local dataCache2 = createDataCache(45)
	local dataResolver = createDataResolver({
		cache = dataCache2,
		replaceItems = true,
		requestBatchSize = 20,
		queueProcessDelaySec = 0,
		fetchFn = function(items)
			local items2 = {}

			for k in items do
				local v3 = parseItemGiftabilityKey(k)

				if v3 ~= nil then
					table.insert(items2, v3)
				end
			end

			return v({ items = items2 }, network):andThen(function(data2)
				dataCache.replaceItem("sender", {
					eligibility = data2.eligibility,
					requiredActions = data2.requiredActions
				})

				local result = {}

				for _, item in data2.items do
					result[buildItemGiftabilityKey(item.item)] = item
				end

				return result
			end):catch(function(p)
				if dataCache.getItem("sender").status(false) ~= DataStatus.Ready then
					dataCache.markItemsAsFailed({ "sender" })
				end

				return Promise.reject(p)
			end)
		end
	})

	local function isValidItem(p) -- 2 equivalent calls inferred from this helper
		return p ~= nil and GiftModelUtils.nonEmptyString(p.itemId)
	end

	local function invalidItemResult() -- 2 equivalent calls inferred from this helper
		local item = dataCache2.getItem("invalid")
		dataCache2.markItemsAsFailed({ "invalid" })
		return item
	end

	local v3 = {}

	local dataResolver2 = createDataResolver({
		cache = createDataCache(45, 0),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string)
			local v4 = v3[p]
			local v5 = { items = v4.items, searchTerm = 0, limit = 25, cursor = 0 }
			local searchTerm

			if v4.searchTerm ~= "" then
				searchTerm = v4.searchTerm
			end

			v5.searchTerm = searchTerm

			v5.cursor = v4.cursor
			return v2(v5, network)
		end
	})

	local function recipientsKeyFor(p) -- 1 equivalent call inferred from this helper
		local recipientsKey = buildRecipientsKey(p)
		v3[recipientsKey] = p
		return recipientsKey
	end

	return {
		getSenderEligibility = function()
			return (dataCache.getItem("sender"))
		end,
		getAndFetchItemGiftability = function(p)
			if isValidItem(p) then -- inferred equivalent call
				return (dataResolver.getAndFetchItem(buildItemGiftabilityKey(p)))
			end

			return invalidItemResult() -- inferred equivalent call
		end,
		getAndFetchItemGiftabilities = function(items)
			local v4 = {}
			local flag = false

			for _, item in items do
				if isValidItem(item) then -- inferred equivalent call
					table.insert(v4, buildItemGiftabilityKey(item))
				else
					flag = true
				end
			end

			local fetchItems = dataResolver.getAndFetchItems(v4)

			if flag then
				fetchItems.invalid = invalidItemResult() -- inferred equivalent call
			end

			return fetchItems
		end,
		getAndFetchRecipients = function(p)
			return (dataResolver2.getAndFetchItem(recipientsKeyFor(p))) -- inferred equivalent call
		end,
		clear = function()
			dataCache.clear()
			dataResolver.clear()
			v3 = {}
			dataResolver2.clear()
		end,
		dispose = function()
			dataCache.dispose()
			dataResolver.dispose()
			v3 = {}
			dataResolver2.dispose()
		end
	}
end

return createCanGiftStore
