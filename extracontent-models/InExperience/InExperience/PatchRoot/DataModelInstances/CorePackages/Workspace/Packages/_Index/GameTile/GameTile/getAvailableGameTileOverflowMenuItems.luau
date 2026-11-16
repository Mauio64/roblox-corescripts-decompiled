local GameTile = script:FindFirstAncestor("GameTile")
local parent = GameTile.Parent

local GameTileConstants = require(GameTile.GameTileConstants)
local SharedFlags = require(parent.SharedFlags)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems
local FFlagLuaAppContinueSortInstantPlay = SharedFlags.FFlagLuaAppContinueSortInstantPlay
local FFlagLuaAppEnableReportExperience = SharedFlags.FFlagLuaAppEnableReportExperience

local function getAvailableGameTileOverflowMenuItems(data)
	local availableGameTileOverflowMenuItems = {}

	if data.isSponsored then
		if data.enableSponsoredFeedback then
			availableGameTileOverflowMenuItems[TileOverflowMenuItems.WhyThisAd] = true
		end

		if data.enableReportAd then
			availableGameTileOverflowMenuItems[TileOverflowMenuItems.ReportAd] = true
		end
	end

	if data.enableExplicitFeedback then
		availableGameTileOverflowMenuItems[TileOverflowMenuItems.NotInterested] = true
	end

	if FFlagLuaAppContinueSortInstantPlay and data.enableGameDetails then
		availableGameTileOverflowMenuItems[TileOverflowMenuItems.GameDetails] = true
	end

	if FFlagLuaAppEnableReportExperience and data.enableReportExperience and not data.isSponsored then
		availableGameTileOverflowMenuItems[TileOverflowMenuItems.ReportExperience] = true
	end

	return availableGameTileOverflowMenuItems
end

return getAvailableGameTileOverflowMenuItems
