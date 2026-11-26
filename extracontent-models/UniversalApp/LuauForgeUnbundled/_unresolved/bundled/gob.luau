local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

function LUAUFORGE_MODULE_GLOBALS_gob_getRequestRecoveryUrl()
	return string.format("%sphone-number-api/v1/phone-prefix-list", url.APIS_URL)
end

return function(callback)
	return callback(LUAUFORGE_MODULE_GLOBALS_gob_getRequestRecoveryUrl(), "GET")
end
