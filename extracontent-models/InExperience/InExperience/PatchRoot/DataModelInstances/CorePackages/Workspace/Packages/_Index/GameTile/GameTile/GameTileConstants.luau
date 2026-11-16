local parent = script:FindFirstAncestor("GameTile").Parent
local Foundation = require(parent.Foundation)
local GameTileTypes = require(script.Parent.GameTileTypes)
local GameTileLayoutType = GameTileTypes.GameTileLayoutType

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience

return {
	TileOverlay = { BottomRightPosition = UDim2.new(0.96, 0, 0.93, 0) },
	PlayButtonStyleValues = { Enabled = "Enabled", Disabled = "Disabled" },
	PlayerCountStyleValues = { Hover = "Hover", Always = "Always", Footer = "Footer" },
	TileBadgeComponentTypeValues = { Pill = "Pill", RoundedRectangle = "RoundedRectangle" },
	TileBadgePositionValues = {
		ImageTopLeft = "ImageTopLeft",
		ImageBottomLeft = "ImageBottomLeft",
		ImageTopRight = "ImageTopRight",
		ImageBottomRight = "ImageBottomRight"
	},
	TileBadgePositionCalculators = {
		ImageTopLeft = function(p: number)
			return UDim2.new(0, p, 0, p), Vector2.new(0, 0)
		end,
		ImageBottomLeft = function(p: number)
			return UDim2.new(0, p, 1, -p), Vector2.new(0, 1)
		end,
		ImageTopRight = function(p: number)
			return UDim2.new(1, -p, 0, p), Vector2.new(1, 0)
		end,
		ImageBottomRight = function(p: number)
			return UDim2.new(1, -p, 1, -p), Vector2.new(1, 1)
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
		GameDetails = FFlagLuaAppContinueSortInstantPlay and "GameDetails" or nil,
		NotInterested = "NotInterested",
		WhyThisAd = "WhyThisAd",
		ReportAd = "ReportAd",
		ReportExperience = FFlagLuaAppEnableReportExperience and "ReportExperience" or nil
	}
}
