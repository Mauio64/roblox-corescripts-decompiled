local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local Lumberyak = require(ParentParent.Lumberyak)
local v4 = Lumberyak.Logger.new(nil, "SocialTab")
local LocalizationService = game:GetService("LocalizationService")
local GetFFlagHideConnectPageWebViewItemsForVR = require(ParentParent.SharedFlags).GetFFlagHideConnectPageWebViewItemsForVR
local StreamNotifications = require(ParentParent.StreamNotifications)
local v8 = game:DefineFastInt("SocialTabHttpRetryCount", 3)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v10 = v4:new("SocialTab Networking")
local v11 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 20
		-- upvalues: v10 (copy), httpRequest (copy)
		v10:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 24
		-- upvalues: v10 (copy)
		v10:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v8
})
local getFFlagSocialTabReplaceRefreshConversations = require(ParentParent.SharedFlags).getFFlagSocialTabReplaceRefreshConversations
local v13 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "SocialTab.NetworkStatus",
	networkImpl = v11
})
local validatePropsWithForwardRef = require(ParentParent.RoactUtils).validatePropsWithForwardRef
local RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence
local FriendsRodux = require(ParentParent.FriendsRodux)
local RoduxGames = LuaSocialLibrariesDeps.RoduxGames
local RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers
local NetworkingGames = LuaSocialLibrariesDeps.NetworkingGames

return {
	LocalizationService = LocalizationService,
	Promise = require(ParentParent.Promise),
	llama = LuaSocialLibrariesDeps.llama,
	FitFrame = require(ParentParent.FitFrame),
	Otter = require(ParentParent.Otter),
	Roact = require(ParentParent.Roact),
	React = require(ParentParent.React),
	Rodux = require(ParentParent.Rodux),
	Cryo = require(ParentParent.Cryo),
	RetrievalStatus = require(ParentParent.Http).Enum.RetrievalStatus,
	RoactNavigation = require(ParentParent.RoactNavigation),
	RoactAppExperiment = require(ParentParent.RoactAppExperiment),
	RoactRodux = require(ParentParent.RoactRodux),
	ExternalEventConnection = require(ParentParent.RoactUtils).ExternalEventConnection,
	Logger = v4,
	t = require(ParentParent.t),
	Text = require(ParentParent.AppCommonLib).Text,
	UIBlox = require(ParentParent.UIBlox),
	withLocalization = require(ParentParent.Localization).withLocalization,
	useDispatch = require(ParentParent.RoactUtils).Hooks.RoactRodux.useDispatch,
	useLocalization = require(ParentParent.Localization).Hooks.useLocalization,
	useSelector = require(ParentParent.RoactUtils).Hooks.RoactRodux.useSelector,
	memoize = require(ParentParent.AppCommonLib).memoize,
	PromiseUtilities = require(ParentParent.AppCommonLib).Utils.PromiseUtilities,
	enumerate = require(ParentParent.enumerate),
	LocalizationProvider = require(ParentParent.Localization).LocalizationProvider,
	Url = require(ParentParent.Http).Url,
	VerifiedBadges = require(ParentParent.VerifiedBadges),
	DiscoverabilityModal = require(ParentParent.DiscoverabilityModal),
	ShowContactImporterParams = require(ParentParent.ContactImporter).ShowContactImporterParams,
	SocialCommon = require(ParentParent.SocialCommon),
	UniversalAppPolicy = require(ParentParent.UniversalAppPolicy).UniversalAppPolicy,
	UiModeStyleProvider = require(ParentParent.Style).UiModeStyleProvider,
	Mock = LuaSocialLibrariesDeps.Mock,
	tutils = require(ParentParent.tutils),
	AnalyticsService = require(ParentParent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService")),
	NetworkingPresence = LuaSocialLibrariesDeps.NetworkingPresence.config({
		roduxNetworking = v13
	}),
	NetworkingFriends = require(ParentParent.FriendsNetworking).config({
		roduxNetworking = v13
	}),
	NetworkingUsers = LuaSocialLibrariesDeps.NetworkingUsers.config({
		roduxNetworking = v13
	}),
	NetworkingGames = NetworkingGames.config({
		roduxNetworking = v13
	}) or nil,
	Players = game:GetService("Players"),
	RoduxNetworking = v13,
	RoduxUsers = RoduxUsers.config({
		keyPath = "SocialTab.Users"
	}),
	RoduxFriends = FriendsRodux.config({
		keyPath = "SocialTab.Friends"
	}),
	RoduxPresence = RoduxPresence.config({
		keyPath = "SocialTab.Presence"
	}),
	RoduxGames = RoduxGames.config({
		keyPath = "SocialTab.Games"
	}),
	NetworkingChat = getFFlagSocialTabReplaceRefreshConversations() and LuaSocialLibrariesDeps.NetworkingChat.config({
		roduxNetworking = v13
	}) or nil,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	Lumberyak = Lumberyak,
	RunService = game:GetService("RunService"),
	validatePropsWithForwardRef = validatePropsWithForwardRef,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	GetFFlagHideConnectPageWebViewItemsForVR = GetFFlagHideConnectPageWebViewItemsForVR,
	UserLib = require(ParentParent.UserLib),
	getStandardSizeAvatarHeadShotRbxthumb = require(ParentParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb,
	StreamNotifications = StreamNotifications,
	AppPage = require(ParentParent.RobloxAppEnums).AppPage,
	BuilderIcons = require(ParentParent.BuilderIcons),
	Foundation = require(ParentParent.Foundation)
}
