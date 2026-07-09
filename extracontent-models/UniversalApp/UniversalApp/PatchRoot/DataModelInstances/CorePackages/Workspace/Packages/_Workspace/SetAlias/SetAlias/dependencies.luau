local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local RODUX_KEY = require(scriptParent.Common.Constants).RODUX_KEY
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require(scriptParentParent.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v8 = Lumberyak.Logger.new(nil, RODUX_KEY):new(RODUX_KEY .. " Networking")
local v9 = game:DefineFastInt("SetAliasHttpRetryCount", 3)
local v10 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 14
		-- upvalues: v8 (copy), httpRequest (copy)
		v8:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 18
		-- upvalues: v8 (copy)
		v8:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v9
})
local v11 = RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v10
})
local SocialLuaAnalytics = require(scriptParentParent.SocialLuaAnalytics)

return {
	AppStorageService = game:GetService("AppStorageService"),
	Analytics = require(scriptParentParent.Analytics),
	SocialLuaAnalytics = SocialLuaAnalytics,
	Dash = require(scriptParentParent.Dash),
	UIBlox = require(scriptParentParent.UIBlox),
	Roact = require(scriptParentParent.Roact),
	RoactRodux = require(scriptParentParent.RoactRodux),
	RoactNavigation = require(scriptParentParent.RoactNavigation),
	Rodux = require(scriptParentParent.Rodux),
	React = require(scriptParentParent.React),
	ContactsProtocol = require(scriptParentParent.ContactsProtocol).ContactsProtocol,
	Promise = require(scriptParentParent.Promise),
	enumerate = require(scriptParentParent.enumerate),
	UserProfiles = require(scriptParentParent.UserProfiles),
	RoactFitComponents = LuaSocialLibrariesDeps.RoactFitComponents,
	RoduxNetworking = v11,
	NetworkingAliases = LuaSocialLibrariesDeps.NetworkingAliases.config({
		roduxNetworking = v11
	}),
	RoduxAliases = LuaSocialLibrariesDeps.RoduxAliases.config({
		keyPath = RODUX_KEY .. ".Aliases"
	}),
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider,
	Hooks = {
		useEffectOnMount = require(scriptParentParent.RoactUtils).Hooks.useEffectOnMount,
		useLocalization = require(scriptParentParent.Localization).Hooks.useLocalization,
		useSelector = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useSelector,
		useDispatch = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useDispatch,
		useLocalUserId = require(scriptParentParent.RobloxAppHooks).useLocalUserId
	},
	Foundation = require(scriptParentParent.Foundation)
}
