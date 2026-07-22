local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Rodux = require(ProfilePlatformParent.Rodux)
local Games = require(ProfilePlatform.Rodux.Games)
local ItemDetails = require(ProfilePlatform.Rodux.ItemDetails)
local BundleDetails = require(ProfilePlatform.Rodux.BundleDetails)
local AssetDetails = require(ProfilePlatform.Rodux.AssetDetails)
local AssetData = require(ProfilePlatform.Rodux.AssetData)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local Presence = require(ProfilePlatform.Rodux.Presence)
local v11 = game:DefineFastFlag("ProfilePlatformFixPresenceReducer", false)
local v12 = if not v11 then nil else require(ProfilePlatform.Rodux.PresenceReducer)
local Profiles = require(ProfilePlatform.Rodux.Profiles)
local FFlagAddVideoToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddVideoToCommunityProfile
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)

return function() -- line: 25
	-- upvalues: Rodux (copy), Games (copy), ItemDetails (copy), BundleDetails (copy), AssetDetails (copy), FFlagAddVideoToCommunityProfile (copy), AssetData (copy), myRoduxNetworking (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v11 (copy), v12 (copy), Presence (copy), Profiles (copy)
	return Rodux.combineReducers({
		Games = Games.installReducer(),
		ItemAssets = ItemDetails,
		BundleDetails = BundleDetails,
		AssetDetails = AssetDetails,
		AssetData = if not FFlagAddVideoToCommunityProfile then nil else AssetData,
		NetworkStatus = myRoduxNetworking.installReducer(),
		Presence = if not FFlagProfilePlatformPresenceStoreMigration then if not v11 then Presence.installReducer() else v12 else nil,
		Profiles = Profiles
	})
end
