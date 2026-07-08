local ParentParent = script.Parent.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local Lumberyak = require(ParentParent.Lumberyak)
local ShareLinksNetworking = require(ParentParent.ShareLinksNetworking)
local ShareLinksRodux = require(ParentParent.ShareLinksRodux)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v8 = Lumberyak.Logger.new(nil, "ShareGame")
local v9 = game:DefineFastInt("ShareGameHttpRetryCount", 3)
local v10 = v8:new("ShareGame Networking")
local v11 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 17
		-- upvalues: v10 (copy), httpRequest (copy)
		v10:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 21
		-- upvalues: v10 (copy)
		v10:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v9
})
local v12 = RoduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = v11
})

return {
	ShareLinksRodux = ShareLinksRodux.config({
		keyPath = "ShareGame.ShareLinks"
	}),
	RoduxNetworking = v12,
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = v12
	})
}
