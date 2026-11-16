local CorePackages = game:GetService("CorePackages")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Promise = require(CorePackages.Packages.Promise)
local AvatarEditorService = game:GetService("AvatarEditorService")
local Http = require(CorePackages.Workspace.Packages.Http)
local Url = Http.Url
require(CorePackages.Packages.LuauPolyfill)
require(CorePackages.Workspace.Packages.AvatarExperienceInspectAndBuy)

local v = string.format("https://develop.%s", Url.DOMAIN)

local defineFastFlag = game:DefineFastFlag("AXEnableIaBRbxClientFeature", false)
local defineFastString = game:DefineFastString("InspectAndBuyFeature", "InspectAndBuy")

local function request(p, p2, callback, callback2) -- 1 equivalent call inferred from this helper
	return HttpService:RequestInternal(p):Start(function(p3, p4)
		if not p3 or p4.StatusCode ~= 200 then
			callback2(p4)

			return
		end

		local success = true
		local result

		if p2 and p4.Body ~= "null" then
			success, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)
		else
			result = p4.Body
		end

		if success then
			callback(result)
		else
			callback2("Could not parse JSON.")
		end
	end)
end

local function createYieldingPromise(p, p2)
	if defineFastFlag then
		p.Headers = p.Headers or {}
		p.Headers["rbx-client-feature"] = defineFastString
	end

	return Promise.new(function(callback, callback2)
		coroutine.wrap(function()
			request(p, p2, callback, callback2) -- inferred equivalent call
		end)()
	end)
end

local function getPreviewAvatar(assets)
	return createYieldingPromise({
		Url = Url.APIS_URL .. "look-api/v1/looks/purchase-details",
		Method = "POST",
		Body = HttpService:JSONEncode({ assets = assets }),
		Headers = { ["Content-Type"] = "application/json" }
	}, true)
end

local function getProductInfo(p)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return MarketplaceService:GetProductInfoAsync(p)
		end)

		if success then
			callback(result)
		else
			callback2("Failure in getProductInfo: ", (tostring(result)))
		end
	end)
end

local function getBatchItemDetails(p, p2)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return AvatarEditorService:GetBatchItemDetailsAsync(p, p2)
		end)

		if success then
			callback(result)
		else
			callback2("Failure in batchGetItemDetails: ", (tostring(result)))
		end
	end)
end

local function getBatchItemDetailsV2(items)
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/catalog/items/details",
		Method = "POST",
		Body = HttpService:JSONEncode({ items = items }),
		Headers = { ["Content-Type"] = "application/json" }
	}, true)
end

local function getItemDetails(p, p2)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return AvatarEditorService:GetItemDetailsAsync(p, p2)
		end)

		if success then
			callback(result)
		else
			callback2("Failure in getItemDetails: ", (tostring(result)))
		end
	end)
end

local function getPlayerName(p)
	return Promise.new(function(callback, callback2)
		local success, result = pcall(function()
			return Players:GetNameFromUserIdAsync(p)
		end)

		if success then
			callback(result)
		else
			callback2("Failure in getPlayerName: ", (tostring(result)))
		end
	end)
end

local function getAssetBundles(p)
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/assets/" .. tostring(p) .. "/bundles",
		Method = "GET"
	}, true)
end

local function getHumanoidDescriptionFromCostumeId(p)
	return Promise.new(function(callback, _)
		spawn(function()
			local humanoidDescriptionFromOutfitIdAsync = Players:GetHumanoidDescriptionFromOutfitIdAsync(p)

			if humanoidDescriptionFromOutfitIdAsync then
				callback(humanoidDescriptionFromOutfitIdAsync)
			end
		end)
	end)
end

local function getAssetFavoriteCount(p)
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/assets/" .. tostring(p) .. "/count",
		Method = "GET"
	}, false)
end

local function getBundleFavoriteCount(p)
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/bundles/" .. tostring(p) .. "/count",
		Method = "GET"
	}, false)
end

local function getFavoriteForAsset(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/assets/" .. tostring(p) .. "/favorite",
		Method = "GET"
	}, true)
end

local function getFavoriteForBundle(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/bundles/" .. tostring(p) .. "/favorite",
		Method = "GET"
	}, true)
end

local function createFavoriteForAsset(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/assets/" .. tostring(p) .. "/favorite",
		Method = "POST",
		Body = HttpService:JSONEncode({})
	}, true)
end

local function deleteFavoriteForAsset(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/assets/" .. tostring(p) .. "/favorite",
		Method = "DELETE"
	}, true)
end

local function createFavoriteForBundle(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/bundles/" .. tostring(p) .. "/favorite",
		Method = "POST",
		Body = HttpService:JSONEncode({})
	}, true)
end

local function deleteFavoriteForBundle(p)
	local userId = Players.LocalPlayer.UserId
	return createYieldingPromise({
		Url = Url.CATALOG_URL .. "v1/favorites/users/" .. tostring(userId) .. "/bundles/" .. tostring(p) .. "/favorite",
		Method = "DELETE"
	}, true)
end

local function getEconomyProductInfo(p)
	return createYieldingPromise({
		Url = Url.ECONOMY_URL .. "v1/products/" .. tostring(p) .. "?showPurchasable=true",
		Method = "GET"
	}, true)
end

local function getModelFromUserId(p)
	return Promise.new(function(callback, callback2)
		spawn(function()
			local humanoidModelFromUserIdAsync = Players:CreateHumanoidModelFromUserIdAsync(p)

			if humanoidModelFromUserIdAsync then
				callback(humanoidModelFromUserIdAsync)
			else
				callback2("Failure in getModelFromUserId")
			end
		end)
	end)
end

local function getCollectibleResellableInstances(p, p2)
	local queryString = Url:makeQueryString({
		ownerId = tostring(p2),
		ownerType = "User",
		cursor = "",
		limit = 500
	})

	return createYieldingPromise(
		{
			Url = string.format("%smarketplace-sales/v1/item/%s/resellable-instances?%s", Url.APIS_URL, p, queryString),
			Method = "GET"
		},
		true
	)
end

local function getVersionInfo(p)
	return createYieldingPromise({
		Url = string.format("%sv1/assets/%s/saved-versions", v, p),
		Method = "GET"
	}, true)
end

local function getExperiencePlayability(p)
	return createYieldingPromise(
		{
			Url = string.format("%sv1/games/multiget-playability-status?universeIds=%s", Url.GAME_URL, p),
			Method = "GET"
		},
		true
	)
end

local function getExperienceInfo(p)
	return createYieldingPromise(
		{
			Url = string.format("%sv1/games?universeIds=%s", Url.GAME_URL, p),
			Method = "GET"
		},
		true
	)
end

return {
	new = function()
		local v2 = {
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

		setmetatable(v2, {
			__tostring = function(): string
				return "Service(Network)"
			end
		})

		return v2
	end
}
