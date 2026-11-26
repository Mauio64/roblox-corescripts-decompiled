local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile

local fFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local function getFriendStatusFromTileType(p2)
	if fFlagShowRequestsInCarouselForAllUsers and p2 == tile.FriendRequest then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if p2 == tile.Friend then
		return Enum.FriendStatus.Friend
	end

	return Enum.FriendStatus.NotFriend
end

return getFriendStatusFromTileType
