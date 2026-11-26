local module = require("@luauforge/deferred/hmE")

local module2 = require("@luauforge/deferred/hmF")
local logger = module2.Logger.new(nil, "SocialTab")

local LocalizationService = game:GetService("LocalizationService")

local getFFlagHideConnectPageWebViewItemsForVR = require("@luauforge/deferred/hmG").GetFFlagHideConnectPageWebViewItemsForVR

local module3 = require("@luauforge/deferred/hmH")

local defineFastInt = game:DefineFastInt("SocialTabHttpRetryCount", 3)

local httpRequest = module.httpRequest
local v5 = logger:new("SocialTab Networking")
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

local getFFlagSocialTabReplaceRefreshConversations = require("@luauforge/deferred/hmG").getFFlagSocialTabReplaceRefreshConversations

local config2 = module.RoduxNetworking.config({
	keyPath = "SocialTab.NetworkStatus",
	networkImpl = config
})

local validatePropsWithForwardRef = require("@luauforge/deferred/hmI").validatePropsWithForwardRef

local roduxPresence = module.RoduxPresence

local module4 = require("@luauforge/deferred/hmJ")
local roduxGames = module.RoduxGames
local roduxUsers = module.RoduxUsers
local networkingGames = module.NetworkingGames

local v6 = {
	LocalizationService = LocalizationService,
	Promise = require("@luauforge/deferred/hmK"),
	llama = module.llama,
	FitFrame = require("@luauforge/deferred/hmL"),
	Otter = require("@luauforge/deferred/hmM"),
	Roact = require("@luauforge/deferred/hmN"),
	React = require("@luauforge/deferred/hmO"),
	Rodux = require("@luauforge/deferred/hmP"),
	Cryo = require("@luauforge/deferred/hmQ"),
	RetrievalStatus = require("@luauforge/deferred/hmR").Enum.RetrievalStatus,
	RoactNavigation = require("@luauforge/deferred/hmS"),
	RoactAppExperiment = require("@luauforge/deferred/hmT"),
	RoactRodux = require("@luauforge/deferred/hmU"),
	ExternalEventConnection = require("@luauforge/deferred/hmI").ExternalEventConnection,
	Logger = logger,
	t = require("@luauforge/deferred/hmV"),
	Text = require("@luauforge/deferred/hmW").Text,
	UIBlox = require("@luauforge/deferred/hmX"),
	withLocalization = require("@luauforge/deferred/hmY").withLocalization,
	useDispatch = require("@luauforge/deferred/hmI").Hooks.RoactRodux.useDispatch,
	useLocalization = require("@luauforge/deferred/hmY").Hooks.useLocalization,
	useSelector = require("@luauforge/deferred/hmI").Hooks.RoactRodux.useSelector,
	memoize = require("@luauforge/deferred/hmW").memoize,
	PromiseUtilities = require("@luauforge/deferred/hmW").Utils.PromiseUtilities,
	enumerate = require("@luauforge/deferred/hmZ"),
	LocalizationProvider = require("@luauforge/deferred/hmY").LocalizationProvider,
	Url = require("@luauforge/deferred/hmR").Url,
	VerifiedBadges = require("@luauforge/deferred/hna"),
	DiscoverabilityModal = require("@luauforge/deferred/hnb"),
	ShowContactImporterParams = require("@luauforge/deferred/hnc").ShowContactImporterParams,
	SocialCommon = require("@luauforge/deferred/hnd"),
	UniversalAppPolicy = require("@luauforge/deferred/hne").UniversalAppPolicy,
	UiModeStyleProvider = require("@luauforge/deferred/hnf").UiModeStyleProvider,
	Mock = module.Mock,
	tutils = require("@luauforge/deferred/hng"),
	AnalyticsService = require("@luauforge/deferred/hnh").Analytics.new(game:GetService("RbxAnalyticsService")),
	NetworkingPresence = module.NetworkingPresence.config({ roduxNetworking = config2 }),
	NetworkingFriends = require("@luauforge/deferred/hni").config({ roduxNetworking = config2 }),
	NetworkingUsers = module.NetworkingUsers.config({ roduxNetworking = config2 }),
	NetworkingGames = networkingGames.config({ roduxNetworking = config2 }) or nil,
	Players = game:GetService("Players"),
	RoduxNetworking = config2,
	RoduxUsers = roduxUsers.config({ keyPath = "SocialTab.Users" }),
	RoduxFriends = module4.config({ keyPath = "SocialTab.Friends" }),
	RoduxPresence = roduxPresence.config({ keyPath = "SocialTab.Presence" }),
	RoduxGames = roduxGames.config({ keyPath = "SocialTab.Games" })
}

local v7 = if getFFlagSocialTabReplaceRefreshConversations() then module.NetworkingChat.config({
	roduxNetworking = config2
}) or nil else nil
v6.NetworkingChat = v7

v6.CollisionMatchers = module.CollisionMatchers
v6.Lumberyak = module2
v6.RunService = game:GetService("RunService")

v6.validatePropsWithForwardRef = validatePropsWithForwardRef

v6.SocialLibraries = module.SocialLibraries.config({})
v6.GetFFlagHideConnectPageWebViewItemsForVR = getFFlagHideConnectPageWebViewItemsForVR

v6.UserLib = require("@luauforge/deferred/hnj")
v6.getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/deferred/hnj").Utils.getStandardSizeAvatarHeadShotRbxthumb

v6.StreamNotifications = module3

v6.AppPage = require("@luauforge/deferred/hnk").AppPage

v6.BuilderIcons = require("@luauforge/deferred/hnl")
v6.Foundation = require("@luauforge/deferred/hnm")
return v6
