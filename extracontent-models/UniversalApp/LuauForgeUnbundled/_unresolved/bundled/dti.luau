local url = require("@luauforge/bundled/drq").Url
local addSystemInfoToArgs = require("@luauforge/bundled/dqK").AddSystemInfoToArgs

local defineFastFlag = game:DefineFastFlag("SearchLandingPageDeviceParams", false)

return function(callback, p2)
	local APIS_URL = url.APIS_URL

	if defineFastFlag then
		addSystemInfoToArgs(p2)
	end

	local queryString = url:makeQueryString(p2)
	return callback(string.format("%ssearch-landing-page-api/v1?%s", APIS_URL, queryString), "GET")
end
