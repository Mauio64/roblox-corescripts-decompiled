local SocialServerDrivenUi = script:FindFirstAncestor("SocialServerDrivenUi")
local parent = SocialServerDrivenUi.Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiComponentRegistry = SduiCoreSystem.getSduiComponentRegistry
local SduiComponentType = SduiCoreSystem.SduiComponentType

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiRequestFriendshipAction = SharedFlags.FFlagSduiRequestFriendshipAction
local FFlagLuaAppSduiHomeFriendCarousel = SharedFlags.FFlagLuaAppSduiHomeFriendCarousel
local FFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport
local FFlagSduiUserSearchTile = SharedFlags.FFlagSduiUserSearchTile
local FFlagSduiFriendsOwnedChip = require(SocialServerDrivenUi.Flags.FFlagSduiFriendsOwnedChip)

local function registerSocialComponents()
	local v = {
		[SduiComponentType.FriendCarousel] = FFlagLuaAppSduiHomeFriendCarousel and {
			getLazyComponent = function()
				return require(SocialServerDrivenUi.Components.SduiFriendCarousel)
			end
		} or nil,
		[SduiComponentType.PymkCarousel] = FFlagLuaAppSduiHomePageSupport and {
			getLazyComponent = function()
				return require(SocialServerDrivenUi.Components.SduiPymkCarousel)
			end
		} or nil,
		[SduiComponentType.FriendRequestButton] = FFlagSduiRequestFriendshipAction and {
			getLazyComponent = function()
				return require(SocialServerDrivenUi.Components.SduiFriendRequestButton)
			end
		} or nil,
		[SduiComponentType.UserSearchTile] = FFlagSduiUserSearchTile and {
			getLazyComponent = function()
				return require(SocialServerDrivenUi.Components.SduiUserSearchTile)
			end
		} or nil,
		[SduiComponentType.FriendsOwnedChip] = FFlagSduiFriendsOwnedChip and {
			getLazyComponent = function()
				return require(SocialServerDrivenUi.Components.SduiFriendsOwnedChip)
			end
		} or nil
	}

	getSduiComponentRegistry().registerComponentDefinitions(v)
end

return registerSocialComponents
