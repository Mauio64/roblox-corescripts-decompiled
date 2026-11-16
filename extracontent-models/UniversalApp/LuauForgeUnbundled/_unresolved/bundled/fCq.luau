local url = require("@luauforge/bundled/fCk").Url

function LUAUFORGE_MODULE_GLOBALS_fCq_getStartAuthenticationUrl()
	return string.format("%sv1/passkey/StartAuthentication", url.AUTH_URL)
end

return function(callback)
	return callback(LUAUFORGE_MODULE_GLOBALS_fCq_getStartAuthenticationUrl(), "POST")
end
