local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/LuaSocialLibrariesDeps")
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Lumberyak")
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local NetworkingShareLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/NetworkingShareLinks")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ShareLinksRodux")
local VirtualizedList = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/VirtualizedList")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UrlBuilder")

local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialLuaAnalytics")
local v5 = Lumberyak.Logger.new(nil, "ContactImporter"):new("ContactImporter Networking")
local defineFastInt = game:DefineFastInt("ContactImporterHttpRetryCount", 3)

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

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/Constants").RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local config3 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ContactsRodux").config({
	keyPath = RODUX_KEY .. ".Contacts"
})

local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactAppExperiment")

local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UIBlox")

return {
	SocialLuaAnalytics = module7,
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Dash"),
	UIBlox = module9,
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Roact"),
	RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactNavigation"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Rodux"),
	ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ReactRoblox"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactRodux"),
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Localization").LocalizationProvider,
	withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Localization").withLocalization,
	Url = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Http").Url,
	t = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/t"),
	Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Promise"),
	llama = LuaSocialLibrariesDeps.llama,
	memoize = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AppCommonLib").memoize,
	RoduxNetworking = config2,
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/enumerate"),
	IXPService = game:GetService("IXPService"),
	ShareLinksNetworking = NetworkingShareLinks.config({ roduxNetworking = config2 }),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialModalsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SocialModalsCommon"),
	NetworkingContacts = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactsNetworking").config({ roduxNetworking = config2 }),
	NetworkingFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/NetworkingFriends").config({ roduxNetworking = config2 }),
	NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = config2
	}),
	NetworkingAccountInformation = LuaSocialLibrariesDeps.NetworkingAccountInformation.config({
		roduxNetworking = config2
	}),
	NetworkingAccountSettings = LuaSocialLibrariesDeps.NetworkingAccountSettings.config({
		roduxNetworking = config2
	}),
	UrlBuilder = module6.UrlBuilder,
	ContactsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/ContactsProtocol").ContactsProtocol,
	SMSProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SMSProtocol").SMSProtocol,
	PermissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/PermissionsProtocol").PermissionsProtocol,
	RoduxContacts = config3,
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = RODUX_KEY .. ".UserPermissions"
	}),
	ShareLinksRodux = module4.config({
		keyPath = RODUX_KEY .. ".ShareLinks"
	}),
	AppStorageService = game:GetService("AppStorageService"),
	UserInputService = game:GetService("UserInputService"),
	ThrottleUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AppCommonLib").ThrottleUserId,
	getFStringSocialFriendsLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").getFStringSocialFriendsLayer,
	FFlagFontFaceSocialFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/SharedFlags").FFlagFontFaceSocialFriends,
	Players = game:GetService("Players"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React"),
	FlatList = VirtualizedList.FlatList,
	SectionList = VirtualizedList.SectionList,
	useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactUtils").Hooks.RoactRodux.useSelector,
	useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactUtils").Hooks.RoactRodux.useDispatch,
	usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactUtils").Hooks.usePrevious,
	useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Navigation").useNavigation,
	useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Localization").Hooks.useLocalization,
	useStyle = module9.Core.Style.useStyle,
	useUserExperiment = RoactAppExperiment.useUserExperiment,
	useEffectOnce = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/RoactUtils").Hooks.useEffectOnce,
	DiscoverabilityOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/DiscoverabilityModal").DiscoverabilityOverlay,
	DiscoverabilityAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/DiscoverabilityModal").Analytics,
	RoactExperimentProvider = RoactAppExperiment.Provider,
	UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/UniversalAppPolicy").UniversalAppPolicy,
	AmpUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/AmpUpsell"),
	Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Foundation")
}
