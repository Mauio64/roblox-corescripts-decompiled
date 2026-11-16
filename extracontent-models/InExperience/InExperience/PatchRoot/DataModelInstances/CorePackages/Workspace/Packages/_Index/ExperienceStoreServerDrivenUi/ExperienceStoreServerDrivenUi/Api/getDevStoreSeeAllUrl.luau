local parent = script:FindFirstAncestor("ExperienceStoreServerDrivenUi").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local Http = require(parent.Http)
local Url = Http.Url
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDevStoreSeeAllAdvertiseCapabilities = SharedFlags.FFlagLuaAppDevStoreSeeAllAdvertiseCapabilities

local v = urlBuilder.new({
	base = Url.APIS_URL,
	path = "experience-store/v1beta1/universes/{universeId}/dev-store-see-all"
})

local function getDevStoreSeeAllUrl(universeId: string)
	local devStoreSeeAllUrl = v({ universeId = universeId })

	if not FFlagLuaAppDevStoreSeeAllAdvertiseCapabilities then
		return devStoreSeeAllUrl
	end

	local v2 = {}
	SduiCapabilities.addToQueryParams(v2, { "CAPABILITY_SUPPORTS_FOUNDATION_BADGE_OVERMEDIA_LIGHT" })

	if next(v2) ~= nil then
		devStoreSeeAllUrl = urlBuilder.addQueryString(devStoreSeeAllUrl, v2)
	end

	return devStoreSeeAllUrl
end

return getDevStoreSeeAllUrl
