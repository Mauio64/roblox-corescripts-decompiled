local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local AvatarEditorService = game:GetService("AvatarEditorService")
local Url = require(CorePackages.Workspace.Packages.Http).Url

require(CorePackages.Packages.LuauPolyfill)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local v8 = string.format("https://develop.%s", Url.DOMAIN)
local v9 = game:DefineFastFlag("AXEnableIaBRbxClientFeature", false)
local v10 = game:DefineFastString("InspectAndBuyFeature", "InspectAndBuy")

local function request(p1, p2, p3, p4) -- line: 29
	-- upvalues: HttpService (copy)
	return HttpService:RequestInternal(p1):Start(function(p5, p6) -- line: 30
		-- upvalues: p2 (copy), HttpService (copy), p3 (copy), p4 (copy)
		if p5 and p6.StatusCode == 200 then
			local v108 = true
			local result

			if p2 and p6.Body ~= "null" then
				v108, result = pcall(HttpService.JSONDecode, HttpService, p6.Body)
			else
				result = p6.Body
			end

			if v108 then
				p3(result)

				return
			end

			p4("Could not parse JSON.")

			return
		end

		p4(p6)
	end)
end
local function createYieldingPromise(p7, p8) -- line: 52
	-- upvalues: v9 (copy), v10 (copy), Promise (copy), HttpService (copy)
	if v9 then
		p7.Headers = p7.Headers or {}
		p7.Headers["rbx-client-feature"] = v10
	end

	return Promise.new(function(resolve, reject) -- line: 57
		-- upvalues: p7 (copy), p8 (copy), HttpService (copy)
		coroutine.wrap(function() -- line: 58
			-- upvalues: p7 (copy), p8 (copy), resolve (copy), reject (copy), HttpService (copy)
			local v132 = p7
			local v133 = p8
			local v134 = resolve
			local v135 = reject

			HttpService:RequestInternal(v132):Start(function(p9, p10) -- line: 30
				-- upvalues: v133 (copy), HttpService (copy), v134 (copy), v135 (copy)
				if p9 and p10.StatusCode == 200 then
					local v140 = true
					local result

					if v133 and p10.Body ~= "null" then
						v140, result = pcall(HttpService.JSONDecode, HttpService, p10.Body)
					else
						result = p10.Body
					end

					if v140 then
						v134(result)

						return
					end

					v135("Could not parse JSON.")

					return
				end

				v135(p10)
			end)
		end)()
	end)
end
local function getPreviewAvatar(p11) -- line: 67
	-- upvalues: Url (copy), HttpService (copy), createYieldingPromise (copy)
	local v42 = Url.APIS_URL .. "look-api/v1/looks/purchase-details"
	local t1 = {
		Method = "POST",
		Url = v42,
		Body = HttpService:JSONEncode({
			assets = p11
		}),
		Headers = {
			["Content-Type"] = "application/json"
		}
	}

	return createYieldingPromise(t1, true)
end
local function getProductInfo(p12) -- line: 85
	-- upvalues: Promise (copy), MarketplaceService (copy)
	return Promise.new(function(resolve, reject) -- line: 86
		-- upvalues: MarketplaceService (copy), p12 (copy)
		local ok, result = pcall(function() -- line: 87
			-- upvalues: MarketplaceService (copy), p12 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return MarketplaceService:GetProductInfoAsync(p12)
			end

			return MarketplaceService:GetProductInfo(p12)
		end)

		if ok then
			resolve(result)

			return
		end

		reject("Failure in getProductInfo: ", (tostring(result)))
	end)
end
local function getBatchItemDetails(p13, p14) -- line: 106
	-- upvalues: Promise (copy), AvatarEditorService (copy)
	return Promise.new(function(resolve, reject) -- line: 107
		-- upvalues: AvatarEditorService (copy), p13 (copy), p14 (copy)
		local ok, result = pcall(function() -- line: 108
			-- upvalues: AvatarEditorService (copy), p13 (copy), p14 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return AvatarEditorService:GetBatchItemDetailsAsync(p13, p14)
			end

			return AvatarEditorService:GetBatchItemDetails(p13, p14)
		end)

		if ok then
			resolve(result)

			return
		end

		reject("Failure in batchGetItemDetails: ", (tostring(result)))
	end)
end
local function getBatchItemDetailsV2(t2: {[any]: any}) -- line: 129
	-- upvalues: Url (copy), HttpService (copy), createYieldingPromise (copy)
	local v48 = Url.CATALOG_URL .. "v1/catalog/items/details"
	local t3 = {
		Method = "POST",
		Url = v48,
		Body = HttpService:JSONEncode({
			items = t2
		}),
		Headers = {
			["Content-Type"] = "application/json"
		}
	}

	return createYieldingPromise(t3, true)
end
local function getItemDetails(p15, p16) -- line: 147
	-- upvalues: Promise (copy), AvatarEditorService (copy)
	return Promise.new(function(resolve, reject) -- line: 148
		-- upvalues: AvatarEditorService (copy), p15 (copy), p16 (copy)
		local ok, result = pcall(function() -- line: 149
			-- upvalues: AvatarEditorService (copy), p15 (copy), p16 (copy)
			if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
				return AvatarEditorService:GetItemDetailsAsync(p15, p16)
			end

			return AvatarEditorService:GetItemDetails(p15, p16)
		end)

		if ok then
			resolve(result)

			return
		end

		reject("Failure in getItemDetails: ", (tostring(result)))
	end)
end
local function getPlayerName(p17) -- line: 168
	-- upvalues: Promise (copy), Players (copy)
	return Promise.new(function(resolve, reject) -- line: 169
		-- upvalues: Players (copy), p17 (copy)
		local ok, result = pcall(function() -- line: 170
			-- upvalues: Players (copy), p17 (copy)
			return Players:GetNameFromUserIdAsync(p17)
		end)

		if ok then
			resolve(result)

			return
		end

		reject("Failure in getPlayerName: ", (tostring(result)))
	end)
end
local function getAssetBundles(p18) -- line: 185
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v54 = Url.CATALOG_URL .. "v1/assets/" .. tostring(p18) .. "/bundles"
	local t4 = {
		Method = "GET",
		Url = v54
	}

	return createYieldingPromise(t4, true)
end
local function getHumanoidDescriptionFromCostumeId(p19) -- line: 198
	-- upvalues: Promise (copy), Players (copy)
	return Promise.new(function(resolve, _) -- line: 199
		-- upvalues: Players (copy), p19 (copy)
		spawn(function() -- line: 200
			-- upvalues: Players (copy), p19 (copy), resolve (copy)
			local v136 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:GetHumanoidDescriptionFromOutfitId(p19) else Players:GetHumanoidDescriptionFromOutfitIdAsync(p19)

			if v136 then
				resolve(v136)
			end
		end)
	end)
end
local function getAssetFavoriteCount(p21) -- line: 215
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v58 = Url.CATALOG_URL .. "v1/favorites/assets/" .. tostring(p21) .. "/count"
	local t5 = {
		Method = "GET",
		Url = v58
	}

	return createYieldingPromise(t5, false)
end
local function getBundleFavoriteCount(p22) -- line: 228
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v61 = Url.CATALOG_URL .. "v1/favorites/bundles/" .. tostring(p22) .. "/count"
	local t6 = {
		Method = "GET",
		Url = v61
	}

	return createYieldingPromise(t6, false)
end
local function getFavoriteForAsset(p23) -- line: 241
	-- upvalues: Players (copy), Url (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v65 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/assets/" .. tostring(p23) .. "/favorite"
	local t7 = {
		Method = "GET",
		Url = v65
	}

	return createYieldingPromise(t7, true)
end
local function getFavoriteForBundle(p24) -- line: 260
	-- upvalues: Players (copy), Url (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v69 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/bundles/" .. tostring(p24) .. "/favorite"
	local t8 = {
		Method = "GET",
		Url = v69
	}

	return createYieldingPromise(t8, true)
end
local function createFavoriteForAsset(p25) -- line: 279
	-- upvalues: Players (copy), Url (copy), HttpService (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v73 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/assets/" .. tostring(p25) .. "/favorite"
	local t9 = {
		Method = "POST",
		Url = v73,
		Body = HttpService:JSONEncode({})
	}

	return createYieldingPromise(t9, true)
end
local function deleteFavoriteForAsset(p26) -- line: 299
	-- upvalues: Players (copy), Url (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v77 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/assets/" .. tostring(p26) .. "/favorite"
	local t10 = {
		Method = "DELETE",
		Url = v77
	}

	return createYieldingPromise(t10, true)
end
local function createFavoriteForBundle(p27) -- line: 318
	-- upvalues: Players (copy), Url (copy), HttpService (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v81 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/bundles/" .. tostring(p27) .. "/favorite"
	local t11 = {
		Method = "POST",
		Url = v81,
		Body = HttpService:JSONEncode({})
	}

	return createYieldingPromise(t11, true)
end
local function deleteFavoriteForBundle(p28) -- line: 338
	-- upvalues: Players (copy), Url (copy), createYieldingPromise (copy)
	local UserId = Players.LocalPlayer.UserId
	local v85 = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(UserId) .. "/bundles/" .. tostring(p28) .. "/favorite"
	local t12 = {
		Method = "DELETE",
		Url = v85
	}

	return createYieldingPromise(t12, true)
end
local function getEconomyProductInfo(p29) -- line: 357
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v88 = Url.ECONOMY_URL .. "v1/products/" .. tostring(p29) .. "?showPurchasable=true"
	local t13 = {
		Method = "GET",
		Url = v88
	}

	return createYieldingPromise(t13, true)
end
local function getModelFromUserId(p30) -- line: 370
	-- upvalues: Promise (copy), Players (copy)
	return Promise.new(function(resolve, reject) -- line: 371
		-- upvalues: Players (copy), p30 (copy)
		spawn(function() -- line: 372
			-- upvalues: Players (copy), p30 (copy), resolve (copy), reject (copy)
			local v137 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:CreateHumanoidModelFromUserId(p30) else Players:CreateHumanoidModelFromUserIdAsync(p30)

			if v137 then
				resolve(v137)

				return
			end

			reject("Failure in getModelFromUserId")
		end)
	end)
end
local function getCollectibleResellableInstances(p31, p32) -- line: 389
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v93 = Url:makeQueryString({
		ownerType = "User",
		cursor = "",
		limit = 500,
		ownerId = tostring(p32)
	})
	local v94 = string.format("%smarketplace-sales/v1/item/%s/resellable-instances?%s", Url.APIS_URL, p31, v93)
	local t14 = {
		Method = "GET",
		Url = v94
	}

	return createYieldingPromise(t14, true)
end
local function getVersionInfo(p33) -- line: 406
	-- upvalues: v8 (copy), createYieldingPromise (copy)
	local v97 = string.format("%sv1/assets/%s/saved-versions", v8, p33)
	local t15 = {
		Method = "GET",
		Url = v97
	}

	return createYieldingPromise(t15, true)
end
local function getExperiencePlayability(p34) -- line: 415
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v100 = string.format("%sv1/games/multiget-playability-status?universeIds=%s", Url.GAME_URL, p34)
	local t16 = {
		Method = "GET",
		Url = v100
	}

	return createYieldingPromise(t16, true)
end
local function getExperienceInfo(p35) -- line: 424
	-- upvalues: Url (copy), createYieldingPromise (copy)
	local v103 = string.format("%sv1/games?universeIds=%s", Url.GAME_URL, p35)
	local t17 = {
		Method = "GET",
		Url = v103
	}

	return createYieldingPromise(t17, true)
end

return {
	new = function() -- line: 435
		-- upvalues: getProductInfo (copy), getEconomyProductInfo (copy), getPlayerName (copy), getAssetBundles (copy), getHumanoidDescriptionFromCostumeId (copy), getAssetFavoriteCount (copy), getBundleFavoriteCount (copy), getFavoriteForAsset (copy), getFavoriteForBundle (copy), createFavoriteForAsset (copy), deleteFavoriteForAsset (copy), createFavoriteForBundle (copy), deleteFavoriteForBundle (copy), getModelFromUserId (copy), getCollectibleResellableInstances (copy), getVersionInfo (copy), getExperiencePlayability (copy), getExperienceInfo (copy), getItemDetails (copy), getPreviewAvatar (copy), getBatchItemDetails (copy), getBatchItemDetailsV2 (copy)
		local t18 = {
			getProductInfo = getProductInfo,
			getEconomyProductInfo = getEconomyProductInfo,
			getPlayerName = getPlayerName,
			getAssetBundles = getAssetBundles,
			getHumanoidDescriptionFromCostumeId = getHumanoidDescriptionFromCostumeId,
			getAssetFavoriteCount = getAssetFavoriteCount,
			getBundleFavoriteCount = getBundleFavoriteCount,
			getFavoriteForAsset = getFavoriteForAsset,
			getFavoriteForBundle = getFavoriteForBundle,
			createFavoriteForAsset = createFavoriteForAsset,
			deleteFavoriteForAsset = deleteFavoriteForAsset,
			createFavoriteForBundle = createFavoriteForBundle,
			deleteFavoriteForBundle = deleteFavoriteForBundle,
			getModelFromUserId = getModelFromUserId,
			getCollectibleResellableInstances = getCollectibleResellableInstances,
			getVersionInfo = getVersionInfo,
			getExperiencePlayability = getExperiencePlayability,
			getExperienceInfo = getExperienceInfo,
			getItemDetails = getItemDetails,
			getPreviewAvatar = getPreviewAvatar,
			getBatchItemDetails = getBatchItemDetails,
			getBatchItemDetailsV2 = getBatchItemDetailsV2
		}

		setmetatable(t18, {
			__tostring = function() -- line: 468
				return "Service(Network)"
			end
		})

		return t18
	end
}
