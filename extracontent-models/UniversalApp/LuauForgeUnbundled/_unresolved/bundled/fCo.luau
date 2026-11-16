local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/fCk").Url

require("@luauforge/bundled/fCl")

function LUAUFORGE_MODULE_GLOBALS_fCo_getStartAuthenticationByUserUrl()
	return string.format("%sv1/passkey/start-authentication-by-user", url.AUTH_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_fCo_getStartAuthenticationByUserUrl(), "POST", {
		postBody = jsonEncode
	})
end
