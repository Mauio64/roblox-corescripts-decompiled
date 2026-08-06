local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local SocialLuaAnalytics = require(scriptParentParent.SocialLuaAnalytics)

require(scriptParentParent.React)

local v5 = require(scriptParentParent.Lumberyak).Logger.new(nil, "FriendsLanding")
local v6 = v5:new("FriendsLanding Networking")
local v7 = game:DefineFastInt("FriendsLandingHttpRetryCount", 3)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local Otter = require(scriptParentParent.Otter)
local getFStringSocialAddFriendsPageLayer = require(scriptParentParent.SharedFlags).getFStringSocialAddFriendsPageLayer
local getFStringSocialFriendsLandingLayer = require(scriptParentParent.SharedFlags).getFStringSocialFriendsLandingLayer
local getFStringSocialFriendsLayer = require(scriptParentParent.SharedFlags).getFStringSocialFriendsLayer
local ChallengeRequestWrapper = require(scriptParentParent.GenericChallenges).Middleware.ChallengeRequestWrapper
local v17 = game:DefineFastFlag("EnableFriendsLandingChallengeInterceptor", false)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v19 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 28
		-- upvalues: v6 (copy), httpRequest (copy)
		v6:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.RequestInternal(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 32
		-- upvalues: v6 (copy)
		v6:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v7
})
local v20 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = "FriendsLanding.NetworkStatus",
	networkImpl = if not v17 then v19 else ChallengeRequestWrapper(v19)
})
local RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence
local RoduxUsers = LuaSocialLibrariesDeps.RoduxUsers
local FFlagFriendsLandingDeprecateUnusedMapToUsers = require(scriptParent.Flags.FFlagFriendsLandingDeprecateUnusedMapToUsers)
local ContactImporter = require(scriptParentParent.ContactImporter)
local v25 = LuaSocialLibrariesDeps.SocialLibraries.config({})

return {
	Promise = require(scriptParentParent.Promise),
	llama = LuaSocialLibrariesDeps.llama,
	Roact = require(scriptParentParent.Roact),
	Rodux = require(scriptParentParent.Rodux),
	React = require(scriptParentParent.React),
	RoactNavigation = require(scriptParentParent.RoactNavigation),
	RoactRodux = require(scriptParentParent.RoactRodux),
	RoactAppExperiment = require(scriptParentParent.RoactAppExperiment),
	Logger = v5,
	Text = require(scriptParentParent.AppCommonLib).Text,
	t = require(scriptParentParent.t),
	UIBlox = require(scriptParentParent.UIBlox),
	withLocalization = require(scriptParentParent.Localization).withLocalization,
	memoize = require(scriptParentParent.AppCommonLib).memoize,
	enumerate = require(scriptParentParent.enumerate),
	LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider,
	Url = require(scriptParentParent.Http).Url,
	Lumberyak = require(scriptParentParent.Lumberyak),
	FormFactor = require(scriptParentParent.FormFactor).Enums.FormFactor,
	SocialLibraries = v25,
	SocialLuaAnalytics = SocialLuaAnalytics,
	ProfileQRCode = require(scriptParentParent.ProfileQRCode),
	SocialCommon = require(scriptParentParent.SocialCommon),
	ReactFocusNavigation = require(scriptParentParent.ReactFocusNavigation),
	FocusNavigationUtils = require(scriptParentParent.FocusNavigationUtils),
	InputHandlers = require(scriptParentParent.InputHandlers),
	BuilderIcons = require(scriptParentParent.BuilderIcons),
	Foundation = require(scriptParentParent.Foundation),
	UniversalAppPolicy = require(scriptParentParent.UniversalAppPolicy).UniversalAppPolicy,
	tutils = require(scriptParentParent.tutils),
	AnalyticsService = require(scriptParentParent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService")),
	RoduxNetworking = v20,
	RoduxFriends = require(scriptParentParent.FriendsRodux).config({
		keyPath = "FriendsLanding.Friends"
	}),
	Dash = require(scriptParentParent.Dash),
	RoduxUsers = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then RoduxUsers.config({
		keyPath = "FriendsLanding.Users"
	}) else nil,
	RoduxPresence = RoduxPresence.config({
		keyPath = "FriendsLanding.Presence"
	}),
	RoduxUserPermissions = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = "FriendsLanding.UserPermissions"
	}) else nil,
	RoduxAnalytics = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then SocialLuaAnalytics.Analytics.RoduxAnalytics.config({
		keyPath = "FriendsLanding.Analytics"
	}) else nil,
	CoreGui = CoreGui,
	Players = Players,
	LocalizationService = LocalizationService,
	TextService = TextService,
	NetworkingFriendsEnums = require(scriptParentParent.FriendsNetworking).Enums,
	FriendsNetworking = require(scriptParentParent.FriendsNetworking).config({
		roduxNetworking = v20
	}),
	GamesNetworking = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then LuaSocialLibrariesDeps.NetworkingGames.config({
		roduxNetworking = v20
	}) else nil,
	NetworkingUserSettings = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = v20
	}) else nil,
	NetworkingAccountInformation = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then LuaSocialLibrariesDeps.NetworkingAccountInformation.config({
		roduxNetworking = v20
	}) else nil,
	Otter = Otter,
	CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers,
	getFStringSocialAddFriendsPageLayer = getFStringSocialAddFriendsPageLayer,
	getFStringSocialFriendsLandingLayer = getFStringSocialFriendsLandingLayer,
	getFStringSocialFriendsLayer = getFStringSocialFriendsLayer,
	FindFriendsModal = ContactImporter.FindFriendsModal,
	ContactsList = ContactImporter.ContactsList,
	ContactsRevokedAccessDialog = ContactImporter.ContactsRevokedAccessDialog,
	updateOptedInUsers = require(scriptParentParent.SocialModalsCommon).Utils.updateOptedInUsers,
	fetchOSPermissionsForContacts = require(scriptParentParent.ContactImporter).Utils.fetchOSPermissionsForContacts,
	PermissionsProtocol = require(scriptParentParent.PermissionsProtocol).PermissionsProtocol,
	AppStorageService = game:GetService("AppStorageService"),
	ContactImporterConstants = require(scriptParentParent.ContactImporter).Constants,
	ShowContactImporterParams = ContactImporter.ShowContactImporterParams,
	FetchUserSettingsMetadata = if not FFlagFriendsLandingDeprecateUnusedMapToUsers then require(scriptParentParent.DiscoverabilityModal).FetchUserSettingsMetadata else nil,
	DiscoverabilityOverlay = require(scriptParentParent.DiscoverabilityModal).DiscoverabilityOverlay,
	DiscoverabilityAnalytics = require(scriptParentParent.DiscoverabilityModal).Analytics,
	Hooks = {
		useLocalization = require(scriptParentParent.Localization).Hooks.useLocalization
	},
	getRbxthumbWithTypeSizeAndOptions = require(scriptParentParent.UserLib).Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = require(scriptParentParent.UserLib).Utils.Constants,
	useFocusGuiObject = require(scriptParentParent.ReactFocusNavigation).useFocusGuiObject,
	AppHeaderBar = require(scriptParentParent.AppHeaderBar),
	GetFFlagFixConnectTabSearchBarHeight = require(scriptParentParent.SharedFlags).GetFFlagFixConnectTabSearchBarHeight,
	FFlagEnableLeftNavOnConsole = require(scriptParentParent.SharedFlags).FFlagEnableLeftNavOnConsole,
	GuiService = game:GetService("GuiService")
}
