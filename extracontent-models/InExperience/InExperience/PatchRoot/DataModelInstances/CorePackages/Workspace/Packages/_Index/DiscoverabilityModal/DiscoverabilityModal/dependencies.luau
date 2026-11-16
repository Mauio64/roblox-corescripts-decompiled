local parent = script.Parent
local parent2 = parent.Parent
local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)

local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require(parent2.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local v = Lumberyak.Logger.new(nil, "DiscoverabilityModal"):new("DiscoverabilityModal Networking")
local defineFastInt = game:DefineFastInt("DiscoverabilityModalHttpRetryCount", 3)
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

local config2 = RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)
local SharedFlags = require(parent2.SharedFlags)

local Dependencies = {
	AppStorageService = game:GetService("AppStorageService"),
	SocialLuaAnalytics = SocialLuaAnalytics,
	Dash = require(parent2.Dash),
	UIBlox = require(parent2.UIBlox),
	Foundation = require(parent2.Foundation),
	Roact = require(parent2.Roact),
	RoactRodux = require(parent2.RoactRodux),
	Rodux = require(parent2.Rodux),
	React = require(parent2.React),
	ContactsProtocol = 0,
	Promise = 0,
	enumerate = 0,
	RoactNavigation = 0,
	rolloutByApplicationId = 0,
	RoduxNetworking = 0,
	SocialLibraries = 0,
	SocialModalsCommon = 0,
	PermissionsProtocol = 0,
	NetworkingUserSettings = 0,
	RoduxUserPermissions = 0,
	LocalizationProvider = 0,
	Hooks = 0,
	getFStringSocialProfileLayer = 0
}
local ContactsProtocol = require(parent2.ContactsProtocol)
Dependencies.ContactsProtocol = ContactsProtocol.ContactsProtocol
Dependencies.Promise = require(parent2.Promise)
Dependencies.enumerate = require(parent2.enumerate)
Dependencies.RoactNavigation = require(parent2.RoactNavigation)
local AppCommonLib = require(parent2.AppCommonLib)
Dependencies.rolloutByApplicationId = AppCommonLib.rolloutByApplicationId
Dependencies.RoduxNetworking = config2

Dependencies.SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({})
Dependencies.SocialModalsCommon = require(parent2.SocialModalsCommon)
local PermissionsProtocol = require(parent2.PermissionsProtocol)
Dependencies.PermissionsProtocol = PermissionsProtocol.PermissionsProtocol
Dependencies.NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
	roduxNetworking = config2
})

Dependencies.RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
	keyPath = RODUX_KEY .. ".UserPermissions"
})

local Localization = require(parent2.Localization)
Dependencies.LocalizationProvider = Localization.LocalizationProvider

local Localization2 = require(parent2.Localization)
local hooks = {
	useLocalization = Localization2.Hooks.useLocalization,
	useNavigation = 0,
	useSelector = 0,
	useDispatch = 0
}
local Navigation = require(parent2.Navigation)
hooks.useNavigation = Navigation.useNavigation
local RoactUtils = require(parent2.RoactUtils)
hooks.useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent2.RoactUtils)
hooks.useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
Dependencies.Hooks = hooks

Dependencies.getFStringSocialProfileLayer = SharedFlags.getFStringSocialProfileLayer
return Dependencies
