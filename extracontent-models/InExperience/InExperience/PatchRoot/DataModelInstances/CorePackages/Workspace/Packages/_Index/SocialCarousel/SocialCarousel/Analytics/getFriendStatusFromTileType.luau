local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent

local SharedFlags = require(parent.SharedFlags)
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile

local FFlagShowRequestsInCarouselForAllUsers = SharedFlags.FFlagShowRequestsInCarouselForAllUsers

local function getFriendStatusFromTileType(p: string?)
	if FFlagShowRequestsInCarouselForAllUsers and p == Tile.FriendRequest then
		return Enum.FriendStatus.FriendRequestReceived
	end

	if p == Tile.Friend then
		return Enum.FriendStatus.Friend
	end

	return Enum.FriendStatus.NotFriend
end

return getFriendStatusFromTileType
