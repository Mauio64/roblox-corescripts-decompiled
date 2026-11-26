local urlBuilder = require("@luauforge/bundled/dTQ").UrlBuilder
local url = require("@luauforge/bundled/dTR").Url
local module = require("@luauforge/bundled/dTN")

local v5 = urlBuilder.new({ base = url.APIS_URL, path = module.ItemDetailsSduiUrl })

local function getItemDetailsPageUrl()
	return v5()
end

return getItemDetailsPageUrl
