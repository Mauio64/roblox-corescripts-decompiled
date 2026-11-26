local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

function LUAUFORGE_MODULE_GLOBALS_gpg_getCredentialsToInvalidateUrl(p2)
	return string.format(
		"%saccount-recovery-service/v1/get-credentials-to-invalidate?recoverySessionId=%s",
		url.APIS_URL,
		p2
	)
end

return function(callback, p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_gpg_getCredentialsToInvalidateUrl(p2), "GET")
end
