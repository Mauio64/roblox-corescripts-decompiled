local ParentParent = script.Parent.Parent
local LuaSocialLibrariesDeps = require(ParentParent.LuaSocialLibrariesDeps)
local SocialLuaAnalytics = require(ParentParent.SocialLuaAnalytics)

require(ParentParent.React)

local v4 = require(ParentParent.Lumberyak).Logger.new(nil, "FriendsLanding")
local v5 = v4:new("FriendsLanding Networking")
local v6 = game:DefineFastInt("FriendsLandingHttpRetryCount", 3)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local Otter = require(ParentParent.Otter)
local getFStringSocialAddFriendsPageLayer = require(ParentParent.SharedFlags).getFStringSocialAddFriendsPageLayer
local getFStringSocialFriendsLandingLayer = require(ParentParent.SharedFlags).getFStringSocialFriendsLandingLayer
local getFStringSocialFriendsLayer = require(ParentParent.SharedFlags).getFStringSocialFriendsLayer
local ChallengeRequestWrapper = require(ParentParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v16 = game:DefineFastFlag("EnableFriendsLandingChallengeInterceptor", false)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v18 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 28
		-- upvalues: v5 (copy), httpRequest (copy)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 32
		-- upvalues: v5 (copy)
		v5:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v6
})
local v19 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "FriendsLanding.NetworkStatus",
	networkImpl = if not v16 then v18 else ChallengeRequestWrapper(v18)
})
local RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence
local RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers
local ContactImporter = require(ParentParent.ContactImporter)
local v23 = LuaSocialLibrariesDeps.SocialLibraries.config({})

return {
	Promise = require(ParentParent.Promise),
	llama = LuaSocialLibrariesDeps.llama,
	Roact = require(ParentParent.Roact),
	Rodux = require(ParentParent.Rodux),
	React = require(ParentParent.React),
	RoactNavigation = require(ParentParent.RoactNavigation),
	RoactRodux = require(ParentParent.RoactRodux),
	RoactAppExperiment = require(ParentParent.RoactAppExperiment),
	Logger = v4,
	Text = require(ParentParent.AppCommonLib).Text,
	t = require(ParentParent.t),
	UIBlox = require(ParentParent.UIBlox),
	withLocalization = require(ParentParent.Localization).withLocalization,
	memoize = require(ParentParent.AppCommonLib).memoize,
	enumerate = require(ParentParent.enumerate),
	LocalizationProvider = require(ParentParent.Localization).LocalizationProvider,
	Url = require(ParentParent.Http).Url,
	Lumberyak = require(ParentParent.Lumberyak),
	FormFactor = require(ParentParent.FormFactor).Enums.FormFactor,
	SocialLibraries = v23,
	SocialLuaAnalytics = SocialLuaAnalytics,
	ProfileQRCode = require(ParentParent.ProfileQRCode),
	SocialCommon = require(ParentParent.SocialCommon),
	ReactFocusNavigation = require(ParentParent.ReactFocusNavigation),
	FocusNavigationUtils = require(ParentParent.FocusNavigationUtils),
	InputHandlers = require(ParentParent.InputHandlers),
	BuilderIcons = require(ParentParent.BuilderIcons),
	Foundation = require(ParentParent.Foundation),
	UniversalAppPolicy = require(ParentParent.UniversalAppPolicy).UniversalAppPolicy,
	tutils = require(ParentParent.tutils),
	AnalyticsService = require(ParentParent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService")),
	RoduxNetworking = v19,
	RoduxFriends = require(ParentParent.FriendsRodux).config({
		keyPath = "FriendsLanding.Friends"
	}),
	Dash = require(ParentParent.Dash),
	RoduxUsers = RoduxUsers.config({
		keyPath = "FriendsLanding.Users"
	}),
	RoduxPresence = RoduxPresence.config({
		keyPath = "FriendsLanding.Presence"
	}),
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = "FriendsLanding.UserPermissions"
	}),
	RoduxAnalytics = SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
		keyPath = "FriendsLanding.Analytics"
	}),
	CoreGui = CoreGui,
	Players = Players,
	LocalizationService = LocalizationService,
	TextService = TextService,
	NetworkingFriendsEnums = require(ParentParent.FriendsNetworking).Enums,
	FriendsNetworking = require(ParentParent.FriendsNetworking).config({
		roduxNetworking = v19
	}),
	GamesNetworking = LuaSocialLibrariesDeps.NetworkingGames.config({
		roduxNetworking = v19
	}),
	NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = v19
	}),
	NetworkingAccountInformation = LuaSocialLibrariesDeps.NetworkingAccountInformation.config({
		roduxNetworking = v19
	}),
	Otter = Otter,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	getFStringSocialAddFriendsPageLayer = getFStringSocialAddFriendsPageLayer,
	getFStringSocialFriendsLandingLayer = getFStringSocialFriendsLandingLayer,
	getFStringSocialFriendsLayer = getFStringSocialFriendsLayer,
	FindFriendsModal = ContactImporter.FindFriendsModal,
	ContactsList = ContactImporter.ContactsList,
	ContactsRevokedAccessDialog = ContactImporter.ContactsRevokedAccessDialog,
	updateOptedInUsers = require(ParentParent.SocialModalsCommon).Utils.updateOptedInUsers,
	fetchOSPermissionsForContacts = require(ParentParent.ContactImporter).Utils.fetchOSPermissionsForContacts,
	PermissionsProtocol = require(ParentParent.PermissionsProtocol).PermissionsProtocol,
	AppStorageService = game:GetService("AppStorageService"),
	ContactImporterConstants = require(ParentParent.ContactImporter).Constants,
	ShowContactImporterParams = ContactImporter.ShowContactImporterParams,
	FetchUserSettingsMetadata = require(ParentParent.DiscoverabilityModal).FetchUserSettingsMetadata,
	DiscoverabilityOverlay = require(ParentParent.DiscoverabilityModal).DiscoverabilityOverlay,
	DiscoverabilityAnalytics = require(ParentParent.DiscoverabilityModal).Analytics,
	Hooks = {
		useLocalization = require(ParentParent.Localization).Hooks.useLocalization
	},
	getRbxthumbWithTypeSizeAndOptions = require(ParentParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = require(ParentParent.UserLib).Utils.Constants,
	useFocusGuiObject = require(ParentParent.ReactFocusNavigation).useFocusGuiObject,
	AppHeaderBar = require(ParentParent.AppHeaderBar),
	GetFFlagFixConnectTabSearchBarHeight = require(ParentParent.SharedFlags).GetFFlagFixConnectTabSearchBarHeight,
	FFlagEnableLeftNavOnConsole = require(ParentParent.SharedFlags).FFlagEnableLeftNavOnConsole,
	GuiService = game:GetService("GuiService")
}
