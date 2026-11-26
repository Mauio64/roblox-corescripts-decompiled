local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/ggD").Url

require("@luauforge/bundled/ggE")

function LUAUFORGE_MODULE_GLOBALS_ggC_getInitializeLoginUrl()
	return string.format("%sv1/identity/initialize-login", url.AUTH_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_ggC_getInitializeLoginUrl(), "POST", {
		postBody = jsonEncode
	})
end
