local parent = script.Parent
local parent2 = parent.Parent

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)

local httpRequest = LuaSocialLibrariesDeps.httpRequest
local Loggers = require(parent2.Loggers)
local logger = Loggers.Logger:new("FriendsCarousel")

local v = logger:new("FriendsCarousel Networking")
local defineFastInt = game:DefineFastInt("FriendsCarouselHttpRetryCount", 3)

local SharedFlags = require(parent2.SharedFlags)
local getFFlagMigrateSocialNetworking = SharedFlags.getFFlagMigrateSocialNetworking

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))

		if getFFlagMigrateSocialNetworking() then
			return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		v:debug(
			"Returned: {}",
			string.format("[ requestMethod = %q, url = %q, statusCode = %s ]", p2.requestMethod, p2.url, p.StatusCode)
		)
	end,
	maxRetryCount = defineFastInt
})

local Constants = require(parent.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local UIBlox = require(parent2.UIBlox)

require(parent2.RobloxAppHooks)

local Dependencies = {
	logger = logger,
	SocialLuaAnalytics = SocialLuaAnalytics,
	Promise = require(parent2.Promise),
	UIBlox = UIBlox,
	Roact = require(parent2.Roact),
	React = require(parent2.React),
	Rodux = require(parent2.Rodux),
	RoactRodux = require(parent2.RoactRodux),
	t = require(parent2.t),
	Dash = require(parent2.Dash),
	llama = LuaSocialLibrariesDeps.llama,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialCommon = require(parent2.SocialCommon),
	RoduxNetworking = config2,
	NetworkingFriends = 0,
	NetworkingAliases = 0,
	RoduxFriends = 0,
	RoduxAnalytics = 0,
	convertActions = 0,
	friendsActionAdaptor = 0,
	Text = 0,
	enumerate = 0,
	RetrievalStatus = 0,
	AnalyticsService = 0,
	isSubjectToDesktopPolicies = 0,
	isSubjectTo10ftPolicies = 0
}

local FriendsNetworking = require(parent2.FriendsNetworking)
Dependencies.NetworkingFriends = FriendsNetworking.config({ roduxNetworking = config2 })

Dependencies.NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({
	roduxNetworking = config2
})

local FriendsRodux = require(parent2.FriendsRodux)
Dependencies.RoduxFriends = FriendsRodux.config({
	keyPath = RODUX_KEY .. ".Friends"
})

Dependencies.RoduxAnalytics = SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
	keyPath = RODUX_KEY .. ".Analytics"
})

local SocialReducerAdaptors = require(parent2.SocialReducerAdaptors)
Dependencies.convertActions = SocialReducerAdaptors.convertActions
local SocialReducerAdaptors2 = require(parent2.SocialReducerAdaptors)
Dependencies.friendsActionAdaptor = SocialReducerAdaptors2.friendsActionAdaptor
local AppCommonLib = require(parent2.AppCommonLib)
Dependencies.Text = AppCommonLib.Text
Dependencies.enumerate = require(parent2.enumerate)
local Http = require(parent2.Http)
Dependencies.RetrievalStatus = Http.Enum.RetrievalStatus

local Analytics = require(parent2.Analytics)
Dependencies.AnalyticsService = Analytics.Analytics.new(game:GetService("RbxAnalyticsService"))

local SharedFlags2 = require(parent2.SharedFlags)
Dependencies.isSubjectToDesktopPolicies = SharedFlags2.isSubjectToDesktopPolicies
Dependencies.isSubjectTo10ftPolicies = require(parent.isSubjectTo10ftPolicies)
return Dependencies
