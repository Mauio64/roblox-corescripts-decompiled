local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local React = require(SocialCarouselParent.React)
local Tile = require(SocialCarousel.Common.Enums).Tile
local UserTile = require(SocialCarousel.Components.Tiles.UserTile)
local AddFriendsTile = require(SocialCarousel.Components.Tiles.AddFriendsTile)
local FriendsHintTile = require(SocialCarousel.Components.Tiles.FriendsHintTile)
local StartSquadTile = require(SocialCarousel.Components.Tiles.StartSquadTile)
local ShareQRTile = require(SocialCarousel.Components.Tiles.ShareQRTile)
local Tile2 = require(SocialCarousel.BaseComponents.Tile)
local FFlagSocialCarouselShareQREnabled = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQREnabled

return {
	[Tile.Friend] = function(p1, n1: number, uDim2: UDim2, n2: number?, p2) -- line: 14
		-- upvalues: React (copy), UserTile (copy)
		return React.createElement(UserTile, {
			item = p1,
			index = n1,
			itemSize = uDim2,
			selectionOrder = n2,
			onTileContentChanged = p2
		})
	end,
	[Tile.Recommendation] = function(p3, n3: number, uDim2: UDim2, n4: number?, p4) -- line: 29
		-- upvalues: React (copy), UserTile (copy)
		return React.createElement(UserTile, {
			item = p3,
			index = n3,
			itemSize = uDim2,
			selectionOrder = n4,
			onTileContentChanged = p4
		})
	end,
	[Tile.AddFriends] = function(_, n5: number, uDim2: UDim2, n6: number?, _) -- line: 44
		-- upvalues: React (copy), AddFriendsTile (copy)
		return React.createElement(AddFriendsTile, {
			index = n5,
			itemSize = uDim2,
			selectionOrder = n6
		})
	end,
	[Tile.FriendsHint] = function(_, n7: number, uDim2: UDim2, n8: number?, _) -- line: 51
		-- upvalues: React (copy), FriendsHintTile (copy)
		return React.createElement(FriendsHintTile, {
			index = n7,
			itemSize = uDim2,
			selectionOrder = n8
		})
	end,
	[Tile.StartSquad] = function(p9, n9: number, uDim2: UDim2, n10: number?, _) -- line: 58
		-- upvalues: React (copy), StartSquadTile (copy)
		return React.createElement(StartSquadTile, {
			index = n9,
			item = p9,
			itemSize = uDim2,
			selectionOrder = n10
		})
	end,
	[Tile.ShareQR] = if not FFlagSocialCarouselShareQREnabled then nil else function(_, n11: number, uDim2: UDim2, n12: number?, _) -- line: 67
		-- upvalues: React (copy), ShareQRTile (copy)
		return React.createElement(ShareQRTile, {
			index = n11,
			itemSize = uDim2,
			selectionOrder = n12
		})
	end,
	[Tile.Skeleton] = function(_, n13: number, uDim2: UDim2, _: number?, _) -- line: 75
		-- upvalues: React (copy), Tile2 (copy)
		return React.createElement(Tile2, {
			isLoading = true,
			index = n13,
			itemSize = uDim2
		})
	end
}
