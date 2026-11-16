local parent = script.Parent
local parent2 = parent.Parent
local LuaSocialLibrariesDeps = require(parent2.LuaSocialLibrariesDeps)
local Constants = require(parent.Common.Constants)
local RODUX_KEY = Constants.RODUX_KEY

local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require(parent2.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local v = Lumberyak.Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local defineFastInt = game:DefineFastInt("SetAliasHttpRetryCount", 3)
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

local config2 = RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local SocialLuaAnalytics = require(parent2.SocialLuaAnalytics)

local Dependencies = {
	AppStorageService = game:GetService("AppStorageService"),
	Analytics = require(parent2.Analytics),
	SocialLuaAnalytics = SocialLuaAnalytics,
	Dash = require(parent2.Dash),
	UIBlox = require(parent2.UIBlox),
	Roact = require(parent2.Roact),
	RoactRodux = require(parent2.RoactRodux),
	RoactNavigation = require(parent2.RoactNavigation),
	Rodux = require(parent2.Rodux),
	React = require(parent2.React),
	ContactsProtocol = 0,
	Promise = 0,
	enumerate = 0,
	UserProfiles = 0,
	RoactFitComponents = 0,
	RoduxNetworking = 0,
	NetworkingAliases = 0,
	RoduxAliases = 0,
	SocialLibraries = 0,
	LocalizationProvider = 0,
	Hooks = 0,
	Foundation = 0
}
local ContactsProtocol = require(parent2.ContactsProtocol)
Dependencies.ContactsProtocol = ContactsProtocol.ContactsProtocol
Dependencies.Promise = require(parent2.Promise)
Dependencies.enumerate = require(parent2.enumerate)
Dependencies.UserProfiles = require(parent2.UserProfiles)
Dependencies.RoactFitComponents = LuaSocialLibrariesDeps.RoactFitComponents
Dependencies.RoduxNetworking = config2

Dependencies.NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({
	roduxNetworking = config2
})

Dependencies.RoduxAliases = LuaSocialLibrariesDeps.RoduxAliases.config({
	keyPath = RODUX_KEY .. ".Aliases"
})

Dependencies.SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({})
local Localization = require(parent2.Localization)
Dependencies.LocalizationProvider = Localization.LocalizationProvider

local RoactUtils = require(parent2.RoactUtils)
local hooks = {
	useEffectOnMount = RoactUtils.Hooks.useEffectOnMount,
	useLocalization = 0,
	useSelector = 0,
	useDispatch = 0,
	useLocalUserId = 0
}
local Localization2 = require(parent2.Localization)
hooks.useLocalization = Localization2.Hooks.useLocalization
local RoactUtils2 = require(parent2.RoactUtils)
hooks.useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local RoactUtils3 = require(parent2.RoactUtils)
hooks.useDispatch = RoactUtils3.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent2.RobloxAppHooks)
hooks.useLocalUserId = RobloxAppHooks.useLocalUserId
Dependencies.Hooks = hooks

Dependencies.Foundation = require(parent2.Foundation)
return Dependencies
