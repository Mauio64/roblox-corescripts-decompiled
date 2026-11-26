local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/UrlBuilder").UrlBuilder

local v5 = urlBuilder.fromString("create:advertise")
local v6 = urlBuilder.fromString("create:advertise/manage")

local function getDefaultAdsManagerUrl()
	return v5()
end

return {
	getDefaultAdsManagerUrl = getDefaultAdsManagerUrl,
	getAdsManagerUrl = function(p2)
		if p2 == nil or p2 <= 0 then
			return getDefaultAdsManagerUrl()
		end

		return urlBuilder.addQueryString(v6(), { universeId = p2 })
	end
}
