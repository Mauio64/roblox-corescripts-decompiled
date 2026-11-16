local parent = script.Parent
local parent2 = parent.Parent

local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)
local Lumberyak = require(parent2.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local ShareLinksNetworking = require(parent2.ShareLinksNetworking)
local ShareLinksRodux = require(parent2.ShareLinksRodux)
local VirtualizedList = require(parent2.VirtualizedList)
local UrlBuilder = require(parent2.UrlBuilder)

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local v = Lumberyak.Logger.new(nil, "ContactImporter"):new("ContactImporter Networking")
local defineFastInt = game:DefineFastInt("ContactImporterHttpRetryCount", 3)

local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return httpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	postRequestFunction = function(p, p2)
		v:debug(
			"Returned: {}",
			string.format(
				"[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]",
				p2.requestMethod,
				p2.url,
				p.StatusCode,
				p.Body
			)
		)
	end,
	maxRetryCount = defineFastInt
})

local Constants = require(parent.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local ContactsRodux = require(parent2.ContactsRodux)
local config3 = ContactsRodux.config({
	keyPath = RODUX_KEY .. ".Contacts"
})

local RoactAppExperiment = require(parent2.RoactAppExperiment)

local UIBlox = require(parent2.UIBlox)

local Dependencies = {}
Dependencies.SocialLuaAnalytics = SocialLuaAnalytics
Dependencies.Dash = require(parent2.Dash)
Dependencies.UIBlox = UIBlox
Dependencies.Roact = require(parent2.Roact)
Dependencies.RoactNavigation = require(parent2.RoactNavigation)
Dependencies.Rodux = require(parent2.Rodux)
Dependencies.ReactRoblox = require(parent2.ReactRoblox)
Dependencies.RoactRodux = require(parent2.RoactRodux)
local Localization = require(parent2.Localization)
Dependencies.LocalizationProvider = Localization.LocalizationProvider
local Localization2 = require(parent2.Localization)
Dependencies.withLocalization = Localization2.withLocalization
local Http = require(parent2.Http)
Dependencies.Url = Http.Url
Dependencies.t = require(parent2.t)
Dependencies.Promise = require(parent2.Promise)
Dependencies.llama = LuaSocialLibrariesDeps.llama
local AppCommonLib = require(parent2.AppCommonLib)
Dependencies.memoize = AppCommonLib.memoize
Dependencies.RoduxNetworking = config2
Dependencies.enumerate = require(parent2.enumerate)
Dependencies.IXPService = game:GetService("IXPService")

Dependencies.ShareLinksNetworking = ShareLinksNetworking.config({ roduxNetworking = config2 })

Dependencies.SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({})
Dependencies.SocialModalsCommon = require(parent2.SocialModalsCommon)
local ContactsNetworking = require(parent2.ContactsNetworking)
Dependencies.NetworkingContacts = ContactsNetworking.config({ roduxNetworking = config2 })

local FriendsNetworking = require(parent2.FriendsNetworking)
Dependencies.NetworkingFriends = FriendsNetworking.config({ roduxNetworking = config2 })

Dependencies.NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
	roduxNetworking = config2
})

Dependencies.NetworkingAccountInformation = LuaSocialLibrariesDeps.NetworkingAccountInformation.config({
	roduxNetworking = config2
})

Dependencies.NetworkingAccountSettings = LuaSocialLibrariesDeps.NetworkingAccountSettings.config({
	roduxNetworking = config2
})

Dependencies.UrlBuilder = UrlBuilder.UrlBuilder

local ContactsProtocol = require(parent2.ContactsProtocol)
Dependencies.ContactsProtocol = ContactsProtocol.ContactsProtocol
local SMSProtocol = require(parent2.SMSProtocol)
Dependencies.SMSProtocol = SMSProtocol.SMSProtocol

local PermissionsProtocol = require(parent2.PermissionsProtocol)
Dependencies.PermissionsProtocol = PermissionsProtocol.PermissionsProtocol
Dependencies.RoduxContacts = config3
Dependencies.RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
	keyPath = RODUX_KEY .. ".UserPermissions"
})

Dependencies.ShareLinksRodux = ShareLinksRodux.config({
	keyPath = RODUX_KEY .. ".ShareLinks"
})

Dependencies.AppStorageService = game:GetService("AppStorageService")
Dependencies.UserInputService = game:GetService("UserInputService")
local AppCommonLib2 = require(parent2.AppCommonLib)
Dependencies.ThrottleUserId = AppCommonLib2.ThrottleUserId
local SharedFlags = require(parent2.SharedFlags)
Dependencies.getFStringSocialFriendsLayer = SharedFlags.getFStringSocialFriendsLayer
local SharedFlags2 = require(parent2.SharedFlags)
Dependencies.FFlagFontFaceSocialFriends = SharedFlags2.FFlagFontFaceSocialFriends
Dependencies.Players = game:GetService("Players")
Dependencies.React = require(parent2.React)
Dependencies.FlatList = VirtualizedList.FlatList
Dependencies.SectionList = VirtualizedList.SectionList
local RoactUtils = require(parent2.RoactUtils)
Dependencies.useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent2.RoactUtils)
Dependencies.useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local RoactUtils3 = require(parent2.RoactUtils)
Dependencies.usePrevious = RoactUtils3.Hooks.usePrevious
local Navigation = require(parent2.Navigation)
Dependencies.useNavigation = Navigation.useNavigation
local Localization3 = require(parent2.Localization)
Dependencies.useLocalization = Localization3.Hooks.useLocalization
Dependencies.useStyle = UIBlox.Core.Style.useStyle
Dependencies.useUserExperiment = RoactAppExperiment.useUserExperiment
local RoactUtils4 = require(parent2.RoactUtils)
Dependencies.useEffectOnce = RoactUtils4.Hooks.useEffectOnce
local DiscoverabilityModal = require(parent2.DiscoverabilityModal)
Dependencies.DiscoverabilityOverlay = DiscoverabilityModal.DiscoverabilityOverlay
local DiscoverabilityModal2 = require(parent2.DiscoverabilityModal)
Dependencies.DiscoverabilityAnalytics = DiscoverabilityModal2.Analytics
Dependencies.RoactExperimentProvider = RoactAppExperiment.Provider
local UniversalAppPolicy = require(parent2.UniversalAppPolicy)
Dependencies.UniversalAppPolicy = UniversalAppPolicy.UniversalAppPolicy

Dependencies.AmpUpsell = require(parent2.AmpUpsell)
Dependencies.Foundation = require(parent2.Foundation)
return Dependencies
