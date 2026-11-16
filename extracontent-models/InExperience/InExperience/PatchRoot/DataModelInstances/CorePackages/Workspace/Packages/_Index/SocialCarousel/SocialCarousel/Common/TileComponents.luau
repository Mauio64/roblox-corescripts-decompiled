local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local Enums = require(SocialCarousel.Common.Enums)
local Tile = Enums.Tile
local UserTile = require(SocialCarousel.Components.Tiles.UserTile)
local AddFriendsTile = require(SocialCarousel.Components.Tiles.AddFriendsTile)
local FriendsHintTile = require(SocialCarousel.Components.Tiles.FriendsHintTile)
local StartSquadTile = require(SocialCarousel.Components.Tiles.StartSquadTile)
local ShareQRTile = require(SocialCarousel.Components.Tiles.ShareQRTile)
local Tile2 = require(SocialCarousel.BaseComponents.Tile)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSocialCarouselInGameTitleMarquee = SharedFlags2.FFlagSocialCarouselInGameTitleMarquee

local function renderUserTile(p, p2: number, itemSize: UDim2, selectionOrder: number?, onTileContentChanged, playStatus, onMarqueeFinished, marqueeRunId: number?, onManualMarqueeStart, onManualMarqueeEnd, marqueeOnFocusEnabled: boolean?)
	local v = {
		item = p,
		index = p2,
		itemSize = itemSize,
		selectionOrder = selectionOrder,
		onTileContentChanged = onTileContentChanged
	}

	if FFlagSocialCarouselInGameTitleMarquee then
		v.playStatus = playStatus
		v.onMarqueeFinished = onMarqueeFinished
		v.marqueeRunId = marqueeRunId
		v.onManualMarqueeStart = onManualMarqueeStart
		v.onManualMarqueeEnd = onManualMarqueeEnd
		v.marqueeOnFocusEnabled = marqueeOnFocusEnabled
	end

	return React.createElement(UserTile, v)
end

return {
	[Tile.Friend] = renderUserTile,
	[Tile.Recommendation] = renderUserTile,
	[Tile.FriendRequest] = renderUserTile,
	[Tile.AddFriends] = function(_, p: number, itemSize: UDim2, selectionOrder: number?, _)
		return React.createElement(AddFriendsTile, {
			index = p,
			itemSize = itemSize,
			selectionOrder = selectionOrder
		})
	end,
	[Tile.FriendsHint] = function(_, p: number, itemSize: UDim2, selectionOrder: number?, _)
		return React.createElement(FriendsHintTile, {
			index = p,
			itemSize = itemSize,
			selectionOrder = selectionOrder
		})
	end,
	[Tile.StartSquad] = function(p, p2: number, itemSize: UDim2, selectionOrder: number?, _)
		return React.createElement(StartSquadTile, {
			index = p2,
			item = p,
			itemSize = itemSize,
			selectionOrder = selectionOrder
		})
	end,
	[Tile.ShareQR] = FFlagSocialCarouselShareQREnabled and function(_, p: number, itemSize: UDim2, selectionOrder: number?, _)
		return React.createElement(ShareQRTile, {
			index = p,
			itemSize = itemSize,
			selectionOrder = selectionOrder
		})
	end or nil,
	[Tile.Skeleton] = function(_, p: number, itemSize: UDim2, _: number?, _)
		return React.createElement(Tile2, { isLoading = true, index = p, itemSize = itemSize })
	end
}
