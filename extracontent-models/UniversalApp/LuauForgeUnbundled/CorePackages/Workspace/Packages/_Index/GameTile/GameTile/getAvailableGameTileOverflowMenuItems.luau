local GameTileConstants = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileConstants")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags")
local tileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems
local fFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local fFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience

local function getAvailableGameTileOverflowMenuItems(data)
	local availableGameTileOverflowMenuItems = {}

	if data.isSponsored then
		if data.enableSponsoredFeedback then
			availableGameTileOverflowMenuItems[tileOverflowMenuItems.WhyThisAd] = true
		end

		if data.enableReportAd then
			availableGameTileOverflowMenuItems[tileOverflowMenuItems.ReportAd] = true
		end
	end

	if data.enableExplicitFeedback then
		availableGameTileOverflowMenuItems[tileOverflowMenuItems.NotInterested] = true
	end

	if fFlagLuaAppContinueSortInstantPlay and data.enableGameDetails then
		availableGameTileOverflowMenuItems[tileOverflowMenuItems.GameDetails] = true
	end

	if fFlagLuaAppEnableReportExperience and data.enableReportExperience and not data.isSponsored then
		availableGameTileOverflowMenuItems[tileOverflowMenuItems.ReportExperience] = true
	end

	return availableGameTileOverflowMenuItems
end

return getAvailableGameTileOverflowMenuItems
