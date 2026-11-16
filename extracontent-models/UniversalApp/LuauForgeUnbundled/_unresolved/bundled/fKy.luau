local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/fJF").Url
require("@luauforge/bundled/fJF")

require("@luauforge/bundled/fJj")

function LUAUFORGE_MODULE_GLOBALS_fKy_getSetEmailUrl()
	return string.format("%saccount-recovery-service/v1/set-email", url.APIS_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_fKy_getSetEmailUrl(), "POST", {
		postBody = jsonEncode
	})
end
