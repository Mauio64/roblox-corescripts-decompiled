local urlBuilder = require("@luauforge/bundled/hGE").UrlBuilder
local url = require("@luauforge/bundled/hGF").Url
local module = require("@luauforge/bundled/hGG")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = module.ApiName })

local function getCampaignPageUrl()
	return v5()
end

return getCampaignPageUrl
