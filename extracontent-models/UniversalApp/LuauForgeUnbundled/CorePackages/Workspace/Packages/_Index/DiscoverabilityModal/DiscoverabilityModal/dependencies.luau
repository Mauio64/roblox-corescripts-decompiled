local LuaSocialLibrariesDeps = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/LuaSocialLibrariesDeps")

local roduxNetworking = LuaSocialLibrariesDeps.RoduxNetworking
local Lumberyak = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Lumberyak")
local httpRequest = LuaSocialLibrariesDeps.httpRequest

local v5 = Lumberyak.Logger.new(nil, "DiscoverabilityModal"):new("DiscoverabilityModal Networking")
local defineFastInt = game:DefineFastInt("DiscoverabilityModalHttpRetryCount", 3)
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

local RODUX_KEY = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Common/Constants").RODUX_KEY

local config2 = roduxNetworking.config({
	keyPath = RODUX_KEY .. ".NetworkStatus",
	networkImpl = config
})

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/SocialLuaAnalytics")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/SharedFlags")

return {
	AppStorageService = game:GetService("AppStorageService"),
	SocialLuaAnalytics = module3,
	Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Dash"),
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/UIBlox"),
	Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Foundation"),
	Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Roact"),
	RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RoactRodux"),
	Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Rodux"),
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/React"),
	ContactsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/ContactsProtocol").ContactsProtocol,
	Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Promise"),
	enumerate = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/enumerate"),
	RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RoactNavigation"),
	rolloutByApplicationId = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/AppCommonLib").rolloutByApplicationId,
	RoduxNetworking = config2,
	SocialLibraries = LuaSocialLibrariesDeps.SocialLibraries.config({}),
	SocialModalsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/SocialModalsCommon"),
	PermissionsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/PermissionsProtocol").PermissionsProtocol,
	NetworkingUserSettings = LuaSocialLibrariesDeps.NetworkingUserSettings.config({
		roduxNetworking = config2
	}),
	RoduxUserPermissions = LuaSocialLibrariesDeps.RoduxUserPermissions.config({
		keyPath = RODUX_KEY .. ".UserPermissions"
	}),
	LocalizationProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Localization").LocalizationProvider,
	Hooks = {
		useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Localization").Hooks.useLocalization,
		useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/Navigation").useNavigation,
		useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RoactUtils").Hooks.RoactRodux.useSelector,
		useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoverabilityModal/RoactUtils").Hooks.RoactRodux.useDispatch
	},
	getFStringSocialProfileLayer = SharedFlags.getFStringSocialProfileLayer
}
