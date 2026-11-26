local HttpService = game:GetService("HttpService")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/DataHydration")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Promise")
local createDataCache = DataHydration.createDataCache
local createDataResolver = DataHydration.createDataResolver

require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/CanGiftResponseModel")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/FindRecipientsResponseModel")
local GiftModelUtils = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Models/GiftModelUtils")
local postCanGift = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postCanGift")
local postFindRecipients = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/WebApi/postFindRecipients")
local itemGiftabilityCacheKey = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Stores/itemGiftabilityCacheKey")
require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Types")

local dataStatus = DataHydration.DataStatus
local buildItemGiftabilityKey = itemGiftabilityCacheKey.buildItemGiftabilityKey
local parseItemGiftabilityKey = itemGiftabilityCacheKey.parseItemGiftabilityKey

local function buildRecipientsKey(data)
	local v5 = {}

	for k, item in data.items do
		table.insert(v5, buildItemGiftabilityKey(item))
	end

	return HttpService:JSONEncode({ v5, data.searchTerm or "", data.cursor or "" })
end

local function createCanGiftStore(data)
	local v5 = if data and data.postCanGift then data.postCanGift else postCanGift
	local v6 = if data and data.postFindRecipients then data.postFindRecipients else postFindRecipients

	local network = if data then data.network else nil

	local dataCache = createDataCache(45)

	local dataCache2 = createDataCache(45)
	local dataResolver = createDataResolver({
		cache = dataCache2,
		replaceItems = true,
		requestBatchSize = 20,
		queueProcessDelaySec = 0,
		fetchFn = function(items)
			local v7 = {}

			for k in items do
				local v8 = parseItemGiftabilityKey(k)

				if v8 ~= nil then
					table.insert(v7, v8)
				end
			end

			return v5({ items = v7 }, network):andThen(function(data2)
				dataCache.replaceItem("sender", {
					eligibility = data2.eligibility,
					requiredActions = data2.requiredActions
				})

				local result = {}

				for k, item in data2.items do
					result[buildItemGiftabilityKey(item.item)] = item
				end

				return result
			end):catch(function(p2)
				if dataCache.getItem("sender").status(false) ~= dataStatus.Ready then
					dataCache.markItemsAsFailed({ "sender" })
				end

				return Promise.reject(p2)
			end)
		end
	})

	local function isValidItem(p2)
		return p2 ~= nil and GiftModelUtils.nonEmptyString(p2.itemId)
	end

	local function invalidItemResult()
		local item = dataCache2.getItem("invalid")
		dataCache2.markItemsAsFailed({ "invalid" })
		return item
	end

	local v7 = {}

	local dataResolver2 = createDataResolver({
		cache = createDataCache(45, 0),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2)
			local v8 = v7[p2]
			local v10 = { items = v8.items, searchTerm = 0, limit = 25, cursor = 0 }
			local v11 = if v8.searchTerm ~= "" then v8.searchTerm else nil
			v10.searchTerm = v11

			v10.cursor = v8.cursor
			return v6(v10, network)
		end
	})

	local function recipientsKeyFor(p2)
		local recipientsKey = buildRecipientsKey(p2)
		v7[recipientsKey] = p2
		return recipientsKey
	end

	return {
		getSenderEligibility = function()
			return (dataCache.getItem("sender"))
		end,
		getAndFetchItemGiftability = function(p2)
			local v8 = not (p2 == nil) and GiftModelUtils.nonEmptyString(p2.itemId)

			if v8 then
				return (dataResolver.getAndFetchItem(buildItemGiftabilityKey(p2)))
			end

			local item = dataCache2.getItem("invalid")
			dataCache2.markItemsAsFailed({ "invalid" })
			return item
		end,
		getAndFetchItemGiftabilities = function(items)
			local v8 = {}
			local flag = false

			for k, item in items do
				local v9 = not (item == nil) and GiftModelUtils.nonEmptyString(item.itemId)

				if v9 then
					table.insert(v8, buildItemGiftabilityKey(item))
				else
					flag = true
				end
			end

			local fetchItems = dataResolver.getAndFetchItems(v8)

			if flag then
				local item = dataCache2.getItem("invalid")
				dataCache2.markItemsAsFailed({ "invalid" })

				fetchItems.invalid = item
			end

			return fetchItems
		end,
		getAndFetchRecipients = function(p2)
			local getAndFetchItem = dataResolver2.getAndFetchItem
			local recipientsKey = buildRecipientsKey(p2)
			v7[recipientsKey] = p2

			return (getAndFetchItem(recipientsKey))
		end,
		clear = function()
			dataCache.clear()
			dataResolver.clear()
			v7 = {}
			dataResolver2.clear()
		end,
		dispose = function()
			dataCache.dispose()
			dataResolver.dispose()
			v7 = {}
			dataResolver2.dispose()
		end
	}
end

return createCanGiftStore
