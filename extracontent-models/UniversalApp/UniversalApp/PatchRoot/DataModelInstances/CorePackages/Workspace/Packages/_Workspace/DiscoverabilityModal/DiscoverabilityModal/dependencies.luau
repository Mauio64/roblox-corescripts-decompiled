local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local LuaSocialLibrariesDeps = require(scriptParentParent.LuaSocialLibrariesDeps)
local RoduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require(scriptParentParent.Lumberyak)
local httpRequest = LuaSocialLibrariesDeps.httpRequest
local v7 = Lumberyak.Logger.new(nil, "DiscoverabilityModal"):new("DiscoverabilityModal Networking")
local v8 = game:DefineFastInt("DiscoverabilityModalHttpRetryCount", 3)
local v9 = httpRequest.config({
	requestFunction = function(p1, p2, p3) -- line: 13
		-- upvalues: v7 (copy), httpRequest (copy)
		v7:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

		return httpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
	end,
	postRequestFunction = function(p4, p5) -- line: 17
		-- upvalues: v7 (copy)
		v7:debug("Returned: {}", string.format("[ requestMethod = %q, url = %q, statusCode = %s, body = %s ]", p5.requestMethod, p5.url, p4.StatusCode, p4.Body))
	end,
	maxRetryCount = v8
})
local RODUX_KEY = require(scriptParent.Common.Constants).RODUX_KEY
local v11 = RoduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = v9
})
local SocialLuaAnalytics = require(scriptParentParent.SocialLuaAnalytics)
local SharedFlags = require(scriptParentParent.SharedFlags)

return {
	AppStorageService = game:GetService("AppStorageService"),
	SocialLuaAnalytics = SocialLuaAnalytics,
	Dash = require(scriptParentParent.Dash),
	UIBlox = require(scriptParentParent.UIBlox),
	Foundation = require(scriptParentParent.Foundation),
	Roact = require(scriptParentParent.Roact),
	RoactRodux = require(scriptParentParent.RoactRodux),
	Rodux = require(scriptParentParent.Rodux),
	React = require(scriptParentParent.React),
	ContactsProtocol = require(scriptParentParent.ContactsProtocol).ContactsProtocol,
	Promise = require(scriptParentParent.Promise),
	enumerate = require(scriptParentParent.enumerate),
	RoactNavigation = require(scriptParentParent.RoactNavigation),
	rolloutByApplicationId = require(scriptParentParent.AppCommonLib).rolloutByApplicationId,
	RoduxNetworking = v11,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialModalsCommon = require(scriptParentParent.SocialModalsCommon),
	PermissionsProtocol = require(scriptParentParent.PermissionsProtocol).PermissionsProtocol,
	NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = v11
	}),
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = RODUX_KEY .. ".UserPermissions"
	}),
	LocalizationProvider = require(scriptParentParent.Localization).LocalizationProvider,
	Hooks = {
		useLocalization = require(scriptParentParent.Localization).Hooks.useLocalization,
		useNavigation = require(scriptParentParent.Navigation).useNavigation,
		useSelector = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useSelector,
		useDispatch = require(scriptParentParent.RoactUtils).Hooks.RoactRodux.useDispatch
	},
	getFStringSocialProfileLayer = SharedFlags.getFStringSocialProfileLayer
}
