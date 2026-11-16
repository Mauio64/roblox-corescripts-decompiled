local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem")
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local sduiComponentType = SduiCoreSystem.SduiComponentType

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SharedFlags")
local fFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction
local fFlagLuaAppSduiHomeFriendCarousel = SharedFlags.FFlagLuaAppSduiHomeFriendCarousel
local fFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport
local fFlagSduiUserSearchTile = SharedFlags.FFlagSduiUserSearchTile
local FFlagSduiFriendsOwnedChip = require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Flags/FFlagSduiFriendsOwnedChip")

local function registerSocialComponents()
	local v5 = {
		[sduiComponentType.FriendCarousel] = fFlagLuaAppSduiHomeFriendCarousel and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Components/SduiFriendCarousel")
			end
		} or nil,
		[sduiComponentType.PymkCarousel] = fFlagLuaAppSduiHomePageSupport and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Components/SduiPymkCarousel")
			end
		} or nil,
		[sduiComponentType.FriendRequestButton] = fFlagSduiRequestFriendshipAction and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Components/SduiFriendRequestButton")
			end
		} or nil,
		[sduiComponentType.UserSearchTile] = fFlagSduiUserSearchTile and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Components/SduiUserSearchTile")
			end
		} or nil,
		[sduiComponentType.FriendsOwnedChip] = FFlagSduiFriendsOwnedChip and {
			getLazyComponent = function()
				return require("@game/CorePackages/Workspace/Packages/_Index/SocialServerDrivenUi/SocialServerDrivenUi/Components/SduiFriendsOwnedChip")
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v5)
end

return registerSocialComponents
