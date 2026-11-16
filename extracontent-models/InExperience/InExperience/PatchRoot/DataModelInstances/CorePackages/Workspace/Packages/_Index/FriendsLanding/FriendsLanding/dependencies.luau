local parent = script.Parent.Parent

local LuaSocialLibrariesDeps = require(parent.LuaSocialLibrariesDeps)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

require(parent.React)

local Lumberyak = require(parent.Lumberyak)
local logger = Lumberyak.Logger.new(nil, "FriendsLanding")
local v = logger:new("FriendsLanding Networking")
local defineFastInt = game:DefineFastInt("FriendsLandingHttpRetryCount", 3)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalizationService = game:GetService("LocalizationService")
local TextService = game:GetService("TextService")
local Otter = require(parent.Otter)
local SharedFlags = require(parent.SharedFlags)
local getFStringSocialAddFriendsPageLayer = SharedFlags.getFStringSocialAddFriendsPageLayer
local SharedFlags2 = require(parent.SharedFlags)
local getFStringSocialFriendsLandingLayer = SharedFlags2.getFStringSocialFriendsLandingLayer
local SharedFlags3 = require(parent.SharedFlags)
local getFStringSocialFriendsLayer = SharedFlags3.getFStringSocialFriendsLayer
local GenericChallenges = require(parent.GenericChallenges)
local ChallengeRequestWrapper = GenericChallenges.Middleware.ChallengeRequestWrapper

local defineFastFlag = game:DefineFastFlag("EnableFriendsLandingChallengeInterceptor", false)

local httpRequest = LuaSocialLibrariesDeps.httpRequest
local config = httpRequest.config({
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return httpRequest.requestFunctions.RequestInternal(p, p2, p3)
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

local config2 = LuaSocialLibrariesDeps.RoduxNetworking.config

if defineFastFlag then
	config = ChallengeRequestWrapper(config)
end

local roduxNetworking = config2({ keyPath = "FriendsLanding.NetworkStatus", networkImpl = config })

local RoduxPresence = LuaSocialLibrariesDeps.RoduxPresence

local ContactImporter = require(parent.ContactImporter)

local config3 = LuaSocialLibrariesDeps.SocialLibraries.config({})

local Dependencies = {}
Dependencies.Promise = require(parent.Promise)
Dependencies.llama = LuaSocialLibrariesDeps.llama
Dependencies.Roact = require(parent.Roact)
Dependencies.Rodux = require(parent.Rodux)
Dependencies.React = require(parent.React)
Dependencies.RoactNavigation = require(parent.RoactNavigation)
Dependencies.RoactRodux = require(parent.RoactRodux)
Dependencies.RoactAppExperiment = require(parent.RoactAppExperiment)
Dependencies.Logger = logger
local AppCommonLib = require(parent.AppCommonLib)
Dependencies.Text = AppCommonLib.Text
Dependencies.t = require(parent.t)
Dependencies.UIBlox = require(parent.UIBlox)
local Localization = require(parent.Localization)
Dependencies.withLocalization = Localization.withLocalization
local AppCommonLib2 = require(parent.AppCommonLib)
Dependencies.memoize = AppCommonLib2.memoize
Dependencies.enumerate = require(parent.enumerate)
local Localization2 = require(parent.Localization)
Dependencies.LocalizationProvider = Localization2.LocalizationProvider
local Http = require(parent.Http)
Dependencies.Url = Http.Url
Dependencies.Lumberyak = require(parent.Lumberyak)
local FormFactor = require(parent.FormFactor)
Dependencies.FormFactor = FormFactor.Enums.FormFactor
Dependencies.SocialLibraries = config3
Dependencies.SocialLuaAnalytics = SocialLuaAnalytics
Dependencies.ProfileQRCode = require(parent.ProfileQRCode)
Dependencies.SocialCommon = require(parent.SocialCommon)
Dependencies.ReactFocusNavigation = require(parent.ReactFocusNavigation)
Dependencies.FocusNavigationUtils = require(parent.FocusNavigationUtils)
Dependencies.InputHandlers = require(parent.InputHandlers)
Dependencies.BuilderIcons = require(parent.BuilderIcons)
Dependencies.Foundation = require(parent.Foundation)

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
Dependencies.UniversalAppPolicy = UniversalAppPolicy.UniversalAppPolicy
Dependencies.tutils = require(parent.tutils)
local Analytics = require(parent.Analytics)
Dependencies.AnalyticsService = Analytics.Analytics.new(game:GetService("RbxAnalyticsService"))
Dependencies.RoduxNetworking = roduxNetworking
local FriendsRodux = require(parent.FriendsRodux)
Dependencies.RoduxFriends = FriendsRodux.config({ keyPath = "FriendsLanding.Friends" })

Dependencies.Dash = require(parent.Dash)
Dependencies.RoduxPresence = RoduxPresence.config({ keyPath = "FriendsLanding.Presence" })

Dependencies.CoreGui = CoreGui
Dependencies.Players = Players
Dependencies.LocalizationService = LocalizationService
Dependencies.TextService = TextService
local FriendsNetworking = require(parent.FriendsNetworking)
Dependencies.NetworkingFriendsEnums = FriendsNetworking.Enums
local FriendsNetworking2 = require(parent.FriendsNetworking)
Dependencies.FriendsNetworking = FriendsNetworking2.config({ roduxNetworking = roduxNetworking })

Dependencies.Otter = Otter
Dependencies.CollisionMatchers = LuaSocialLibrariesDeps.CollisionMatchers
Dependencies.getFStringSocialAddFriendsPageLayer = getFStringSocialAddFriendsPageLayer
Dependencies.getFStringSocialFriendsLandingLayer = getFStringSocialFriendsLandingLayer
Dependencies.getFStringSocialFriendsLayer = getFStringSocialFriendsLayer

Dependencies.FindFriendsModal = ContactImporter.FindFriendsModal
Dependencies.ContactsList = ContactImporter.ContactsList
Dependencies.ContactsRevokedAccessDialog = ContactImporter.ContactsRevokedAccessDialog
local SocialModalsCommon = require(parent.SocialModalsCommon)
Dependencies.updateOptedInUsers = SocialModalsCommon.Utils.updateOptedInUsers
local ContactImporter2 = require(parent.ContactImporter)
Dependencies.fetchOSPermissionsForContacts = ContactImporter2.Utils.fetchOSPermissionsForContacts
local PermissionsProtocol = require(parent.PermissionsProtocol)
Dependencies.PermissionsProtocol = PermissionsProtocol.PermissionsProtocol
Dependencies.AppStorageService = game:GetService("AppStorageService")
local ContactImporter3 = require(parent.ContactImporter)
Dependencies.ContactImporterConstants = ContactImporter3.Constants
Dependencies.ShowContactImporterParams = ContactImporter.ShowContactImporterParams
local DiscoverabilityModal = require(parent.DiscoverabilityModal)
Dependencies.DiscoverabilityOverlay = DiscoverabilityModal.DiscoverabilityOverlay
local DiscoverabilityModal2 = require(parent.DiscoverabilityModal)
Dependencies.DiscoverabilityAnalytics = DiscoverabilityModal2.Analytics

local Localization3 = require(parent.Localization)
Dependencies.Hooks = { useLocalization = Localization3.Hooks.useLocalization }

local UserLib = require(parent.UserLib)
Dependencies.getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions
local UserLib2 = require(parent.UserLib)
Dependencies.UserLibConstants = UserLib2.Utils.Constants
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
Dependencies.useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject
Dependencies.AppHeaderBar = require(parent.AppHeaderBar)
local SharedFlags4 = require(parent.SharedFlags)
Dependencies.GetFFlagFixConnectTabSearchBarHeight = SharedFlags4.GetFFlagFixConnectTabSearchBarHeight
return Dependencies
