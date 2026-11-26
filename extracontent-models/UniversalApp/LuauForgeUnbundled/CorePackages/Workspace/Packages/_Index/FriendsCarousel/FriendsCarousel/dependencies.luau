local module = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialLuaAnalytics")
local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/LuaSocialLibrariesDeps")

local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Loggers").Logger:new("FriendsCarousel")

local v6 = v5:new("FriendsCarousel Networking")
local defineFastInt = game:DefineFastInt("FriendsCarouselHttpRetryCount", 3)

local getFFlagMigrateSocialNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").getFFlagMigrateSocialNetworking

local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))

		if getFFlagMigrateSocialNetworking() then
			return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	postRequestFunction = function(p2, p3)
		v6:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s ]",
				p3.requestMethod,
				p3.url,
				p2.StatusCode
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/Common/Constants").RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/UIBlox")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/RobloxAppHooks")

return {
	logger = v5,
	SocialLuaAnalytics = module,
	Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Promise"),
	UIBlox = module3,
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Roact"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/React"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Rodux"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/RoactRodux"),
	t = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/t"),
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Dash"),
	llama = LuaSocialLibrariesDeps.llama,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialCommon"),
	RoduxNetworking = config2,
	NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/NetworkingFriends").config({ roduxNetworking = config2 }),
	NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({ roduxNetworking = config2 }),
	RoduxFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/FriendsRodux").config({
		keyPath = RODUX_KEY .. ".Friends"
	}),
	RoduxAnalytics = module.Analytics.RoduxAnalytics.config({
		keyPath = RODUX_KEY .. ".Analytics"
	}),
	convertActions = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialReducerAdaptors").convertActions,
	friendsActionAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SocialReducerAdaptors").friendsActionAdaptor,
	Text = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/AppCommonLib").Text,
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/enumerate"),
	RetrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Http").Enum.RetrievalStatus,
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/Analytics").Analytics.new(game:GetService("RbxAnalyticsService")),
	isSubjectToDesktopPolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsCarousel/SharedFlags").isSubjectToDesktopPolicies,
	isSubjectTo10ftPolicies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsCarousel/FriendsCarousel/isSubjectTo10ftPolicies")
}
