local urlBuilder = require("@luauforge/bundled/fJE").UrlBuilder
local url = require("@luauforge/bundled/fJF").Url
local module = require("@luauforge/bundled/fJG")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = module.ApiName })

local function getCampaignPageUrl()
	return v5()
end

return getCampaignPageUrl
