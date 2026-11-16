local parent = script.Parent.Parent.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local Lumberyak = require(parent.Lumberyak)
local ShareLinksNetworking = require(parent.ShareLinksNetworking)
local ShareLinksRodux = require(parent.ShareLinksRodux)

local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local logger = Lumberyak.Logger.new(nil, "ShareGame")
local defineFastInt = game:DefineFastInt("ShareGameHttpRetryCount", 3)
local v = logger:new("ShareGame Networking")
local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
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

local config2 = RoduxNetworking.config({ keyPath = "NetworkStatus", networkImpl = config })

return {
	ShareLinksRodux = ShareLinksRodux.config({ keyPath = "ShareGame.ShareLinks" }),
	RoduxNetworking = config2,
	ShareLinksNetworking = ShareLinksNetworking.config({ roduxNetworking = config2 })
}
