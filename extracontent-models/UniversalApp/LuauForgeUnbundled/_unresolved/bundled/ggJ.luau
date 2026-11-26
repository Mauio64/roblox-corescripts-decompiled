local url = require("@luauforge/bundled/ggD").Url

function LUAUFORGE_MODULE_GLOBALS_ggJ_getStartAuthenticationUrl()
	return string.format("%sv1/passkey/StartAuthentication", url.AUTH_URL)
end

return function(callback)
	return callback(LUAUFORGE_MODULE_GLOBALS_ggJ_getStartAuthenticationUrl(), "POST")
end
