local parent = script:FindFirstAncestor("EditProfileBackground").Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local Lumberyak = require(parent.Lumberyak)

local v = Lumberyak.Logger.new(nil, "EditProfileBackground"):new("EditProfileBackground Networking")
local defineFastInt = game:DefineFastInt("EditProfileBackgroundHttpRetryCount", 3)

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		v:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p2.requestMethod,
				p2.url,
				p.StatusCode,
				p.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

return (RoduxNetworking.config({
	keyPath = "EditProfileBackground.networkStatus",
	networkImpl = config
}))
