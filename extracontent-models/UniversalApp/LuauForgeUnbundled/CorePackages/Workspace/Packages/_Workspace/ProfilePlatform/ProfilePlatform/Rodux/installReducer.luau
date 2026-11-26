local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Rodux")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Games")
local ItemDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/ItemDetails")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/BundleDetails")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/AssetDetails")
local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Presence")
local defineFastFlag = game:DefineFastFlag("ProfilePlatformFixPresenceReducer", false)

local v5 = if defineFastFlag then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/PresenceReducer") else nil

local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/Profiles")

local FFlagProfilePlatformPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformPresenceStoreMigration")

return function()
	local combineReducers = Rodux.combineReducers
	local v6 = {
		Games = module2.installReducer(),
		ItemAssets = ItemDetails,
		BundleDetails = module4,
		AssetDetails = module5,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Presence = 0,
		Profiles = 0
	}

	local v7 = if not FFlagProfilePlatformPresenceStoreMigration then (if defineFastFlag then v5 else module7.installReducer()) else nil
	v6.Presence = v7

	v6.Profiles = module8
	return combineReducers(v6)
end
