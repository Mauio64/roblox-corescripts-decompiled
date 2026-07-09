local ProfileShareLinks = script:FindFirstAncestor("ProfileShareLinks")
local ProfileShareLinksParent = ProfileShareLinks.Parent
local LuaSocialLibrariesDeps = require(ProfileShareLinksParent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local RODUX_KEY = require(ProfileShareLinks.Common.Constants).RODUX_KEY
local v7 = require(ProfileShareLinksParent.Lumberyak).Logger.new(nil, "ProfileShareLinks"):new("ProfileShareLinks Networking")
local v8 = game:DefineFastInt("ProfileShareLinksHttpRetryCount", 3)
local v9 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 14
		-- upvalues: v7 (copy), httpRequest (copy)
		v7:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 18
		-- upvalues: v7 (copy)
		v7:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v8
})

return (RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v9
}))
