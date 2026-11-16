local urlBuilder = require("@luauforge/bundled/dQA").UrlBuilder
local url = require("@luauforge/bundled/dQB").Url
local module = require("@luauforge/bundled/dQx")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = module.ItemDetailsSduiUrl })

local function getItemDetailsPageUrl()
	return urlBuilder.addQueryString(v5(), {
		pageidentifier = module.ItemDetailsPageIdentifier
	})
end

return getItemDetailsPageUrl
