local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local config = LuaSocialLibrariesDeps.SocialLibraries.config({})

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local v5 = logger.new(logger, "ShareTargetGame")

local HttpRequest = require(CorePackages.Packages.HttpRequest)
local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppDefaultHttpRetry
local config2 = HttpRequest.config
local v6 = {
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("ShareTargetGameHttpRetryCount", 4) else nil
v6.maxRetryCount = v7
local v8 = config2(v6)

return {
	Diag = require("@luauforge/bundled/bZt").AnalyticsReporters.Diag,
	EventStream = require("@luauforge/bundled/bZt").AnalyticsReporters.EventStream,
	Roact = require(CorePackages.Packages.Roact),
	Rodux = require(CorePackages.Packages.Rodux),
	RoactRodux = require(CorePackages.Packages.RoactRodux),
	SocialLibraries = config,
	Text = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Text,
	UIBlox = require(CorePackages.Packages.UIBlox),
	User = require("@luauforge/bundled/ciE").Models.UserModel,
	UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").UniversalAppPolicy,
	withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization,
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/Localization").LocalizationProvider,
	Promise = require(CorePackages.Packages.Promise),
	request = v8,
	SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags"),
	RoactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices,
	RoactLocalization = require("@luauforge/bundled/egY"),
	Mock = LuaSocialLibrariesDeps.Mock
}
