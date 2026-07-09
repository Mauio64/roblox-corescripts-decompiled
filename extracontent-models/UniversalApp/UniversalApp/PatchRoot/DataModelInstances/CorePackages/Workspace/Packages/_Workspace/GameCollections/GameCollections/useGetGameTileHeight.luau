local GameCollections = script:FindFirstAncestor("GameCollections")
local GameCollectionsParent = GameCollections.Parent
local React = require(GameCollectionsParent.React)
local useDesignTokens = require(GameCollectionsParent.Style).useDesignTokens
local GameTileConstants = require(GameCollectionsParent.GameTile).GameTileConstants
local Responsive = require(GameCollectionsParent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameCollectionLayoutCalculators = require(GameCollections.GameCollectionLayoutCalculators)
local FFlagLuaAppFixHomeGridPlaceholderFlowIssues = require(GameCollectionsParent.SharedFlags).FFlagLuaAppFixHomeGridPlaceholderFlowIssues
local FFlagLuaAppNarrowTileHideRating = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHideRating
local FFlagLuaAppNarrowTileHidePlayerCount = require(GameCollectionsParent.SharedFlags).FFlagLuaAppNarrowTileHidePlayerCount

local function useGetGameTileHeight(b1: boolean?, p1, b2: boolean?, b3: boolean?, b4: boolean?, n1: number?, n2: number?, n3: number?, b5: boolean?) -- line: 22
	-- upvalues: useDesignTokens (copy), useBreakpointXOrSmaller (copy), Responsive (copy), FFlagLuaAppFixHomeGridPlaceholderFlowIssues (copy), FFlagLuaAppNarrowTileHideRating (copy), FFlagLuaAppNarrowTileHidePlayerCount (copy), GameTileConstants (copy), React (copy), GameCollectionLayoutCalculators (copy)
	local v22 = useDesignTokens()
	local v23 = useBreakpointXOrSmaller(Responsive.Keys.Small)
	local u24 = if not if not FFlagLuaAppFixHomeGridPlaceholderFlowIssues then v23 and (n1 > 0 and not ((FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) and b5)) else v23 and (n1 and (n1 > 0 and not ((FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) and b5))) then GameTileConstants.TileTextLines[p1].metadataTextLines else GameTileConstants.TileTextLines[p1].largeMetadataTextLines

	return React.useCallback(function(n4: number) -- line: 50
		-- upvalues: GameCollectionLayoutCalculators (copy), b1 (copy), p1 (copy), v22 (copy), b2 (copy), b3 (copy), b4 (copy), n1 (copy), n2 (copy), n3 (copy), u24 (ref)
		return GameCollectionLayoutCalculators.calculateTileHeightFromWidth(n4, b1, p1, v22, b2, b3, b4, n1, n2, n3, u24)
	end, {
		v22,
		b1,
		p1,
		b2,
		b3,
		b4,
		n1,
		n2,
		n3,
		u24,
		if not FFlagLuaAppNarrowTileHideRating and not FFlagLuaAppNarrowTileHidePlayerCount then nil else b5
	})
end

return useGetGameTileHeight
