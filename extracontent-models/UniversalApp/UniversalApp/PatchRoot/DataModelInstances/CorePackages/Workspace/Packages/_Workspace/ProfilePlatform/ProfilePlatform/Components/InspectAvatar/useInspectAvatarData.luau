local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Dash = require(ProfilePlatformParent.Dash)
local Promise = require(ProfilePlatformParent.Promise)
local RobloxAppHooks = require(ProfilePlatformParent.RobloxAppHooks)
local CatalogNetworking = require(ProfilePlatformParent.CatalogNetworking)
local useSignalState = require(ProfilePlatformParent.SignalsReact).useSignalState
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Enums = require(ProfilePlatform.Common.Enums)
local myRoduxNetworkingImpl = require(ProfilePlatform.Networking.myRoduxNetworkingImpl)
local InspectAvatarUtils = require(script.Parent.InspectAvatarUtils)

require(ProfilePlatform.Common.Types)

local PurchaseDetailsStore = CatalogNetworking.PurchaseDetailsStore
local CollectibleProductIdStore = CatalogNetworking.CollectibleProductIdStore
local BundleOwnershipStore = CatalogNetworking.BundleOwnershipStore
local ItemDetailsStore = CatalogNetworking.ItemDetailsStore

local function useLookApiData(t1: {[any]: any}) -- line: 42
	-- upvalues: useSignalState (copy), PurchaseDetailsStore (copy), React (copy), Dash (copy), Enums (copy), myRoduxNetworkingImpl (copy)
	local v21 = useSignalState(PurchaseDetailsStore.getCache)
	local v22, v23 = React.useState({})
	local v24, v25 = React.useState(true)

	React.useEffect(function() -- line: 47
		-- upvalues: t1 (copy), v25 (copy), Dash (copy), Enums (copy), v23 (copy), PurchaseDetailsStore (copy), myRoduxNetworkingImpl (copy)
		if #t1 == 0 then
			v25(false)

			return
		end

		local v39 = Dash.collectArray(t1, function(_, p2) -- line: 52
			-- upvalues: Enums (copy)
			if p2.itemType ~= Enums.ItemTypes.Bundle then
				return {
					id = tonumber(p2.assetId) or p2.assetId
				}
			end

			return nil
		end)

		if #v39 == 0 then
			v25(false)

			return
		end

		v25(true)
		v23({})
		PurchaseDetailsStore.fetchAll(myRoduxNetworkingImpl, v39):andThen(function(p3) -- line: 66
			-- upvalues: Dash (copy), v23 (copy)
			if p3 and (p3.look and p3.look.items) then
				local v99 = Dash.map(p3.look.items, function(p4) -- line: 68
					return (tostring(p4.id))
				end)

				v23(v99)
			end
		end, function(p5) -- line: 73
			warn("[useInspectAvatarData] Failed to fetch purchase details:", (tostring(p5)))
		end):finally(function() -- line: 76
			-- upvalues: v25 (copy)
			v25(false)
		end)
	end, { t1 })

	return {
		responseIds = v22,
		cache = v21,
		isLoading = v24
	}
end
local function useCatalogEnrichment(t2: {[any]: any}, t3: {[any]: any}) -- line: 92
	-- upvalues: useSignalState (copy), ItemDetailsStore (copy), React (copy), CollectibleProductIdStore (copy), BundleOwnershipStore (copy), Enums (copy), myRoduxNetworkingImpl (copy), Promise (copy)
	local v28 = useSignalState(ItemDetailsStore.getCache)
	local v29, v30 = React.useState(true)
	local v31 = useSignalState(CollectibleProductIdStore.getCache)
	local v32 = useSignalState(BundleOwnershipStore.getCache)

	React.useEffect(function() -- line: 100
		-- upvalues: t2 (copy), t3 (copy), v30 (copy), Enums (copy), ItemDetailsStore (copy), myRoduxNetworkingImpl (copy), Promise (copy), BundleOwnershipStore (copy)
		if t2.isLoading then
			return
		end

		if #t3 == 0 then
			v30(false)

			return
		end

		local t4 = {}
		local t5 = {}

		for _, v43 in t3 do
			t4[tostring(v43.assetId)] = v43.itemType or "Asset"

			if v43.itemType == Enums.ItemTypes.Bundle then
				local num = tonumber(v43.assetId)

				if num then
					table.insert(t5, num)
				end
			end
		end

		local t6 = {}
		local t7 = {}

		for _, v48 in t2.responseIds do
			local num = tonumber(v48)

			if num and not t7[v48] then
				t7[v48] = true
				table.insert(t6, {
					id = num,
					itemType = t4[v48] or "Bundle"
				})
			end
		end

		for _, v51 in t3 do
			local str = tostring(v51.assetId)
			local num = tonumber(v51.assetId)

			if num and not t7[str] then
				t7[str] = true
				table.insert(t6, {
					id = num,
					itemType = v51.itemType or "Asset"
				})
			end
		end

		if #t6 == 0 and #t5 == 0 then
			v30(false)

			return
		end

		v30(true)

		local v54 = if not (#t6 > 0) then Promise.resolve() else ItemDetailsStore.fetchAndCache(myRoduxNetworkingImpl, t6)
		local v55 = if not (#t5 > 0) then Promise.resolve() else BundleOwnershipStore.fetchAndCache(myRoduxNetworkingImpl, t5):catch(function(p6) -- line: 159
			warn("[useInspectAvatarData] Failed to fetch bundle ownership:", (tostring(p6)))
		end)

		Promise.all({
			v54,
			v55
		}):andThen(function() -- line: 165
			-- upvalues: v30 (copy)
			v30(false)
		end):catch(function(p7) -- line: 168
			-- upvalues: v30 (copy)
			warn("[useInspectAvatarData] Failed to fetch catalog details:", (tostring(p7)))
			v30(false)
		end)
	end, {
		t2.responseIds,
		t2.isLoading,
		t3
	})
	React.useEffect(function() -- line: 175
		-- upvalues: t3 (copy), v28 (copy), Enums (copy), t2 (copy), CollectibleProductIdStore (copy), myRoduxNetworkingImpl (copy)
		local t8 = {}
		local t9 = {}

		for _, v59 in t3 do
			local v60 = v28[tostring(v59.assetId)]

			if v60 and v60.collectibleItemId then
				local collectibleItemId = v60.collectibleItemId

				if not t9[collectibleItemId] then
					local v62 = v59.itemType == Enums.ItemTypes.Bundle and not v60.isOffSale
					local v63 = v60.hasResellers == true

					if v62 or v63 then
						t9[collectibleItemId] = true
						table.insert(t8, collectibleItemId)
					end
				end
			end
		end

		for _, v65 in t2.responseIds do
			local v66 = v28[v65]

			if v66 and v66.collectibleItemId then
				local collectibleItemId = v66.collectibleItemId

				if not t9[collectibleItemId] and v66.hasResellers == true then
					t9[collectibleItemId] = true
					table.insert(t8, collectibleItemId)
				end
			end
		end

		if #t8 == 0 then
			return
		end

		CollectibleProductIdStore.fetchAndCache(myRoduxNetworkingImpl, t8):catch(function(p8) -- line: 213
			warn("[useInspectAvatarData] Failed to fetch collectible product IDs:", (tostring(p8)))
		end)
	end, {
		v28,
		t3,
		t2.responseIds
	})

	return {
		catalogDetails = v28,
		isCatalogLoading = v29,
		ownershipCache = v32,
		collectibleCache = v31
	}
end
local function useInspectAvatarData(t10: {[any]: any}) -- line: 229
	-- upvalues: useLocalUserId (copy), useLookApiData (copy), useCatalogEnrichment (copy), React (copy), InspectAvatarUtils (copy)
	local v34 = useLocalUserId()
	local v35 = useLookApiData(t10)
	local v36 = useCatalogEnrichment(v35, t10)
	local v37 = React.useMemo(function() -- line: 235
		-- upvalues: t10 (copy), InspectAvatarUtils (copy), v35 (copy), v36 (copy)
		if #t10 == 0 then
			return {}
		end

		local t11 = {}

		for _, v70 in t10 do
			t11[tostring(v70.assetId)] = true
		end

		local v71 = InspectAvatarUtils.collectBundleComponentIds(v35.responseIds, v35.cache)
		local t12 = {}
		local t13 = {}

		for _, v75 in v35.responseIds do
			local v76 = v35.cache[v75]

			if v76 then
				t13[v75] = true

				if v76.assetsInBundle or not v71[v75] then
					local v77 = v36.catalogDetails[v75]

					if v77 then
						local v78 = nil

						if v77.collectibleItemId then
							local v79 = v36.collectibleCache[v77.collectibleItemId]

							v78 = if not v79 then nil else v79.resaleProductId
						end

						table.insert(t12, InspectAvatarUtils.buildItemData(v77, v76, t11, nil, nil, v78))
					end
				end
			end
		end

		for _, v81 in t10 do
			local str = tostring(v81.assetId)

			if not t13[str] and not v71[str] then
				local v83 = v36.catalogDetails[str]

				if v83 then
					local productId = nil
					local resaleProductId = nil

					if v83.collectibleItemId then
						local v86 = v36.collectibleCache[v83.collectibleItemId]

						if v86 then
							productId = v86.productId
							resaleProductId = v86.resaleProductId
						end
					end

					local v87 = v36.ownershipCache[str]

					table.insert(t12, InspectAvatarUtils.buildItemData(v83, nil, t11, productId, v87, resaleProductId))
				end
			end
		end

		return InspectAvatarUtils.sortDisplayItems(t12)
	end, {
		v35.responseIds,
		v35.cache,
		t10,
		v36.catalogDetails,
		v36.collectibleCache,
		v36.ownershipCache
	})
	local v38 = React.useMemo(function() -- line: 316
		-- upvalues: v37 (copy), InspectAvatarUtils (copy)
		local t14 = {}
		local t15 = {}

		for _, v91 in v37 do
			if v91.isOwned then
				if #v91.bundleAssetIds > 0 then
					for _, v93 in v91.bundleAssetIds do
						if not t15[v93] then
							t15[v93] = true
							table.insert(t14, v93)
						end
					end
				else
					local num = tonumber(v91.id)
					local v95 = if not v91.itemSubType then nil else tonumber(v91.itemSubType)

					if num and ((not v95 or InspectAvatarUtils.isWearableAssetType(v95)) and not t15[num]) then
						t15[num] = true
						table.insert(t14, num)
					end
				end
			end
		end

		return t14
	end, { v37 })

	return {
		displayItems = v37,
		ownedAssetIds = v38,
		localUserId = v34,
		isLoading = v35.isLoading or v36.isCatalogLoading
	}
end

return useInspectAvatarData
