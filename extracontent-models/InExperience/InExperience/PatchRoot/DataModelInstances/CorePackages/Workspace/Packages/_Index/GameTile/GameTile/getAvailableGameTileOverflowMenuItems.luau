local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local GameTileConstants = require(GameTile.GameTileConstants)
local SharedFlags = require(GameTileParent.SharedFlags)
local TileOverflowMenuItems = GameTileConstants.TileOverflowMenuItems
local FFlagLuaAppEnableSponsoredReportAd = SharedFlags.FFlagLuaAppEnableSponsoredReportAd

local function getAvailableGameTileOverflowMenuItems(t1: {[any]: any}) -- line: 10
	-- upvalues: FFlagLuaAppEnableSponsoredReportAd (copy), TileOverflowMenuItems (copy)
	local t2 = {}

	if FFlagLuaAppEnableSponsoredReportAd then
		if t1.isSponsored then
			if t1.enableSponsoredFeedback then
				t2[TileOverflowMenuItems.WhyThisAd] = true
			end

			if t1.enableReportAd then
				t2[TileOverflowMenuItems.ReportAd] = true
			end
		end
	elseif t1.enableSponsoredFeedback and t1.isSponsored then
		t2[TileOverflowMenuItems.WhyThisAd] = true
	end

	if t1.enableExplicitFeedback then
		t2[TileOverflowMenuItems.NotInterested] = true
	end

	return t2
end

return getAvailableGameTileOverflowMenuItems
