local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/LuaSocialLibrariesDeps")
local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/SetAlias/Common/Constants").RODUX_KEY

local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Lumberyak")
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local v5 = Lumberyak.Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local defineFastInt = game:DefineFastInt("SetAliasHttpRetryCount", 3)
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
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/SocialLuaAnalytics")

return {
	AppStorageService = game:GetService("AppStorageService"),
	Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Analytics"),
	SocialLuaAnalytics = module3,
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Dash"),
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/UIBlox"),
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Roact"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactRodux"),
	RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactNavigation"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Rodux"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/React"),
	ContactsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/ContactsProtocol").ContactsProtocol,
	Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Promise"),
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/enumerate"),
	UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/SetAlias/UserProfiles"),
	RoactFitComponents = LuaSocialLibrariesDeps.RoactFitComponents,
	RoduxNetworking = config2,
	NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({ roduxNetworking = config2 }),
	RoduxAliases = LuaSocialLibrariesDeps.RoduxAliases.config({
		keyPath = RODUX_KEY .. ".Aliases"
	}),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Localization").LocalizationProvider,
	Hooks = {
		useEffectOnMount = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactUtils").Hooks.useEffectOnMount,
		useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Localization").Hooks.useLocalization,
		useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactUtils").Hooks.RoactRodux.useSelector,
		useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RoactUtils").Hooks.RoactRodux.useDispatch,
		useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/RobloxAppHooks").useLocalUserId
	},
	Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SetAlias/Foundation")
}
