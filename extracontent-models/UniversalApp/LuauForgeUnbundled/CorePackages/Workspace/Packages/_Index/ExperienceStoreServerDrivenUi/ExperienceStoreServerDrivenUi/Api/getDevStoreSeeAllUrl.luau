local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/UrlBuilder").UrlBuilder
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/Http").Url
local sduiCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SduiSharedUtilities").SduiCapabilities

local fFlagLuaAppDevStoreSeeAllAdvertiseCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/ExperienceStoreServerDrivenUi/SharedFlags").FFlagLuaAppDevStoreSeeAllAdvertiseCapabilities

local v5 = urlBuilder.new({
	base = url.APIS_URL,
	path = "experience-store/v1beta1/universes/{universeId}/dev-store-see-all"
})

local function getDevStoreSeeAllUrl(p2)
	local devStoreSeeAllUrl = v5({ universeId = p2 })

	if not fFlagLuaAppDevStoreSeeAllAdvertiseCapabilities then
		return devStoreSeeAllUrl
	end

	local v6 = {}
	sduiCapabilities.addToQueryParams(v6, { "CAPABILITY_SUPPORTS_FOUNDATION_BADGE_OVERMEDIA_LIGHT" })

	if next(v6) ~= nil then
		devStoreSeeAllUrl = urlBuilder.addQueryString(devStoreSeeAllUrl, v6)
	end

	return devStoreSeeAllUrl
end

return getDevStoreSeeAllUrl
