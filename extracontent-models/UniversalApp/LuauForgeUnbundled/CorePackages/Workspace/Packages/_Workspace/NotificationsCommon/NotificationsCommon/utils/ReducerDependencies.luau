local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/LuaSocialLibrariesDeps")
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/Lumberyak")
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NetworkingShareLinks")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/ShareLinksRodux")

local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local logger = Lumberyak.Logger.new(nil, "ShareGame")
local defineFastInt = game:DefineFastInt("ShareGameHttpRetryCount", 3)
local v5 = logger:new("ShareGame Networking")
local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
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

local config2 = roduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = config
})

return {
	ShareLinksRodux = module4.config({ keyPath = "ShareGame.ShareLinks" }),
	RoduxNetworking = config2,
	ShareLinksNetworking = NetworkingShareLinks.config({ roduxNetworking = config2 })
}
