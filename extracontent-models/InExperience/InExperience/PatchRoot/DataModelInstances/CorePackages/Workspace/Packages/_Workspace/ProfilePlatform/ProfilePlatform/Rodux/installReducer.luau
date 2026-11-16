local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Rodux = require(parent.Rodux)
local Games = require(ProfilePlatform.Rodux.Games)
local ItemDetails = require(ProfilePlatform.Rodux.ItemDetails)
local BundleDetails = require(ProfilePlatform.Rodux.BundleDetails)
local AssetDetails = require(ProfilePlatform.Rodux.AssetDetails)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local Presence = require(ProfilePlatform.Rodux.Presence)
local defineFastFlag = game:DefineFastFlag("ProfilePlatformFixPresenceReducer", false)
local PresenceReducer

if defineFastFlag then
	PresenceReducer = require(ProfilePlatform.Rodux.PresenceReducer)
else
	PresenceReducer = nil
end

local Profiles = require(ProfilePlatform.Rodux.Profiles)

local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)

return function()
	local combineReducers = Rodux.combineReducers
	local v = {
		Games = Games.installReducer(),
		ItemAssets = ItemDetails,
		BundleDetails = BundleDetails,
		AssetDetails = AssetDetails,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Presence = 0,
		Profiles = 0
	}
	local presence

	if not FFlagProfilePlatformPresenceStoreMigration then
		if defineFastFlag then
			presence = PresenceReducer
		else
			presence = Presence.installReducer()
		end
	end

	v.Presence = presence

	v.Profiles = Profiles
	return combineReducers(v)
end
