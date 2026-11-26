local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

require("@luauforge/bundled/gnE")

function LUAUFORGE_MODULE_GLOBALS_gok_getResetPasswordUrl()
	return string.format("%sv2/passwords/reset", url.AUTH_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_gok_getResetPasswordUrl(), "POST", {
		postBody = jsonEncode
	})
end
