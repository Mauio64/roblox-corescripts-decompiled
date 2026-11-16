local GameCollections = script:FindFirstAncestor("GameCollections")
local parent = GameCollections.Parent

local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local GameTile = require(parent.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local Responsive = require(parent.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local GameCollectionLayoutCalculators = require(GameCollections.GameCollectionLayoutCalculators)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppFixHomeGridPlaceholderFlowIssues = SharedFlags.FFlagLuaAppFixHomeGridPlaceholderFlowIssues
local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHideRating = SharedFlags2.FFlagLuaAppNarrowTileHideRating
local SharedFlags3 = require(parent.SharedFlags)
local FFlagLuaAppNarrowTileHidePlayerCount = SharedFlags3.FFlagLuaAppNarrowTileHidePlayerCount

local function useGetGameTileHeight(flag: boolean?, p, flag2: boolean?, flag3: boolean?, flag4: boolean?, p2: number?, p3: number?, p4: number?, flag5: boolean?)
	local v = useDesignTokens()

	local v2 = useBreakpointXOrSmaller(Responsive.Keys.Small)

	if FFlagLuaAppFixHomeGridPlaceholderFlowIssues then
		if v2 then
			if p2 then
				if p2 > 0 then
					local v3

					if FFlagLuaAppNarrowTileHideRating then
						v3 = flag5
					else
						v3 = FFlagLuaAppNarrowTileHidePlayerCount and flag5
					end

					v2 = not v3
				else
					v2 = false
				end
			else
				v2 = p2
			end
		end
	elseif v2 then
		if p2 > 0 then
			local v3

			if FFlagLuaAppNarrowTileHideRating then
				v3 = flag5
			else
				v3 = FFlagLuaAppNarrowTileHidePlayerCount and flag5
			end

			v2 = not v3
		else
			v2 = false
		end
	end

	local v3

	if v2 then
		v3 = GameTileConstants.TileTextLines[p].largeMetadataTextLines
	else
		v3 = GameTileConstants.TileTextLines[p].metadataTextLines
	end

	local useCallback = React.useCallback
	local function fn(p5: number)
		return GameCollectionLayoutCalculators.calculateTileHeightFromWidth(
			p5,
			flag,
			p,
			v,
			flag2,
			flag3,
			flag4,
			p2,
			p3,
			p4,
			v3
		)
	end

	if not (FFlagLuaAppNarrowTileHideRating or FFlagLuaAppNarrowTileHidePlayerCount) then
		flag5 = nil
	end

	return useCallback(fn, {
		v,
		flag,
		p,
		flag2,
		flag3,
		flag4,
		p2,
		p3,
		p4,
		v3,
		flag5
	})
end

return useGetGameTileHeight
