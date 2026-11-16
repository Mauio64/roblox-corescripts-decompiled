local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/LuaSocialLibrariesDeps")
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Lumberyak")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/ContentSharingNetworking")
local RoduxAliases = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/RoduxAliases")
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local networkingCurrentlyWearing = LuaSocialLibrariesDeps.NetworkingCurrentlyWearing
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/NetworkingGames")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/NetworkingUsers")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/RoduxGames")
local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/RoduxUsers")
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/NetworkingShareLinks")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/ShareLinksRodux")

local module11 = require("@luauforge/deferred/dVV")

local logger = Lumberyak.Logger.new(nil, module11.LoggerKey)

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		logger:debug(`Request: [ requestMethod = {p3}, url = {p2} ]`)
		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		logger:debug(`Response: [ requestMethod = {p3.requestMethod}, url = {p3.url}, statusCode = {p2.StatusCode}, body = {p2.Body} ]`)
	end,
	maxRetryCount = game:DefineFastInt("ContentFeedMaxHttpRequestRetries", 2),
	maxWaitTime = game:DefineFastInt("ContentFeedMaxHttpRequestWaitTime", 8)
})

local config2 = roduxNetworking.config({
	keyPath = "NetworkStatus",
	networkImpl = config
})

return {
	ContentFeedNetworkImpl = config,
	ContentSharingNetworking = module3.config({ roduxNetworking = config2 }),
	ContentSharingRodux = RoduxAliases.config({ keyPath = "ContentSharing" }),
	NetworkingCurrentlyWearing = networkingCurrentlyWearing.config({
		roduxNetworking = config2
	}),
	NetworkingGames = module5.config({ roduxNetworking = config2 }),
	NetworkingUsers = module6.config({ roduxNetworking = config2 }),
	RoduxGames = module7.config({ keyPath = "Games" }),
	RoduxNetworking = config2,
	RoduxUsers = module8.config({ keyPath = "Users" }),
	ShareLinksNetworking = NetworkingShareLinks.config({ roduxNetworking = config2 }),
	ShareLinksRodux = module10.config({ keyPath = "ShareLinks" })
}
