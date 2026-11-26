local HttpService = game:GetService("HttpService")
local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

require("@luauforge/bundled/gnE")

function LUAUFORGE_MODULE_GLOBALS_gpb_getDisableTwoStepMethodUrl()
	return string.format("%saccount-recovery-service/v1/disable-two-step-method", url.APIS_URL)
end

return function(callback, p2)
	local jsonEncode = HttpService:JSONEncode(p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_gpb_getDisableTwoStepMethodUrl(), "POST", {
		postBody = jsonEncode
	})
end
