local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Dash")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Promise")
local RobloxAppHooks = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks")
local CatalogNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CatalogNetworking")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState

local useLocalUserId = RobloxAppHooks.useLocalUserId

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local myRoduxNetworkingImpl = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworkingImpl")

local InspectAvatarUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")

local purchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local collectibleProductIdStore = CatalogNetworking.CollectibleProductIdStore
local bundleOwnershipStore = CatalogNetworking.BundleOwnershipStore
local itemDetailsStore = CatalogNetworking.ItemDetailsStore

local function useLookApiData(list)
	local v5 = useSignalState(purchaseDetailsStore.getCache)
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(true)

	React.useEffect(function()
		if #list == 0 then
			setState2(false)
			return
		end

		local array = Dash.collectArray(list, function(p2, p3)
			if p3.itemType == Enums.ItemTypes.Bundle then
				return nil
			end

			return {
				id = tonumber(p3.assetId) or p3.assetId
			}
		end)

		if #array == 0 then
			setState2(false)
			return
		end

		setState2(true)
		setState({})
		purchaseDetailsStore.fetchAll(myRoduxNetworkingImpl, array):andThen(function(p2)
			if p2 and p2.look and p2.look.items then
				setState((Dash.map(p2.look.items, function(p3)
					return (tostring(p3.id))
				end)))
			end
		end, function(p2)
			warn("[useInspectAvatarData] Failed to fetch purchase details:", (tostring(p2)))
		end):finally(function()
			setState2(false)
		end)
	end, { list })

	return { responseIds = state, cache = v5, isLoading = state2 }
end

local function useCatalogEnrichment(p2, list)
	local v5 = useSignalState(itemDetailsStore.getCache)
	local state, setState = React.useState(true)
	local v6 = useSignalState(collectibleProductIdStore.getCache)
	local v7 = useSignalState(bundleOwnershipStore.getCache)

	React.useEffect(function()
		if p2.isLoading then
			return
		end

		if #list == 0 then
			setState(false)
			return
		end

		local itemTypesByAssetId = {}
		local assetIds = {}

		for k, item in list do
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
		local v8 = {}

		for k, responseId in p2.responseIds do
			local v9 = tonumber(responseId)

			if not v9 or set[responseId] then
				continue
			end

			set[responseId] = true
			table.insert(v8, {
				id = v9,
				itemType = itemTypesByAssetId[responseId] or "Bundle"
			})
		end

		for k, item in list do
			local assetId = tostring(item.assetId)
			local assetId2 = tonumber(item.assetId)

			if not assetId2 or set[assetId] then
				continue
			end

			set[assetId] = true
			table.insert(v8, {
				id = assetId2,
				itemType = item.itemType or "Asset"
			})
		end

		if #v8 == 0 and #assetIds == 0 then
			setState(false)
			return
		end

		setState(true)

		local v9 = if #v8 > 0 then itemDetailsStore.fetchAndCache(myRoduxNetworkingImpl, v8) else Promise.resolve()
		local v10

		if #assetIds > 0 then
			v10 = bundleOwnershipStore.fetchAndCache(myRoduxNetworkingImpl, assetIds):catch(function(p3)
				warn("[useInspectAvatarData] Failed to fetch bundle ownership:", (tostring(p3)))
			end)
		else
			v10 = Promise.resolve()
		end

		Promise.all({ v9, v10 }):andThen(function()
			setState(false)
		end):catch(function(p3)
			warn("[useInspectAvatarData] Failed to fetch catalog details:", (tostring(p3)))
			setState(false)
		end)
	end, { p2.responseIds, p2.isLoading, list })

	React.useEffect(function()
		local collectibleItemIdSet = {}
		local collectibleItemIds = {}

		for k, item in list do
			local v8 = v5[tostring(item.assetId)]

			if not (v8 and v8.collectibleItemId) then
				continue
			end

			local collectibleItemId = v8.collectibleItemId

			if collectibleItemIdSet[collectibleItemId] then
				continue
			end

			local v9 = item.itemType == Enums.ItemTypes.Bundle and not v8.isOffSale
			local hasResellers = v8.hasResellers == true

			if not (v9 or hasResellers) then
				continue
			end

			collectibleItemIdSet[collectibleItemId] = true
			table.insert(collectibleItemIds, collectibleItemId)
		end

		for k, responseId in p2.responseIds do
			local v8 = v5[responseId]

			if not (v8 and v8.collectibleItemId) then
				continue
			end

			local collectibleItemId = v8.collectibleItemId

			if collectibleItemIdSet[collectibleItemId] or v8.hasResellers ~= true then
				continue
			end

			collectibleItemIdSet[collectibleItemId] = true
			table.insert(collectibleItemIds, collectibleItemId)
		end

		if #collectibleItemIds == 0 then
			return
		end

		collectibleProductIdStore.fetchAndCache(myRoduxNetworkingImpl, collectibleItemIds):catch(function(p3)
			warn("[useInspectAvatarData] Failed to fetch collectible product IDs:", (tostring(p3)))
		end)
	end, { v5, list, p2.responseIds })

	return {
		catalogDetails = v5,
		isCatalogLoading = state,
		ownershipCache = v7,
		collectibleCache = v6
	}
end

local function useInspectAvatarData(list)
	local v5 = useLocalUserId()
	local v6 = useLookApiData(list)
	local v7 = useCatalogEnrichment(v6, list)

	local v8 = React.useMemo(function()
		if #list == 0 then
			return {}
		end

		local assetIdSet = {}

		for k, item in list do
			assetIdSet[tostring(item.assetId)] = true
		end

		local bundleComponentIds = InspectAvatarUtils.collectBundleComponentIds(v6.responseIds, v6.cache)

		local responseIdSet = {}
		local v9 = {}

		for k, responseId in v6.responseIds do
			local v10 = v6.cache[responseId]

			if not v10 then
				continue
			end

			responseIdSet[responseId] = true

			if not (v10.assetsInBundle or not bundleComponentIds[responseId]) then
				continue
			end

			local catalogDetail = v7.catalogDetails[responseId]

			if not catalogDetail then
				continue
			end

			local resaleProductId

			if catalogDetail.collectibleItemId then
				local v11 = v7.collectibleCache[catalogDetail.collectibleItemId]

				if v11 then
					resaleProductId = v11.resaleProductId
				end
			end

			table.insert(
				v9,
				InspectAvatarUtils.buildItemData(catalogDetail, v10, assetIdSet, nil, nil, resaleProductId)
			)
		end

		for k, item in list do
			local assetId = tostring(item.assetId)

			if responseIdSet[assetId] or bundleComponentIds[assetId] then
				continue
			end

			local catalogDetail = v7.catalogDetails[assetId]

			if not catalogDetail then
				continue
			end

			local productId = nil
			local resaleProductId = nil

			if catalogDetail.collectibleItemId then
				local v10 = v7.collectibleCache[catalogDetail.collectibleItemId]

				if v10 then
					productId = v10.productId
					resaleProductId = v10.resaleProductId
				end
			end

			local v10 = v7.ownershipCache[assetId]
			table.insert(
				v9,
				InspectAvatarUtils.buildItemData(catalogDetail, nil, assetIdSet, productId, v10, resaleProductId)
			)
		end

		return InspectAvatarUtils.sortDisplayItems(v9)
	end, {
		v6.responseIds,
		v6.cache,
		list,
		v7.catalogDetails,
		v7.collectibleCache,
		v7.ownershipCache
	})

	return {
		displayItems = v8,
		ownedAssetIds = React.useMemo(function()
			local set = {}
			local result = {}

			for k, v9 in v8 do
				if not v9.isOwned then
					continue
				end

				if #v9.bundleAssetIds > 0 then
					for k2, bundleAssetId in v9.bundleAssetIds do
						if set[bundleAssetId] then
							continue
						end

						set[bundleAssetId] = true
						table.insert(result, bundleAssetId)
					end
				else
					local id = tonumber(v9.id)
					local itemSubType = if v9.itemSubType then tonumber(v9.itemSubType) else nil

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
		end, { v8 }),
		localUserId = v5,
		isLoading = v6.isLoading or v7.isCatalogLoading
	}
end

return useInspectAvatarData
