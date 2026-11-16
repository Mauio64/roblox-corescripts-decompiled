local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local Constants = require(ProfileQRCode.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY
local Lumberyak = require(parent.Lumberyak)

local v = Lumberyak.Logger.new(nil, "ProfileQRCode"):new("ProfileQRCode Networking")
local defineFastInt = game:DefineFastInt("ProfileQRCodeHttpRetryCount", 3)

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

return (LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
}))
