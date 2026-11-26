local url = require("@luauforge/bundled/goa").Url
require("@luauforge/bundled/goa")

function LUAUFORGE_MODULE_GLOBALS_goZ_getCurrentTwoStepMethodUrl(p2)
	return string.format(
		"%saccount-recovery-service/v1/get-current-two-step-method?recoverySessionId=%s",
		url.APIS_URL,
		p2
	)
end

return function(callback, p2)
	return callback(LUAUFORGE_MODULE_GLOBALS_goZ_getCurrentTwoStepMethodUrl(p2), "GET")
end
