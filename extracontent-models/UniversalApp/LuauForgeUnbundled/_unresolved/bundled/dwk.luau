local url = require("@luauforge/bundled/dus").Url
local addSystemInfoToArgs = require("@luauforge/bundled/dtM").AddSystemInfoToArgs

return function(callback, p2)
	local APIS_URL = url.APIS_URL
	addSystemInfoToArgs(p2)

	local queryString = url:makeQueryString(p2)
	return callback(string.format("%ssearch-landing-page-api/v1?%s", APIS_URL, queryString), "GET")
end
