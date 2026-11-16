local url = require("@luauforge/bundled/fJF").Url
require("@luauforge/bundled/fJF")

function LUAUFORGE_MODULE_GLOBALS_fJG_getRequestRecoveryUrl()
	return string.format("%sphone-number-api/v1/phone-prefix-list", url.APIS_URL)
end

return function(callback)
	return callback(LUAUFORGE_MODULE_GLOBALS_fJG_getRequestRecoveryUrl(), "GET")
end
