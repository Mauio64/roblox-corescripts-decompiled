local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local gameTileLayoutType = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes").GameTileLayoutType

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience

return {
	TileOverlay = { BottomRightPosition = UDim2.new(0.96, 0, 0.93, 0) },
	PlayButtonStyleValues = { Enabled = "Enabled", Disabled = "Disabled" },
	PlayerCountStyleValues = { Hover = "Hover", Always = "Always", Footer = "Footer" },
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
		ImageTopLeft = function(p2)
			return UDim2.new(0, p2, 0, p2), Vector2.new(0, 0)
		end,
		ImageBottomLeft = function(p2)
			return UDim2.new(0, p2, 1, -p2), Vector2.new(0, 1)
		end,
		ImageTopRight = function(p2)
			return UDim2.new(1, -p2, 0, p2), Vector2.new(1, 0)
		end,
		ImageBottomRight = function(p2)
			return UDim2.new(1, -p2, 1, -p2), Vector2.new(1, 1)
		end
	},
	TileBadgeIconNamesByType = {
		PaidAccess = "icons/menu/gem_small",
		["icons/menu/lock_closed"] = Foundation.Enums.IconName.LockClosed
	},
	TileTextLines = {
		[gameTileLayoutType.Narrow] = {
			titleTextLines = 2,
			metadataTextLines = 1,
			largeMetadataTextLines = 2
		},
		[gameTileLayoutType.Wide] = {
			titleTextLines = 1,
			metadataTextLines = 1,
			largeMetadataTextLines = 1
		},
		[gameTileLayoutType.Event] = {
			titleTextLines = 1,
			metadataTextLines = 1,
			largeMetadataTextLines = 1
		}
	},
	TileOverflowMenuItems = {
		GameDetails = fFlagLuaAppContinueSortInstantPlay and "GameDetails" or nil,
		NotInterested = "NotInterested",
		WhyThisAd = "WhyThisAd",
		ReportAd = "ReportAd",
		ReportExperience = fFlagLuaAppEnableReportExperience and "ReportExperience" or nil
	}
}
