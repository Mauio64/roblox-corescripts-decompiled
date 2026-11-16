local httpRequest = require("@luauforge/bundled/eUd").httpRequest
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants").RODUX_KEY
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Lumberyak").Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local defineFastInt = game:DefineFastInt("ProfilePlatformHttpRetryCount", 3)

return (httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		v5:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p3.requestMethod,
				p3.url,
				p2.StatusCode,
				p2.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
}))
