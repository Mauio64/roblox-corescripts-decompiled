local url = require("@luauforge/bundled/hIR").Url
local urlBuilder = require("@luauforge/bundled/hIF").UrlBuilder.new({
	base = url.APIS_URL,
	path = "payments-ui-data-fetcher-service/v1/buy-robux-sdui-page"
})

local function getBuyRobuxSduiPageUrl()
	return urlBuilder()
end

return getBuyRobuxSduiPageUrl
