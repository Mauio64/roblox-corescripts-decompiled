local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/fJF").Url
require("@luauforge/bundled/fJF")

require("@luauforge/bundled/fJj")

function LUAUFORGE_MODULE_GLOBALS_fJM_getContinueRecoveryUrl()
	return string.format("%saccount-recovery-service/v1/continue-recovery", url.APIS_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_fJM_getContinueRecoveryUrl(), "POST", {
		postBody = jsonEncode
	})
end
