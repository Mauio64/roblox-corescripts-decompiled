local Parent = script:FindFirstAncestor("GameTile").Parent
local Foundation = require(Parent.Foundation)
local GameTileLayoutType = require(script.Parent.GameTileTypes).GameTileLayoutType
local FFlagLuaAppEnableSponsoredReportAd = require(Parent.SharedFlags).FFlagLuaAppEnableSponsoredReportAd

return {
	TileOverlay = {
		BottomRightPosition = UDim2.new(0.96, 0, 0.93, 0)
	},
	PlayButtonStyleValues = {
		Enabled = "Enabled",
		Disabled = "Disabled"
	},
	PlayerCountStyleValues = {
		Hover = "Hover",
		Always = "Always",
		Footer = "Footer"
	},
	TileBadgeComponentTypeValues = {
		Pill = "Pill",
		RoundedRectangle = "RoundedRectangle"
	},
	TileBadgePositionValues = {
		ImageTopLeft = "ImageTopLeft",
		ImageBottomLeft = "ImageBottomLeft",
		ImageTopRight = "ImageTopRight",
		ImageBottomRight = "ImageBottomRight"
	},
	TileBadgePositionCalculators = {
		ImageTopLeft = function(n1: number) -- line: 36
			return UDim2.new(0, n1, 0, n1), Vector2.new(0, 0)
		end,
		ImageBottomLeft = function(n2: number) -- line: 39
			return UDim2.new(0, n2, 1, -n2), Vector2.new(0, 1)
		end,
		ImageTopRight = function(n3: number) -- line: 42
			return UDim2.new(1, -n3, 0, n3), Vector2.new(1, 0)
		end,
		ImageBottomRight = function(n4: number) -- line: 45
			return UDim2.new(1, -n4, 1, -n4), Vector2.new(1, 1)
		end
	},
	TileBadgeIconNamesByType = {
		PaidAccess = "icons/menu/gem_small",
		["icons/menu/lock_closed"] = Foundation.Enums.IconName.LockClosed
	},
	TileTextLines = {
		[GameTileLayoutType.Narrow] = {
			titleTextLines = 2,
			metadataTextLines = 1,
			largeMetadataTextLines = 2
		},
		[GameTileLayoutType.Wide] = {
			titleTextLines = 1,
			metadataTextLines = 1,
			largeMetadataTextLines = 1
		},
		[GameTileLayoutType.Event] = {
			titleTextLines = 1,
			metadataTextLines = 1,
			largeMetadataTextLines = 1
		}
	},
	TileOverflowMenuItems = {
		NotInterested = "NotInterested",
		WhyThisAd = "WhyThisAd",
		ReportAd = if not FFlagLuaAppEnableSponsoredReportAd then nil else "ReportAd"
	}
}
