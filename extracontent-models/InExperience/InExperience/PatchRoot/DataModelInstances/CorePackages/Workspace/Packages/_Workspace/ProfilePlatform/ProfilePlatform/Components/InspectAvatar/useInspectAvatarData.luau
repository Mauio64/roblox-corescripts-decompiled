local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Dash = require(parent.Dash)
local Promise = require(parent.Promise)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local CatalogNetworking = require(parent.CatalogNetworking)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useLocalUserId = RobloxAppHooks.useLocalUserId

local Enums = require(ProfilePlatform.Common.Enums)
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)

local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)
require(ProfilePlatform.Common.Types)

local PurchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local CollectibleProductIdStore = CatalogNetworking.CollectibleProductIdStore
local BundleOwnershipStore = CatalogNetworking.BundleOwnershipStore
local ItemDetailsStore = CatalogNetworking.ItemDetailsStore

local function useLookApiData(list)
	local cache = useSignalState(PurchaseDetailsStore.getCache)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)

	React.useEffect(function()
		if #list == 0 then
			setState2(false)
			return
		end

		local array = Dash.collectArray(list, function(_, p)
			if p.itemType == Enums.ItemTypes.Bundle then
				return nil
			end

			return {
				id = tonumber(p.assetId) or p.assetId
			}
		end)

		if #array == 0 then
			setState2(false)
			return
		end

		setState2(true)
		setState({})
		PurchaseDetailsStore.fetchAll(myRoduxNetworkingImpl, array):andThen(function(p)
			if p and p.look and p.look.items then
				setState((Dash.map(p.look.items, function(p2)
					return (tostring(p2.id))
				end)))
			end
		end, function(p)
			warn("[useInspectAvatarData] Failed to fetch purchase details:", (tostring(p)))
		end):finally(function()
			setState2(false)
		end)
	end, { list })

	return { responseIds = state, cache = cache, isLoading = state2 }
end

local function useCatalogEnrichment(p, list)
	local catalogDetails = useSignalState(ItemDetailsStore.getCache)
	local state, setState = React.useState(true)
	local collectibleCache = useSignalState(CollectibleProductIdStore.getCache)
	local ownershipCache = useSignalState(BundleOwnershipStore.getCache)

	React.useEffect(function()
		if p.isLoading then
			return
		end

		if #list == 0 then
			setState(false)
			return
		end

		local itemTypesByAssetId = {}
		local assetIds = {}

		for _, item in list do
			itemTypesByAssetId[tostring(item.assetId)] = item.itemType or "Asset"

			if item.itemType ~= Enums.ItemTypes.Bundle then
				continue
			end

			local assetId = tonumber(item.assetId)

			if assetId then
				table.insert(assetIds, assetId)
			end
		end

		local set = {}
		local v = {}

		for _, responseId in p.responseIds do
			local id = tonumber(responseId)

			if not id or set[responseId] then
				continue
			end

			set[responseId] = true
			table.insert(v, {
				id = id,
				itemType = itemTypesByAssetId[responseId] or "Bundle"
			})
		end

		for _, item in list do
			local assetId = tostring(item.assetId)
			local assetId2 = tonumber(item.assetId)

			if not assetId2 or set[assetId] then
				continue
			end

			set[assetId] = true
			table.insert(v, {
				id = assetId2,
				itemType = item.itemType or "Asset"
			})
		end

		if #v == 0 and #assetIds == 0 then
			setState(false)
			return
		end

		setState(true)
		local v2

		if #v > 0 then
			v2 = ItemDetailsStore.fetchAndCache(myRoduxNetworkingImpl, v)
		else
			v2 = Promise.resolve()
		end

		local v3

		if #assetIds > 0 then
			v3 = BundleOwnershipStore.fetchAndCache(myRoduxNetworkingImpl, assetIds):catch(function(p2)
				warn("[useInspectAvatarData] Failed to fetch bundle ownership:", (tostring(p2)))
			end)
		else
			v3 = Promise.resolve()
		end

		Promise.all({ v2, v3 }):andThen(function()
			setState(false)
		end):catch(function(p2)
			warn("[useInspectAvatarData] Failed to fetch catalog details:", (tostring(p2)))
			setState(false)
		end)
	end, { p.responseIds, p.isLoading, list })

	React.useEffect(function()
		local collectibleItemIdSet = {}
		local collectibleItemIds = {}

		for _, item in list do
			local v = catalogDetails[tostring(item.assetId)]

			if not (v and v.collectibleItemId) then
				continue
			end

			local collectibleItemId = v.collectibleItemId

			if collectibleItemIdSet[collectibleItemId] then
				continue
			end

			local v2

			if item.itemType == Enums.ItemTypes.Bundle then
				v2 = not v.isOffSale
			else
				v2 = false
			end

			local hasResellers = v.hasResellers == true

			if not (v2 or hasResellers) then
				continue
			end

			collectibleItemIdSet[collectibleItemId] = true
			table.insert(collectibleItemIds, collectibleItemId)
		end

		for _, responseId in p.responseIds do
			local v = catalogDetails[responseId]

			if not (v and v.collectibleItemId) then
				continue
			end

			local collectibleItemId = v.collectibleItemId

			if collectibleItemIdSet[collectibleItemId] or v.hasResellers ~= true then
				continue
			end

			collectibleItemIdSet[collectibleItemId] = true
			table.insert(collectibleItemIds, collectibleItemId)
		end

		if #collectibleItemIds == 0 then
			return
		end

		CollectibleProductIdStore.fetchAndCache(myRoduxNetworkingImpl, collectibleItemIds):catch(function(p2)
			warn("[useInspectAvatarData] Failed to fetch collectible product IDs:", (tostring(p2)))
		end)
	end, { catalogDetails, list, p.responseIds })

	return {
		catalogDetails = catalogDetails,
		isCatalogLoading = state,
		ownershipCache = ownershipCache,
		collectibleCache = collectibleCache
	}
end

local function useInspectAvatarData(list)
	local localUserId = useLocalUserId()
	local v = useLookApiData(list)
	local v2 = useCatalogEnrichment(v, list)

	local displayItems = React.useMemo(function()
		if #list == 0 then
			return {}
		end

		local assetIdSet = {}

		for _, item in list do
			assetIdSet[tostring(item.assetId)] = true
		end

		local bundleComponentIds = InspectAvatarUtils.collectBundleComponentIds(v.responseIds, v.cache)

		local responseIdSet = {}
		local v3 = {}

		for _, responseId in v.responseIds do
			local v4 = v.cache[responseId]

			if not v4 then
				continue
			end

			responseIdSet[responseId] = true

			if not (v4.assetsInBundle or not bundleComponentIds[responseId]) then
				continue
			end

			local catalogDetail = v2.catalogDetails[responseId]

			if not catalogDetail then
				continue
			end

			local resaleProductId

			if catalogDetail.collectibleItemId then
				local v5 = v2.collectibleCache[catalogDetail.collectibleItemId]

				if v5 then
					resaleProductId = v5.resaleProductId
				end
			end

			table.insert(v3, InspectAvatarUtils.buildItemData(catalogDetail, v4, assetIdSet, nil, nil, resaleProductId))
		end

		for _, item in list do
			local assetId = tostring(item.assetId)

			if responseIdSet[assetId] or bundleComponentIds[assetId] then
				continue
			end

			local catalogDetail = v2.catalogDetails[assetId]

			if not catalogDetail then
				continue
			end

			local productId = nil
			local resaleProductId = nil

			if catalogDetail.collectibleItemId then
				local v4 = v2.collectibleCache[catalogDetail.collectibleItemId]

				if v4 then
					productId = v4.productId
					resaleProductId = v4.resaleProductId
				end
			end

			local v4 = v2.ownershipCache[assetId]
			table.insert(
				v3,
				InspectAvatarUtils.buildItemData(catalogDetail, nil, assetIdSet, productId, v4, resaleProductId)
			)
		end

		return InspectAvatarUtils.sortDisplayItems(v3)
	end, { v.responseIds, v.cache, list, v2.catalogDetails, v2.collectibleCache, v2.ownershipCache })

	return {
		displayItems = displayItems,
		ownedAssetIds = React.useMemo(function()
			local set = {}
			local result = {}

			for _, v3 in displayItems do
				if not v3.isOwned then
					continue
				end

				if #v3.bundleAssetIds > 0 then
					for _, bundleAssetId in v3.bundleAssetIds do
						if set[bundleAssetId] then
							continue
						end

						set[bundleAssetId] = true
						table.insert(result, bundleAssetId)
					end
				else
					local id = tonumber(v3.id)
					local itemSubType

					if v3.itemSubType then
						itemSubType = tonumber(v3.itemSubType)
					end

					if
						id
						and (not itemSubType or InspectAvatarUtils.isWearableAssetType(itemSubType))
						and not set[id]
					then
						set[id] = true
						table.insert(result, id)
					end
				end
			end

			return result
		end, { displayItems }),
		localUserId = localUserId,
		isLoading = v.isLoading or v2.isCatalogLoading
	}
end

return useInspectAvatarData
