local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Enums").Tile
local UserTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/UserTile")
local AddFriendsTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/AddFriendsTile")
local FriendsHintTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/FriendsHintTile")
local StartSquadTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/StartSquadTile")
local ShareQRTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/ShareQRTile")
local Tile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/BaseComponents/Tile")
local fFlagSocialCarouselShareQREnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQREnabled
local fFlagSocialCarouselInGameTitleMarquee = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselInGameTitleMarquee

local function renderUserTile(p2, p3, p4, p5, onTileContentChanged, playStatus, onMarqueeFinished, marqueeRunId, onManualMarqueeStart, onManualMarqueeEnd, marqueeOnFocusEnabled)
	local v5 = {
		item = p2,
		index = p3,
		itemSize = p4,
		selectionOrder = p5,
		onTileContentChanged = onTileContentChanged
	}

	if fFlagSocialCarouselInGameTitleMarquee then
		v5.playStatus = playStatus
		v5.onMarqueeFinished = onMarqueeFinished
		v5.marqueeRunId = marqueeRunId
		v5.onManualMarqueeStart = onManualMarqueeStart
		v5.onManualMarqueeEnd = onManualMarqueeEnd
		v5.marqueeOnFocusEnabled = marqueeOnFocusEnabled
	end

	return React.createElement(UserTile, v5)
end

return {
	[tile.Friend] = renderUserTile,
	[tile.Recommendation] = renderUserTile,
	[tile.FriendRequest] = renderUserTile,
	[tile.AddFriends] = function(p2, p3, p4, p5, p6)
		return React.createElement(AddFriendsTile, {
			index = p3,
			itemSize = p4,
			selectionOrder = p5
		})
	end,
	[tile.FriendsHint] = function(p2, p3, p4, p5, p6)
		return React.createElement(FriendsHintTile, {
			index = p3,
			itemSize = p4,
			selectionOrder = p5
		})
	end,
	[tile.StartSquad] = function(p2, p3, p4, p5, p6)
		return React.createElement(StartSquadTile, {
			index = p3,
			item = p2,
			itemSize = p4,
			selectionOrder = p5
		})
	end,
	[tile.ShareQR] = fFlagSocialCarouselShareQREnabled and function(p2, p3, p4, p5, p6)
		return React.createElement(ShareQRTile, {
			index = p3,
			itemSize = p4,
			selectionOrder = p5
		})
	end or nil,
	[tile.Skeleton] = function(p2, p3, p4, p5, p6)
		return React.createElement(Tile, {
			isLoading = true,
			index = p3,
			itemSize = p4
		})
	end
}
