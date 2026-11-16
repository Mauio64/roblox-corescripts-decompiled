local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/fJF").Url
require("@luauforge/bundled/fJF")

require("@luauforge/bundled/fJj")

function LUAUFORGE_MODULE_GLOBALS_fKN_getInvalidateCredentialsUrl()
	return string.format("%saccount-recovery-service/v1/invalidate-credentials", url.APIS_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_fKN_getInvalidateCredentialsUrl(), "POST", {
		postBody = jsonEncode
	})
end
