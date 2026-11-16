local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/fJF").Url
require("@luauforge/bundled/fJF")

require("@luauforge/bundled/fJj")

function LUAUFORGE_MODULE_GLOBALS_fJP_getResetPasswordUrl()
	return string.format("%sv2/passwords/reset", url.AUTH_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_fJP_getResetPasswordUrl(), "POST", {
		postBody = jsonEncode
	})
end
