local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/LuaSocialLibrariesDeps")
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/EditProfileBackground/Lumberyak").Logger.new(nil, "EditProfileBackground"):new("EditProfileBackground Networking")
local defineFastInt = game:DefineFastInt("EditProfileBackgroundHttpRetryCount", 3)

local config = httpRequest.config({
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
})

return (roduxNetworking.config({
	keyPath = "EditProfileBackground.networkStatus",
	networkImpl = config
}))
