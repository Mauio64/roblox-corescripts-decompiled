local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Http")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local normalize = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceCommon").Utils.normalize

local url = Http.Url
local normalizeNumber = normalize.normalizeNumber
local normalizeString = normalize.normalizeString

local value = tostring(Enum.AvatarAssetType.EmoteAnimation.Value)

return {
	EMOTE_ASSET_TYPE_ID = value,
	buildEmoteRecommendationsUrl = function(p2)
		local queryString = url:makeQueryString({ numItems = p2, details = true })

		return `{url.CATALOG_URL}v2/recommendations/user-inventory?assetTypeId={value}&{queryString}`
	end,
	parseEmoteRecommendationsResponse = function(p2)
		local data = if p2 then p2.data else nil

		if typeof(data) ~= "table" then
			return {}
		end

		local result = {}

		for k, v5 in data do
			if not (typeof(v5) == "table" and v5.id ~= nil) then
				continue
			end

			local name = v5.name
			local str = normalizeString(v5.priceStatus)
			local v6 = {
				id = tostring(v5.id),
				label = typeof(name) ~= "string" and "" or name,
				priceInRobux = normalizeNumber(v5.price),
				lowestPrice = normalizeNumber(v5.lowestPrice),
				priceStatus = 0
			}

			if str == nil or str == "" then
				str = nil
			end

			v6.priceStatus = str
			table.insert(result, v6)
		end

		return result
	end,
	getEmoteRecommendationsUrl = function(options)
		local numItems = (options or {}).numItems or Constants.RecommendedEmoteCount
		local queryString = url:makeQueryString({ numItems = numItems, details = true })

		return `{url.CATALOG_URL}v2/recommendations/user-inventory?assetTypeId={value}&{queryString}`
	end
}
