local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local PYMKCarouselParent = PYMKCarousel.Parent
local LuaSocialLibrariesDeps = require(PYMKCarouselParent.LuaSocialLibrariesDeps)
local SocialLuaAnalytics = require(PYMKCarouselParent.SocialLuaAnalytics)
local Lumberyak = require(PYMKCarouselParent.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v7 = game:DefineFastFlag("MigratePymkCarouselHttpRequestToRequestInternal", false)
local ChallengeRequestWrapper = require(PYMKCarouselParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v9 = game:DefineFastFlag("EnablePymkCarouselChallengeInterceptor", false)
local FFlagHomepagePYMKPresence = require(PYMKCarouselParent.SharedFlags).FFlagHomepagePYMKPresence
local v11 = Lumberyak.Logger.new(nil, "PYMKCarousel"):new("PYMKCarousel Networking")
local v12 = game:DefineFastInt("PYMKCarouselHttpRetryCount", 3)
local v13 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 20
		-- upvalues: v11 (copy), v7 (copy), httpRequest (copy)
		v11:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		if v7 then
			return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
		end

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 27
		-- upvalues: v11 (copy)
		v11:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v12
})
local RODUX_KEY = require(PYMKCarousel.Common.Constants).RODUX_KEY
local v15 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = if not v9 then v13 else ChallengeRequestWrapper(v13)
})

return {
	SocialLuaAnalytics = SocialLuaAnalytics,
	UIBlox = require(PYMKCarouselParent.UIBlox),
	Roact = require(PYMKCarouselParent.Roact),
	React = require(PYMKCarouselParent.React),
	Rodux = require(PYMKCarouselParent.Rodux),
	RoactRodux = require(PYMKCarouselParent.RoactRodux),
	Result = require(PYMKCarouselParent.Result),
	llama = LuaSocialLibrariesDeps.llama,
	Dash = require(PYMKCarouselParent.Dash),
	RoduxNetworking = v15,
	RoduxFriends = require(PYMKCarouselParent.FriendsRodux).config({
		keyPath = RODUX_KEY .. ".Friends"
	}),
	RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers.config({
		keyPath = RODUX_KEY .. ".Users"
	}),
	NetworkingFriendsEnums = require(PYMKCarouselParent.FriendsNetworking).Enums,
	NetworkingFriends = require(PYMKCarouselParent.FriendsNetworking).config({
		roduxNetworking = v15
	}),
	RoduxAnalytics = SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
		keyPath = RODUX_KEY .. ".Analytics"
	}),
	Players = game:GetService("Players"),
	convertActions = require(PYMKCarouselParent.SocialReducerAdaptors).convertActions,
	usersActionAdaptor = require(PYMKCarouselParent.SocialReducerAdaptors).usersActionAdaptor,
	friendsActionAdaptor = require(PYMKCarouselParent.SocialReducerAdaptors).friendsActionAdaptor,
	SocialCommon = require(PYMKCarouselParent.SocialCommon),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	Hooks = {
		useSelector = require(PYMKCarouselParent.RoactUtils).Hooks.RoactRodux.useSelector,
		useDispatch = require(PYMKCarouselParent.RoactUtils).Hooks.RoactRodux.useDispatch,
		useLocalization = require(PYMKCarouselParent.Localization).Hooks.useLocalization,
		dependencyArray = require(PYMKCarouselParent.RoactUtils).Hooks.dependencyArray
	},
	LocalizationProvider = require(PYMKCarouselParent.Localization).LocalizationProvider,
	enumerate = require(PYMKCarouselParent.enumerate),
	getFFlagPYMKAddFriendsEntry = require(PYMKCarouselParent.SharedFlags).getFFlagPYMKAddFriendsEntry,
	NetworkingPresence = if not FFlagHomepagePYMKPresence then nil else LuaSocialLibrariesDeps.NetworkingPresence.config({
		roduxNetworking = v15
	})
}
