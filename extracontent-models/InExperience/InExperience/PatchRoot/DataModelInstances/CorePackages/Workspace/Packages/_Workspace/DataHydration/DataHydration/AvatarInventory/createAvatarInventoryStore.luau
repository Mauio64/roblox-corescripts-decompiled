local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
require(DataHydration.DataHydrationTypes)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)

local fetchAvatarInventoryPage = require(script.Parent.fetchAvatarInventoryPage)
require(script.Parent.AvatarInventoryStoreTypes)

local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local function createAvatarInventoryStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataCache = createDataCache()
	local dataCache2 = createDataCache()

	local count = 0

	local function storePage(items)
		local result = table.create(#items)
		local v3 = {}
		local v4 = {}

		for _, item in items do
			if item.itemId == nil then
				continue
			end

			local itemId = tostring(item.itemId)
			local itemType = item.itemCategory and item.itemCategory.itemType

			if itemType == Enum.AvatarItemType.Asset.Value then
				v3[itemId] = item
				table.insert(result, { itemType = "Asset", itemId = itemId })
			elseif itemType == Enum.AvatarItemType.Bundle.Value then
				v4[itemId] = item
				table.insert(result, { itemType = "Outfit", itemId = itemId })
			end
		end

		dataCache.replaceItems(v3)
		dataCache2.replaceItems(v4)
		return result
	end

	return {
		fetchPage = function(p, p2: string?)
			local localPlayerUserId = getLocalPlayerUserId()
			local v3 = count
			return fetchAvatarInventoryPage(p, p2, v2):andThen(function(p3)
				if v3 ~= count or localPlayerUserId ~= getLocalPlayerUserId() then
					error("AvatarInventory: dropped a page fetched before the store was reset")
				end

				return { items = storePage(p3.items), nextPageToken = p3.nextPageToken }
			end)
		end,
		getAsset = function(p: string)
			return (dataCache.getItem(p))
		end,
		getOutfit = function(p: string)
			return (dataCache2.getItem(p))
		end,
		clear = function()
			count += 1
			dataCache.clear()
			dataCache2.clear()
		end,
		dispose = function()
			count += 1
			dataCache.dispose()
			dataCache2.dispose()
		end
	}
end

return createAvatarInventoryStore
