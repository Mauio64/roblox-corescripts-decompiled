local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LuaSocialLibrariesDeps = require(CorePackages.Packages.LuaSocialLibrariesDeps)
local v4 = LuaSocialLibrariesDeps.SocialLibraries.config({})
local v5 = require(CorePackages.Workspace.Packages.Loggers).Logger:new("ShareTargetGame")
local HttpRequest = require(CorePackages.Packages.HttpRequest)
local FFlagLuaAppDefaultHttpRetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppDefaultHttpRetry
local v8 = HttpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 12
		-- upvalues: v5 (copy), HttpRequest (copy)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("ShareTargetGameHttpRetryCount", 4)
})

return {
	Diag = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.Diag,
	EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream,
	Roact = require(CorePackages.Packages.Roact),
	Rodux = require(CorePackages.Packages.Rodux),
	RoactRodux = require(CorePackages.Packages.RoactRodux),
	SocialLibraries = v4,
	Text = require(CorePackages.Workspace.Packages.AppCommonLib).Text,
	UIBlox = require(CorePackages.Packages.UIBlox),
	User = require(CorePackages.Workspace.Packages.UserLib).Models.UserModel,
	UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).UniversalAppPolicy,
	withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization,
	LocalizationProvider = require(CorePackages.Workspace.Packages.Localization).LocalizationProvider,
	Promise = require(CorePackages.Packages.Promise),
	request = v8,
	SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags),
	RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices,
	RoactLocalization = require(CoreGui.RobloxGui.Modules.LuaApp.Services.RoactLocalization),
	Mock = LuaSocialLibrariesDeps.Mock
}
