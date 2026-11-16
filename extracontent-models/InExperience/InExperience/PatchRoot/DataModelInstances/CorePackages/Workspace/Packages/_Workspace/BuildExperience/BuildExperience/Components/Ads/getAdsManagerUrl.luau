local parent = script:FindFirstAncestor("BuildExperience").Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local v = urlBuilder.fromString("create:advertise")
local v2 = urlBuilder.fromString("create:advertise/manage")

local function getDefaultAdsManagerUrl()
	return v()
end

return {
	getDefaultAdsManagerUrl = getDefaultAdsManagerUrl,
	getAdsManagerUrl = function(universeId: number?)
		if universeId == nil or universeId <= 0 then
			return getDefaultAdsManagerUrl()
		end

		return urlBuilder.addQueryString(v2(), { universeId = universeId })
	end
}
