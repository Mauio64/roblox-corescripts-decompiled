local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

require("@luauforge/bundled/gnE")

function LUAUFORGE_MODULE_GLOBALS_goF_getSendCodeUrl()
	return string.format("%saccount-recovery-service/v1/send-code", url.APIS_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_goF_getSendCodeUrl(), "POST", {
		postBody = jsonEncode
	})
end
