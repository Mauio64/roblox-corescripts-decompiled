local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent
local Http = require(parent.Http)

local Constants = require(script.Parent.Parent.Constants)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local normalize = AvatarExperienceCommon.Utils.normalize

local Url = Http.Url
local normalizeNumber = normalize.normalizeNumber
local normalizeString = normalize.normalizeString

local value = tostring(Enum.AvatarAssetType.EmoteAnimation.Value)

local function buildEmoteRecommendationsUrl(numItems: number) -- 1 equivalent call inferred from this helper
	local queryString = Url:makeQueryString({ numItems = numItems, details = true })

	return `{Url.CATALOG_URL}v2/recommendations/user-inventory?assetTypeId={value}&{queryString}`
end

local GetEmoteRecommendations = {}
GetEmoteRecommendations.EMOTE_ASSET_TYPE_ID = value
GetEmoteRecommendations.buildEmoteRecommendationsUrl = buildEmoteRecommendationsUrl

function GetEmoteRecommendations.parseEmoteRecommendationsResponse(p)
	local data

	if p then
		data = p.data
	end

	if typeof(data) ~= "table" then
		return {}
	end

	local result = {}

	for _, v in data do
		if not (typeof(v) == "table" and v.id ~= nil) then
			continue
		end

		local name = v.name
		local str = normalizeString(v.priceStatus)
		local v2 = {
			id = tostring(v.id),
			label = typeof(name) ~= "string" and "" or name,
			priceInRobux = normalizeNumber(v.price),
			lowestPrice = normalizeNumber(v.lowestPrice),
			priceStatus = 0
		}

		if str == nil or str == "" then
			str = nil
		end

		v2.priceStatus = str
		table.insert(result, v2)
	end

	return result
end

function GetEmoteRecommendations.getEmoteRecommendationsUrl(options)
	return buildEmoteRecommendationsUrl((options or {}).numItems or Constants.RecommendedEmoteCount) -- inferred equivalent call
end

return GetEmoteRecommendations
