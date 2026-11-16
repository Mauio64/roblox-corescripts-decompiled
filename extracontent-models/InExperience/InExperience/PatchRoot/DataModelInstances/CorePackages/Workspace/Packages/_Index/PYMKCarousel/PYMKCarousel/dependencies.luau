local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local parent = PYMKCarousel.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

local Lumberyak = require(parent.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local defineFastFlag = game:DefineFastFlag("MigratePymkCarouselHttpRequestToRequestInternal", false)
local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper
local defineFastFlag2 = game:DefineFastFlag("EnablePymkCarouselChallengeInterceptor", false)
local FFlagPymkCarouselPresenceStoreMigration = require(PYMKCarousel.Flags.FFlagPymkCarouselPresenceStoreMigration)

local v = Lumberyak.Logger.new(nil, "PYMKCarousel"):new("PYMKCarousel Networking")
local defineFastInt = game:DefineFastInt("PYMKCarouselHttpRetryCount", 3)
local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))

		if defineFastFlag then
			return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end

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

local Constants = require(PYMKCarousel.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config
local v2 = {
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = 0
}

if defineFastFlag2 then
	config = ChallengeRequestWrapper(config)
end

v2.networkImpl = config
local roduxNetworking = config2(v2)

local Dependencies = {
	SocialLuaAnalytics = SocialLuaAnalytics,
	UIBlox = require(parent.UIBlox),
	Roact = require(parent.Roact),
	React = require(parent.React),
	Rodux = require(parent.Rodux),
	RoactRodux = require(parent.RoactRodux),
	Result = require(parent.Result),
	llama = LuaSocialLibrariesDeps.llama,
	Dash = require(parent.Dash),
	RoduxNetworking = roduxNetworking,
	RoduxFriends = 0,
	RoduxUsers = 0,
	NetworkingFriendsEnums = 0,
	NetworkingFriends = 0,
	RoduxAnalytics = 0,
	Players = 0,
	convertActions = 0,
	usersActionAdaptor = 0,
	friendsActionAdaptor = 0,
	SocialCommon = 0,
	SocialLibraries = 0,
	Hooks = 0,
	LocalizationProvider = 0,
	enumerate = 0,
	getFFlagPYMKAddFriendsEntry = 0,
	NetworkingPresence = 0
}

local FriendsRodux = require(parent.FriendsRodux)
Dependencies.RoduxFriends = FriendsRodux.config({
	keyPath = RODUX_KEY .. ".Friends"
})

Dependencies.RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
	keyPath = RODUX_KEY .. ".Users"
})

local FriendsNetworking = require(parent.FriendsNetworking)
Dependencies.NetworkingFriendsEnums = FriendsNetworking.Enums
local FriendsNetworking2 = require(parent.FriendsNetworking)
Dependencies.NetworkingFriends = FriendsNetworking2.config({ roduxNetworking = roduxNetworking })

Dependencies.RoduxAnalytics = SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
	keyPath = RODUX_KEY .. ".Analytics"
})

Dependencies.Players = game:GetService("Players")
local SocialReducerAdaptors = require(parent.SocialReducerAdaptors)
Dependencies.convertActions = SocialReducerAdaptors.convertActions
local SocialReducerAdaptors2 = require(parent.SocialReducerAdaptors)
Dependencies.usersActionAdaptor = SocialReducerAdaptors2.usersActionAdaptor
local SocialReducerAdaptors3 = require(parent.SocialReducerAdaptors)
Dependencies.friendsActionAdaptor = SocialReducerAdaptors3.friendsActionAdaptor
Dependencies.SocialCommon = require(parent.SocialCommon)
Dependencies.SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({})

local RoactUtils = require(parent.RoactUtils)
local hooks = {
	useSelector = RoactUtils.Hooks.RoactRodux.useSelector,
	useDispatch = 0,
	useLocalization = 0,
	dependencyArray = 0
}
local RoactUtils2 = require(parent.RoactUtils)
hooks.useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
hooks.useLocalization = Localization.Hooks.useLocalization
local RoactUtils3 = require(parent.RoactUtils)
hooks.dependencyArray = RoactUtils3.Hooks.dependencyArray
Dependencies.Hooks = hooks

local Localization2 = require(parent.Localization)
Dependencies.LocalizationProvider = Localization2.LocalizationProvider
Dependencies.enumerate = require(parent.enumerate)
local SharedFlags = require(parent.SharedFlags)
Dependencies.getFFlagPYMKAddFriendsEntry = SharedFlags.getFFlagPYMKAddFriendsEntry
local networkingPresence

if not FFlagPymkCarouselPresenceStoreMigration then
	networkingPresence = LuaSocialLibrariesDeps.NetworkingPresence.config({
		roduxNetworking = roduxNetworking
	})
end

Dependencies.NetworkingPresence = networkingPresence
return Dependencies
