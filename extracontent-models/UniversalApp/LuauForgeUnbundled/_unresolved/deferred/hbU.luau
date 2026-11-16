local module = require("@luauforge/deferred/hbV")

local module2 = require("@luauforge/deferred/hbW")
local logger = module2.Logger.new(nil, "SocialTab")

local LocalizationService = game:GetService("LocalizationService")

local getFFlagHideConnectPageWebViewItemsForVR = require("@luauforge/deferred/hbX").GetFFlagHideConnectPageWebViewItemsForVR

local module3 = require("@luauforge/deferred/hbY")

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

local getFFlagSocialTabReplaceRefreshConversations = require("@luauforge/deferred/hbX").getFFlagSocialTabReplaceRefreshConversations

local config2 = module.RoduxNetworking.config({
	keyPath = "SocialTab.NetworkStatus",
	networkImpl = config
})

local validatePropsWithForwardRef = require("@luauforge/deferred/hbZ").validatePropsWithForwardRef

local roduxPresence = module.RoduxPresence

local module4 = require("@luauforge/deferred/hca")
local roduxGames = module.RoduxGames
local roduxUsers = module.RoduxUsers
local networkingGames = module.NetworkingGames

local v6 = {
	LocalizationService = LocalizationService,
	Promise = require("@luauforge/deferred/hcb"),
	llama = module.llama,
	FitFrame = require("@luauforge/deferred/hcc"),
	Otter = require("@luauforge/deferred/hcd"),
	Roact = require("@luauforge/deferred/hce"),
	React = require("@luauforge/deferred/hcf"),
	Rodux = require("@luauforge/deferred/hcg"),
	Cryo = require("@luauforge/deferred/hch"),
	RetrievalStatus = require("@luauforge/deferred/hci").Enum.RetrievalStatus,
	RoactNavigation = require("@luauforge/deferred/hcj"),
	RoactAppExperiment = require("@luauforge/deferred/hck"),
	RoactRodux = require("@luauforge/deferred/hcl"),
	ExternalEventConnection = require("@luauforge/deferred/hbZ").ExternalEventConnection,
	Logger = logger,
	t = require("@luauforge/deferred/hcm"),
	Text = require("@luauforge/deferred/hcn").Text,
	UIBlox = require("@luauforge/deferred/hco"),
	withLocalization = require("@luauforge/deferred/hcp").withLocalization,
	useDispatch = require("@luauforge/deferred/hbZ").Hooks.RoactRodux.useDispatch,
	useLocalization = require("@luauforge/deferred/hcp").Hooks.useLocalization,
	useSelector = require("@luauforge/deferred/hbZ").Hooks.RoactRodux.useSelector,
	memoize = require("@luauforge/deferred/hcn").memoize,
	PromiseUtilities = require("@luauforge/deferred/hcn").Utils.PromiseUtilities,
	enumerate = require("@luauforge/deferred/hcq"),
	LocalizationProvider = require("@luauforge/deferred/hcp").LocalizationProvider,
	Url = require("@luauforge/deferred/hci").Url,
	VerifiedBadges = require("@luauforge/deferred/hcr"),
	DiscoverabilityModal = require("@luauforge/deferred/hcs"),
	ShowContactImporterParams = require("@luauforge/deferred/hct").ShowContactImporterParams,
	SocialCommon = require("@luauforge/deferred/hcu"),
	UniversalAppPolicy = require("@luauforge/deferred/hcv").UniversalAppPolicy,
	UiModeStyleProvider = require("@luauforge/deferred/hcw").UiModeStyleProvider,
	Mock = module.Mock,
	tutils = require("@luauforge/deferred/hcx"),
	AnalyticsService = require("@luauforge/deferred/hcy").Analytics.new(game:GetService("RbxAnalyticsService")),
	NetworkingPresence = module.NetworkingPresence.config({ roduxNetworking = config2 }),
	NetworkingFriends = require("@luauforge/deferred/hcz").config({ roduxNetworking = config2 }),
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

v6.UserLib = require("@luauforge/deferred/hcA")
v6.getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/deferred/hcA").Utils.getStandardSizeAvatarHeadShotRbxthumb

v6.StreamNotifications = module3

v6.AppPage = require("@luauforge/deferred/hcB").AppPage

v6.BuilderIcons = require("@luauforge/deferred/hcC")
v6.Foundation = require("@luauforge/deferred/hcD")
return v6
