local Parent = script:FindFirstAncestor("EditProfileBackground").Parent
local LuaSocialLibrariesDeps = require(Parent.LuaSocialLibrariesDeps)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v5 = require(Parent.Lumberyak).Logger.new(nil, "EditProfileBackground"):new("EditProfileBackground Networking")
local v6 = game:DefineFastInt("EditProfileBackgroundHttpRetryCount", 3)
local v7 = httpRequest.config({
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
})

return (RoduxNetworking.config({
	keyPath = "EditProfileBackground.networkStatus",
	networkImpl = v7
}))
