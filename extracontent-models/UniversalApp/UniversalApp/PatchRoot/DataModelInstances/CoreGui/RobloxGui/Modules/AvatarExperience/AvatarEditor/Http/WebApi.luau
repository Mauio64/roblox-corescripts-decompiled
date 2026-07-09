local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Modules = CoreGui.RobloxGui.Modules
local Url = require(Modules.LuaApp.Http.Url)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = require(Modules.AvatarExperience.Common.Constants)

require(CorePackages.Workspace.Packages.Http)

local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local FFlagAXInventoryIncludeUnavailableItems = AvatarExperienceFlags.FFlagAXInventoryIncludeUnavailableItems
local FFlagAXOutfitDetailsV4 = AvatarExperienceFlags.FFlagAXOutfitDetailsV4

require(Modules.AvatarExperience.Common.Types)

local t2 = {
	GetAvatarData = function(p1, t1: {[any]: any}?) -- line: 31
		-- upvalues: FFlagAXModeratedItemsFlow (copy), Url (copy)
		if FFlagAXModeratedItemsFlow and t1 then
			local v20 = `?{ Url:makeQueryString(t1) }`

			return p1(`{ Url.AVATAR_URL }/v2/avatar/avatar{ v20 }`, "GET")
		end

		return p1(string.format("%s/v2/avatar/avatar", Url.AVATAR_URL), "GET")
	end
}

local function buildV3OutfitDetailsUrl(p2, t3: {[any]: any}?) -- line: 42
	-- upvalues: FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), Url (copy)
	if (FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables) and t3 then
		local v23 = `?{ Url:makeQueryString(t3) }`

		return `{ Url.AVATAR_URL }/v3/outfits/{ p2 }/details{ v23 }`
	end

	return string.format("%s/v3/outfits/%s/details", Url.AVATAR_URL, p2)
end

local t4 = {
	headColor = "headColor3",
	torsoColor = "torsoColor3",
	leftArmColor = "leftArmColor3",
	rightArmColor = "rightArmColor3",
	leftLegColor = "leftLegColor3",
	rightLegColor = "rightLegColor3"
}

local function remapV4OutfitDetailsToV3(p3) -- line: 69
	-- upvalues: t4 (copy)
	local v25 = if typeof(p3) ~= "table" then nil else p3.outfitModel

	if typeof(v25) ~= "table" then
		return nil
	end

	local v26 = table.clone(v25)
	local v27 = p3.outfitConfigurations and (p3.outfitConfigurations.background and p3.outfitConfigurations.background.backgroundAsset)

	if v27 and v27.id ~= nil then
		v26.profileConfiguration = {
			backgroundAssetId = v27.id
		}
	end

	local bodyColors = v25.bodyColors

	if typeof(bodyColors) == "table" then
		local t5 = {}

		for v30, v31 in t4 do
			t5[v31] = bodyColors[v30]
		end

		v26.bodyColors = nil
		v26.bodyColor3s = t5
	end

	return v26
end

function t2.GetOutfit(p4, p5, t6: {[any]: any}?) -- line: 99
	-- upvalues: FFlagAXOutfitDetailsV4 (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), Url (copy), remapV4OutfitDetailsToV3 (copy)
	if not FFlagAXOutfitDetailsV4 then
		local v36

		if (FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables) and t6 then
			local v35 = `?{ Url:makeQueryString(t6) }`

			v36 = `{ Url.AVATAR_URL }/v3/outfits/{ p5 }/details{ v35 }`
		else
			v36 = string.format("%s/v3/outfits/%s/details", Url.AVATAR_URL, p5)
		end

		return p4(v36, "GET")
	end

	return p4((if not (FFlagAXModeratedItemsFlow or FFlagAXEnableModeratedItemsFlowForDurables) or not t6 then `{ Url.AVATAR_URL }v4/outfits/{ p5 }/details` else `{ Url.AVATAR_URL }v4/outfits/{ p5 }/details?{ Url:makeQueryString(t6) }`), "GET"):andThen(function(p6) -- line: 115
		-- upvalues: remapV4OutfitDetailsToV3 (copy)
		local v74 = if typeof(p6) ~= "table" then nil else p6[1]
		local v75 = remapV4OutfitDetailsToV3(v74)

		if v75 == nil then
			error("WebApi.GetOutfit: v4 outfit-details response missing outfitModel")
		end

		return { v75 }
	end)
end
function t2.GetRecommendations(p7, p8, p9, p10) -- line: 125
	-- upvalues: Constants (copy), Url (copy)
	local v41 = p10 or Constants.NumRecommendedItems
	local v42 = Url:makeQueryString({
		details = true,
		numItems = v41
	})
	local s1 = "%s/v2/recommendations/user-inventory?bundleTypeId=%s&%s"

	if p9 then
		s1 = "%s/v2/recommendations/user-inventory?assetTypeId=%s&%s"
	end

	return p7(string.format(s1, Url.CATALOG_URL, p8, v42), "GET")
end
function t2.GetMySharedAvatars(p11, p12, p13) -- line: 146
	-- upvalues: Url (copy)
	return p11(string.format("%s/look-api/v1/users/%s/looks?limit=50&cursor=%s", Url.APIS_URL, p12, p13 or ""), "GET")
end
function t2.GetRemoteUpranked(p14, p15, p16) -- line: 152
	-- upvalues: Url (copy)
	local v50 = Url:makeQueryString({
		unsavedItems = p16
	})

	return p14(`{ Url.AVATAR_URL }v1/users/{ p15 }/currently-wearing-outfits?{ v50 }`, "GET")
end
function t2.GetUserAvatarInventory(p17, t7: {[any]: any}, p18, p19, p20, n1: number?) -- line: 162
	-- upvalues: GetFFlagAXEnableNewInventoryItemsList (copy), FFlagAXInventoryDurablesExpiredFilter (copy), FFlagAXInventoryIncludeUnavailableItems (copy), Url (copy)
	if GetFFlagAXEnableNewInventoryItemsList() then
		local t8 = {
			pageLimit = p19,
			sortOption = p18,
			pageToken = p20,
			availabilityStatus = if not FFlagAXInventoryDurablesExpiredFilter then nil else n1,
			includeUnavailableItems = not not FFlagAXInventoryIncludeUnavailableItems or nil
		}

		for v58, v59 in t7 do
			local v60 = v58 - 1

			t8[`itemCategories[{ v60 }].itemType`] = v59.itemType
			t8[`itemCategories[{ v60 }].itemSubType`] = tostring(v59.itemSubType)
		end

		return p17(`{ Url.AVATAR_URL }v1/avatar-inventory?{ Url:makeQueryString(t8) }`, "GET")
	end

	local s2 = ""

	for v62, v63 in t7 do
		local v64 = v62 - 1

		s2 ..= `&itemCategories[{ v64 }].itemType={ v63.itemType }` .. `&itemCategories[{ v64 }].itemSubType={ v63.itemSubType }`
	end

	local v65 = not FFlagAXInventoryIncludeUnavailableItems and "" or "&includeUnavailableItems=true"
	local v67

	if FFlagAXInventoryDurablesExpiredFilter then
		local v66 = not n1 and "" or `&availabilityStatus={ n1 }`

		v67 = `{ Url.AVATAR_URL }v1/avatar-inventory?pageLimit={ p19 }&sortOption={ p18 }&pageToken={ p20 }{ s2 }{ v66 }{ v65 }`
	else
		v67 = `{ Url.AVATAR_URL }v1/avatar-inventory?pageLimit={ p19 }&sortOption={ p18 }&pageToken={ p20 }{ s2 }{ v65 }`
	end

	return p17(v67, "GET")
end
function t2.GetPreviewLook(p21, t9: {[any]: any}) -- line: 216
	-- upvalues: Url (copy), HttpService (copy)
	return p21(string.format("%slook-api/v1/looks/preview", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			assets = t9
		})
	})
end
function t2.CreateLook(p22, t10: {[any]: any}, p23) -- line: 223
	-- upvalues: Url (copy), HttpService (copy)
	return p22(string.format("%slook-api/v1/looks/create", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			assets = t10,
			name = p23.name,
			description = p23.description,
			displayProperties = p23.displayProperties,
			avatarProperties = p23.avatarProperties
		})
	})
end

return t2
