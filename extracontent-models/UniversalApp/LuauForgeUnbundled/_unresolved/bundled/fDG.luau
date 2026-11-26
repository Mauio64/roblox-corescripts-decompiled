local CorePackages = game:GetService("CorePackages")

local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")
local Promise = require(CorePackages.Packages.Promise)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module3 = require("@luauforge/bundled/dPN")

require("@game/CorePackages/Workspace/Packages/Http")

local module4 = require("@luauforge/bundled/dRr")
local fFlagAXModeratedItemsFlow = AvatarExperienceFlags.FFlagAXModeratedItemsFlow
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXInventoryIncludeUnavailableItems = AvatarExperienceFlags.FFlagAXInventoryIncludeUnavailableItems

local fFlagAXReturnModeratedPlusExclusiveBackgrounds = AvatarExperienceFlags.FFlagAXReturnModeratedPlusExclusiveBackgrounds
local fFlagAXOutfitDetailsV4 = AvatarExperienceFlags.FFlagAXOutfitDetailsV4

require("@luauforge/bundled/dPs")
local buildSearchAvatarInventoryQuery = require("@luauforge/bundled/fCn").Utils.buildSearchAvatarInventoryQuery

local v5 = {}

function v5.GetAvatarData(callback, p2)
	if fFlagAXModeratedItemsFlow and p2 then
		local formatted = `?{module:makeQueryString(p2)}`
		return callback(`{module.AVATAR_URL}/v2/avatar/avatar{formatted}`, "GET")
	end

	return callback(string.format("%s/v2/avatar/avatar", module.AVATAR_URL), "GET")
end

local function buildV3OutfitDetailsUrl(p2, p3)
	if not p3 then
		return string.format("%s/v3/outfits/%s/details", module.AVATAR_URL, p2)
	end

	local formatted = `?{module:makeQueryString(p3)}`
	return `{module.AVATAR_URL}/v3/outfits/{p2}/details{formatted}`
end

local v6 = {
	headColor = "headColor3",
	torsoColor = "torsoColor3",
	leftArmColor = "leftArmColor3",
	rightArmColor = "rightArmColor3",
	leftLegColor = "leftLegColor3",
	rightLegColor = "rightLegColor3"
}

local function remapV4OutfitDetailsToV3(p2)
	local outfitModel = if typeof(p2) == "table" then p2.outfitModel else nil

	if typeof(outfitModel) ~= "table" then
		return nil
	end

	local clone = table.clone(outfitModel)

	local backgroundAsset = p2.outfitConfigurations
		and p2.outfitConfigurations.background
		and p2.outfitConfigurations.background.backgroundAsset

	if backgroundAsset and backgroundAsset.id ~= nil then
		clone.profileConfiguration = { backgroundAssetId = backgroundAsset.id }
	end

	local bodyColors = outfitModel.bodyColors

	if typeof(bodyColors) ~= "table" then
		return clone
	end

	local v7 = {}

	for k, v8 in v6 do
		v7[v8] = bodyColors[k]
	end

	clone.bodyColors = nil
	clone.bodyColor3s = v7

	return clone
end

function v5.GetOutfit(callback, p2, p3)
	if fFlagAXOutfitDetailsV4 then
		local v7

		if p3 then
			v7 = `{module.AVATAR_URL}v4/outfits/{p2}/details?{module:makeQueryString(p3)}`
		else
			v7 = `{module.AVATAR_URL}v4/outfits/{p2}/details`
		end

		return callback(v7, "GET"):andThen(function(list)
			local v8 = if typeof(list) == "table" then list[1] else nil
			local v9 = remapV4OutfitDetailsToV3(v8)

			if v9 == nil then
				error("WebApi.GetOutfit: v4 outfit-details response missing outfitModel")
			end

			return { v9 }
		end)
	else
		local v7

		if p3 then
			local formatted = `?{module:makeQueryString(p3)}`
			v7 = `{module.AVATAR_URL}/v3/outfits/{p2}/details{formatted}`
		else
			v7 = string.format("%s/v3/outfits/%s/details", module.AVATAR_URL, p2)
		end

		return callback(v7, "GET")
	end
end

function v5.GetRecommendations(callback, p2, p3, p4)
	local queryString = module:makeQueryString({
		numItems = p4 or module3.NumRecommendedItems,
		details = true
	})

	return callback(
		string.format(
			p3 and "%s/v2/recommendations/user-inventory?assetTypeId=%s&%s" or "%s/v2/recommendations/user-inventory?bundleTypeId=%s&%s",
			module.CATALOG_URL,
			p2,
			queryString
		),
		"GET"
	)
end

function v5.GetMySharedAvatars(callback, p2, value)
	return callback(
		string.format("%s/look-api/v1/users/%s/looks?limit=50&cursor=%s", module.APIS_URL, p2, value or ""),
		"GET"
	)
end

function v5.GetRemoteUpranked(callback, p2, p3)
	local queryString = module:makeQueryString({ unsavedItems = p3 })

	return callback(`{module.AVATAR_URL}v1/users/{p2}/currently-wearing-outfits?{queryString}`, "GET")
end

function v5.isAvatarBackgroundInventoryRequest(items): boolean
	local avatarBackground = module3.AssetTypeIdStrings.AvatarBackground

	for k, item in items do
		if tostring(item.itemSubType) == avatarBackground then
			return true
		end
	end

	return false
end

function v5.GetUserAvatarInventory(callback, items, p2, p3, p4, availabilityStatus)
	local v7

	if fFlagAXReturnModeratedPlusExclusiveBackgrounds then
		v7 = v5.isAvatarBackgroundInventoryRequest(items)
	end

	if module4() then
		if not fFlagAXInventoryDurablesExpiredFilter then
			availabilityStatus = nil
		end

		local v8 = {
			pageLimit = p3,
			sortOption = p2,
			pageToken = p4,
			availabilityStatus = availabilityStatus,
			includeUnavailableItems = (fFlagAXInventoryIncludeUnavailableItems or v7) and true or nil
		}

		for k, item in items do
			local v9 = k - 1
			v8[`itemCategories[{v9}].itemType`] = item.itemType
			v8[`itemCategories[{v9}].itemSubType`] = tostring(item.itemSubType)
		end

		return callback(`{module.AVATAR_URL}v1/avatar-inventory?{module:makeQueryString(v8)}`, "GET")
	else
		local v8 = ""

		for k, item in items do
			local v9 = k - 1

			v8 ..= `&itemCategories[{v9}].itemType={item.itemType}` .. `&itemCategories[{v9}].itemSubType={item.itemSubType}`
		end

		local v9 = (fFlagAXInventoryIncludeUnavailableItems or v7) and "&includeUnavailableItems=true" or ""
		local v10

		if fFlagAXInventoryDurablesExpiredFilter then
			local v11 = not availabilityStatus and "" or `&availabilityStatus={availabilityStatus}`

			v10 = `{module.AVATAR_URL}v1/avatar-inventory?pageLimit={p3}&sortOption={p2}&pageToken={p4}{v8}{v11}{v9}`
		else
			v10 = `{module.AVATAR_URL}v1/avatar-inventory?pageLimit={p3}&sortOption={p2}&pageToken={p4}{v8}{v9}`
		end

		return callback(v10, "GET")
	end
end

function v5.SearchUserAvatarInventory(callback, p2)
	local searchAvatarInventoryQuery = buildSearchAvatarInventoryQuery(p2)

	if searchAvatarInventoryQuery then
		return callback(
			`{module.AVATAR_URL}v1/avatar-inventory/search?{module:makeQueryString(searchAvatarInventoryQuery)}`,
			"GET"
		)
	end

	return Promise.reject("SearchUserAvatarInventory: invalid params")
end

function v5.GetPreviewLook(callback, p2)
	return callback(string.format("%slook-api/v1/looks/preview", module.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ assets = p2 })
	})
end

function v5.CreateLook(callback, p2, data)
	return callback(string.format("%slook-api/v1/looks/create", module.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			assets = p2,
			name = data.name,
			description = data.description,
			displayProperties = data.displayProperties,
			avatarProperties = data.avatarProperties
		})
	})
end

return v5
