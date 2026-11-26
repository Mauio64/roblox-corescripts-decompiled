local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Style").useDesignTokens
local gameTileConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/GameTile").GameTileConstants
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameCollectionLayoutCalculators = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionLayoutCalculators")

local fFlagLuaAppFixHomeGridPlaceholderFlowIssues = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppFixHomeGridPlaceholderFlowIssues
local fFlagLuaAppNarrowTileHideRating = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHideRating
local fFlagLuaAppNarrowTileHidePlayerCount = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppNarrowTileHidePlayerCount

local function useGetGameTileHeight(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	local v5 = useDesignTokens()

	local v6 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	if fFlagLuaAppFixHomeGridPlaceholderFlowIssues then
		if v6 then
			if p7 then
				if p7 > 0 then
					v6 = not (if fFlagLuaAppNarrowTileHideRating then p10 else fFlagLuaAppNarrowTileHidePlayerCount and p10)
				else
					v6 = false
				end
			else
				v6 = p7
			end
		end
	elseif v6 then
		if p7 > 0 then
			v6 = not (if fFlagLuaAppNarrowTileHideRating then p10 else fFlagLuaAppNarrowTileHidePlayerCount and p10)
		else
			v6 = false
		end
	end

	local v7

	if v6 then
		v7 = gameTileConstants.TileTextLines[p3].largeMetadataTextLines
	else
		v7 = gameTileConstants.TileTextLines[p3].metadataTextLines
	end

	local useCallback = React.useCallback
	local function fn(p11)
		return GameCollectionLayoutCalculators.calculateTileHeightFromWidth(p11, p2, p3, v5, p4, p5, p6, p7, p8, p9, v7)
	end

	if not (fFlagLuaAppNarrowTileHideRating or fFlagLuaAppNarrowTileHidePlayerCount) then
		p10 = nil
	end

	return useCallback(fn, {
		v5,
		p2,
		p3,
		p4,
		p5,
		p6,
		p7,
		p8,
		p9,
		v7,
		p10
	})
end

return useGetGameTileHeight
