local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/LuaSocialLibrariesDeps")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialLuaAnalytics")

local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Lumberyak")
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local defineFastFlag = game:DefineFastFlag("MigratePymkCarouselHttpRequestToRequestInternal", false)
local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/GenericChallenges").Middleware.ChallengeRequestWrapper
local defineFastFlag2 = game:DefineFastFlag("EnablePymkCarouselChallengeInterceptor", false)
local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")

local v5 = Lumberyak.Logger.new(nil, "PYMKCarousel"):new("PYMKCarousel Networking")
local defineFastInt = game:DefineFastInt("PYMKCarouselHttpRetryCount", 3)
local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))

		if defineFastFlag then
			return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end

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

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config
local v6 = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}

if defineFastFlag2 then
	config = challengeRequestWrapper(config)
end

v6.networkImpl = config
local v7 = config2(v6)

local v8 = {
	SocialLuaAnalytics = module2,
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UIBlox"),
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Roact"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/React"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Rodux"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactRodux"),
	Result = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Result"),
	llama = LuaSocialLibrariesDeps.llama,
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Dash"),
	RoduxNetworking = v7,
	RoduxFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/FriendsRodux").config({
		keyPath = RODUX_KEY .. ".Friends"
	}),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = RODUX_KEY .. ".Users"
	}),
	NetworkingFriendsEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/NetworkingFriends").Enums,
	NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/NetworkingFriends").config({ roduxNetworking = v7 }),
	RoduxAnalytics = module2.Analytics.RoduxAnalytics.config({
		keyPath = RODUX_KEY .. ".Analytics"
	}),
	Players = game:GetService("Players"),
	convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialReducerAdaptors").convertActions,
	usersActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialReducerAdaptors").usersActionAdaptor,
	friendsActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialReducerAdaptors").friendsActionAdaptor,
	SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialCommon"),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	Hooks = {
		useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.RoactRodux.useSelector,
		useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.RoactRodux.useDispatch,
		useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Localization").Hooks.useLocalization,
		dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/RoactUtils").Hooks.dependencyArray
	},
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Localization").LocalizationProvider,
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/enumerate"),
	getFFlagPYMKAddFriendsEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SharedFlags").getFFlagPYMKAddFriendsEntry,
	NetworkingPresence = 0
}

local v9 = if not FFlagPymkCarouselPresenceStoreMigration then LuaSocialLibrariesDeps.NetworkingPresence.config({ roduxNetworking = v7 }) else nil
v8.NetworkingPresence = v9
return v8
