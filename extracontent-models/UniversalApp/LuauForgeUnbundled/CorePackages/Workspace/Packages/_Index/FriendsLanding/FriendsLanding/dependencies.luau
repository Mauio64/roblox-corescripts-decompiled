local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/LuaSocialLibrariesDeps")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialLuaAnalytics")

require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Lumberyak").Logger.new(nil, "FriendsLanding")
local v5 = logger:new("FriendsLanding Networking")
local defineFastInt = game:DefineFastInt("FriendsLandingHttpRetryCount", 3)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Otter")
local getFStringSocialAddFriendsPageLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").getFStringSocialAddFriendsPageLayer
local getFStringSocialFriendsLandingLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").getFStringSocialFriendsLandingLayer
local getFStringSocialFriendsLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").getFStringSocialFriendsLayer
local challengeRequestWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/GenericChallenges").Middleware.ChallengeRequestWrapper

local defineFastFlag = game:DefineFastFlag("EnableFriendsLandingChallengeInterceptor", false)

local httpRequest = LuaSocialLibrariesDeps.httpRequest
local config = httpRequest.config({
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return httpRequest.requestFunctions.RequestInternal(p2, p3, p4)
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

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config

if defineFastFlag then
	config = challengeRequestWrapper(config)
end

local v7 = config2({ keyPath = "FriendsLanding.NetworkStatus", networkImpl = config })

local roduxPresence = LuaSocialLibrariesDeps.RoduxPresence

local ContactImporter = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ContactImporter")

local config3 = LuaSocialLibrariesDeps.SocialLibraries.config({})

return {
	Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Promise"),
	llama = LuaSocialLibrariesDeps.llama,
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Roact"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Rodux"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/React"),
	RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactNavigation"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactRodux"),
	RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RoactAppExperiment"),
	Logger = logger,
	Text = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AppCommonLib").Text,
	t = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/t"),
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UIBlox"),
	withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").withLocalization,
	memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AppCommonLib").memoize,
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/enumerate"),
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").LocalizationProvider,
	Url = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Http").Url,
	Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Lumberyak"),
	FormFactor = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FormFactor").Enums.FormFactor,
	SocialLibraries = config3,
	SocialLuaAnalytics = module2,
	ProfileQRCode = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/ProfileQRCode"),
	SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialCommon"),
	ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ReactFocusNavigation"),
	FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FocusNavigationUtils"),
	InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/InputHandlers"),
	BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/BuilderIcons"),
	Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Foundation"),
	UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UniversalAppPolicy").UniversalAppPolicy,
	tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/tutils"),
	AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Analytics").Analytics.new(game:GetService("RbxAnalyticsService")),
	RoduxNetworking = v7,
	RoduxFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/FriendsRodux").config({ keyPath = "FriendsLanding.Friends" }),
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Dash"),
	RoduxPresence = roduxPresence.config({ keyPath = "FriendsLanding.Presence" }),
	CoreGui = CoreGui,
	Players = Players,
	LocalizationService = LocalizationService,
	TextService = TextService,
	NetworkingFriendsEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/NetworkingFriends").Enums,
	FriendsNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/NetworkingFriends").config({ roduxNetworking = v7 }),
	Otter = module3,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	getFStringSocialAddFriendsPageLayer = getFStringSocialAddFriendsPageLayer,
	getFStringSocialFriendsLandingLayer = getFStringSocialFriendsLandingLayer,
	getFStringSocialFriendsLayer = getFStringSocialFriendsLayer,
	FindFriendsModal = ContactImporter.FindFriendsModal,
	ContactsList = ContactImporter.ContactsList,
	ContactsRevokedAccessDialog = ContactImporter.ContactsRevokedAccessDialog,
	updateOptedInUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SocialModalsCommon").Utils.updateOptedInUsers,
	fetchOSPermissionsForContacts = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ContactImporter").Utils.fetchOSPermissionsForContacts,
	PermissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/PermissionsProtocol").PermissionsProtocol,
	AppStorageService = game:GetService("AppStorageService"),
	ContactImporterConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ContactImporter").Constants,
	ShowContactImporterParams = ContactImporter.ShowContactImporterParams,
	DiscoverabilityOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/DiscoverabilityModal").DiscoverabilityOverlay,
	DiscoverabilityAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/DiscoverabilityModal").Analytics,
	Hooks = { useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/Localization").Hooks.useLocalization },
	getRbxthumbWithTypeSizeAndOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserLib").Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/UserLib").Utils.Constants,
	useFocusGuiObject = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/ReactFocusNavigation").useFocusGuiObject,
	AppHeaderBar = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/AppHeaderBar"),
	GetFFlagFixConnectTabSearchBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/SharedFlags").GetFFlagFixConnectTabSearchBarHeight
}
