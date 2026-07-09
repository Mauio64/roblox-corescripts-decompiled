local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local httpRequest = require(ProfilePlatformParent.LuaSocialLibrariesDeps).httpRequest
local RODUX_KEY = require(ProfilePlatform.Common.Constants).RODUX_KEY
local v5 = require(ProfilePlatformParent.Lumberyak).Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local v6 = game:DefineFastInt("ProfilePlatformHttpRetryCount", 3)

return (httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 13
		-- upvalues: v5 (copy), httpRequest (copy)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 17
		-- upvalues: v5 (copy)
		v5:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v6
}))
