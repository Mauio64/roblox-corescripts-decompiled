local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local SocialLuaAnalytics = require(scriptParentParent.SocialLuaAnalytics)
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v6 = require(scriptParentParent.Loggers).Logger:new("FriendsCarousel")
local v7 = v6:new("FriendsCarousel Networking")
local v8 = game:DefineFastInt("FriendsCarouselHttpRetryCount", 3)
local getFFlagMigrateSocialNetworking = require(scriptParentParent.SharedFlags).getFFlagMigrateSocialNetworking
local v10 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 18
		-- upvalues: v7 (copy), getFFlagMigrateSocialNetworking (copy), httpRequest (copy)
		v7:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		if getFFlagMigrateSocialNetworking() then
			return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 26
		-- upvalues: v7 (copy)
		v7:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s ]", p5.requestMethod, p5.url, p4.StatusCode))
	end,
	maxRetryCount = v8
})
local RODUX_KEY = require(scriptParent.Common.Constants).RODUX_KEY
local v12 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v10
})
local UIBlox = require(scriptParentParent.UIBlox)

require(scriptParentParent.RobloxAppHooks)

return {
	logger = v6,
	SocialLuaAnalytics = SocialLuaAnalytics,
	Promise = require(scriptParentParent.Promise),
	UIBlox = UIBlox,
	Roact = require(scriptParentParent.Roact),
	React = require(scriptParentParent.React),
	Rodux = require(scriptParentParent.Rodux),
	RoactRodux = require(scriptParentParent.RoactRodux),
	t = require(scriptParentParent.t),
	Dash = require(scriptParentParent.Dash),
	llama = LuaSocialLibrariesDeps.llama,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialCommon = require(scriptParentParent.SocialCommon),
	RoduxNetworking = v12,
	NetworkingFriends = require(scriptParentParent.FriendsNetworking).config({
		roduxNetworking = v12
	}),
	NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({
		roduxNetworking = v12
	}),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = RODUX_KEY .. ".Users"
	}),
	RoduxFriends = require(scriptParentParent.FriendsRodux).config({
		keyPath = RODUX_KEY .. ".Friends"
	}),
	RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence.config({
		keyPath = RODUX_KEY .. ".Presence"
	}),
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = RODUX_KEY .. ".UserPermissions"
	}),
	RoduxAnalytics = SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
		keyPath = RODUX_KEY .. ".Analytics"
	}),
	convertActions = require(scriptParentParent.SocialReducerAdaptors).convertActions,
	usersActionAdaptor = require(scriptParentParent.SocialReducerAdaptors).usersActionAdaptor,
	friendsActionAdaptor = require(scriptParentParent.SocialReducerAdaptors).friendsActionAdaptor,
	presenceActionAdaptor = require(scriptParentParent.SocialReducerAdaptors).presenceActionAdaptor,
	Text = require(scriptParentParent.AppCommonLib).Text,
	enumerate = require(scriptParentParent.enumerate),
	RetrievalStatus = require(scriptParentParent.Http).Enum.RetrievalStatus,
	AnalyticsService = require(scriptParentParent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService")),
	ShowContactImporterParams = require(scriptParentParent.ContactImporter).ShowContactImporterParams,
	isSubjectToDesktopPolicies = require(scriptParentParent.SharedFlags).isSubjectToDesktopPolicies,
	isSubjectTo10ftPolicies = require(scriptParent.isSubjectTo10ftPolicies)
}
