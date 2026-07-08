local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local GameInfosReducer = require(GameTileParent.GameInfosRodux).GameInfosReducer
local React = require(GameTileParent.React)
local useSelector = require(GameTileParent.RoactUtils).Hooks.RoactRodux.useSelector
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local getValidTileBadges = require(GameTile.Overlays.getValidTileBadges)

require(GameTile.GameTileTypes)

local function useValidTileBadges(s1: string, s2: string?, p1) -- line: 13
	-- upvalues: useSelector (copy), GameInfosReducer (copy), getGameTileLayoutData (copy), React (copy), getValidTileBadges (copy)
	local v12 = useSelector(function(p2) -- line: 18
		-- upvalues: GameInfosReducer (copy), s1 (copy)
		return p2.Personalization[GameInfosReducer.key][s1]
	end)
	local v13 = getGameTileLayoutData(v12, s2)

	return (React.useMemo(function() -- line: 25
		-- upvalues: p1 (copy), v13 (copy), getValidTileBadges (copy)
		local v15 = nil

		if p1 then
			v15 = p1
		elseif v13 and v13.tileBadgesByPosition then
			v15 = v13.tileBadgesByPosition
		end

		if v15 then
			return getValidTileBadges(v15)
		end

		return nil
	end, {
		v13,
		p1
	}))
end

return useValidTileBadges
