local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local Lumberyak = require(scriptParentParent.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local ShareLinksNetworking = require(scriptParentParent.ShareLinksNetworking)
local ShareLinksRodux = require(scriptParentParent.ShareLinksRodux)
local VirtualizedList = require(scriptParentParent.VirtualizedList)
local UrlBuilder = require(scriptParentParent.UrlBuilder)
local SocialLuaAnalytics = require(scriptParentParent.SocialLuaAnalytics)
local v11 = Lumberyak.Logger.new(nil, "ContactImporter"):new("ContactImporter Networking")
local v12 = game:DefineFastInt("ContactImporterHttpRetryCount", 3)
local v13 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 18
		-- upvalues: v11 (copy), httpRequest (copy)
		v11:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 22
		-- upvalues: v11 (copy)
		v11:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v12
})
local RODUX_KEY = require(scriptParent.Common.Constants).RODUX_KEY
local v15 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v13
})
local v16 = require(scriptParentParent.ContactsRodux).config({
	keyPath = RODUX_KEY .. ".Contacts"
})
local RoactAppExperiment = require(scriptParentParent.RoactAppExperiment)
local UIBlox = require(scriptParentParent.UIBlox)

return {
	SocialLuaAnalytics = SocialLuaAnalytics,
	Dash = require(scriptParentParent.Dash),
	UIBlox = UIBlox,
	Roact = require(scriptParentParent.Roact),
	RoactNavigation = require(scriptParentParent.RoactNavigation),
	Rodux = require(scriptParentParent.Rodux),
	ReactRoblox = require(scriptParentParent.ReactRoblox),
	RoactRodux = require(scriptParentParent.RoactRodux),
	LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider,
	withLocalization = require(scriptParentParent.Localization).withLocalization,
	Url = require(scriptParentParent.Http).Url,
	t = require(scriptParentParent.t),
	Promise = require(scriptParentParent.Promise),
	llama = LuaSocialLibrariesDeps.llama,
	memoize = require(scriptParentParent.AppCommonLib).memoize,
	RoduxNetworking = v15,
	enumerate = require(scriptParentParent.enumerate),
	IXPService = game:GetService("IXPService"),
	ShareLinksNetworking = ShareLinksNetworking.config({
		roduxNetworking = v15
	}),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialModalsCommon = require(scriptParentParent.SocialModalsCommon),
	NetworkingContacts = require(scriptParentParent.ContactsNetworking).config({
		roduxNetworking = v15
	}),
	NetworkingFriends = require(scriptParentParent.FriendsNetworking).config({
		roduxNetworking = v15
	}),
	NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = v15
	}),
	NetworkingAccountInformation = LuaSocialLibrariesDeps.NetworkingAccountInformation.config({
		roduxNetworking = v15
	}),
	NetworkingAccountSettings = LuaSocialLibrariesDeps.NetworkingAccountSettings.config({
		roduxNetworking = v15
	}),
	UrlBuilder = UrlBuilder.UrlBuilder,
	ContactsProtocol = require(scriptParentParent.ContactsProtocol).ContactsProtocol,
	SMSProtocol = require(scriptParentParent.SMSProtocol).SMSProtocol,
	PermissionsProtocol = require(scriptParentParent.PermissionsProtocol).PermissionsProtocol,
	RoduxContacts = v16,
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = RODUX_KEY .. ".UserPermissions"
	}),
	ShareLinksRodux = ShareLinksRodux.config({
		keyPath = RODUX_KEY .. ".ShareLinks"
	}),
	AppStorageService = game:GetService("AppStorageService"),
	UserInputService = game:GetService("UserInputService"),
	ThrottleUserId = require(scriptParentParent.AppCommonLib).ThrottleUserId,
	getFStringSocialFriendsLayer = require(scriptParentParent.SharedFlags).getFStringSocialFriendsLayer,
	Players = game:GetService("Players"),
	React = require(scriptParentParent.React),
	FlatList = VirtualizedList.FlatList,
	SectionList = VirtualizedList.SectionList,
	useSelector = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useSelector,
	useDispatch = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useDispatch,
	usePrevious = require(scriptParentParent.RoactUtils).Hooks.usePrevious,
	useNavigation = require(scriptParentParent.Navigation).useNavigation,
	useLocalization = require(scriptParentParent.Localization).Hooks.useLocalization,
	useStyle = UIBlox.Core.Style.useStyle,
	useUserExperiment = RoactAppExperiment.useUserExperiment,
	useEffectOnce = require(scriptParentParent.RoactUtils).Hooks.useEffectOnce,
	DiscoverabilityOverlay = require(scriptParentParent.DiscoverabilityModal).DiscoverabilityOverlay,
	DiscoverabilityAnalytics = require(scriptParentParent.DiscoverabilityModal).Analytics,
	RoactExperimentProvider = RoactAppExperiment.Provider,
	UniversalAppPolicy = require(scriptParentParent.UniversalAppPolicy).UniversalAppPolicy,
	AmpUpsell = require(scriptParentParent.AmpUpsell),
	Foundation = require(scriptParentParent.Foundation)
}
