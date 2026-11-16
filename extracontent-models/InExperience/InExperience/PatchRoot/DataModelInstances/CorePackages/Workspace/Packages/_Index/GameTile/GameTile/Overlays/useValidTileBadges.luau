local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer
local React = require(parent.React)

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local getValidTileBadges = require(GameTile.Overlays.getValidTileBadges)
require(GameTile.GameTileTypes)

local function useValidTileBadges(p: string, p2: string?, p3)
	local gameTileLayoutData = getGameTileLayoutData(useSelector(function(p4)
		return p4.Personalization[GameInfosReducer.key][p]
	end), p2)

	return (React.useMemo(function()
		local v = nil

		if p3 then
			v = p3
		elseif gameTileLayoutData and gameTileLayoutData.tileBadgesByPosition then
			v = gameTileLayoutData.tileBadgesByPosition
		end

		if v then
			return getValidTileBadges(v)
		end

		return nil
	end, { gameTileLayoutData, p3 }))
end

return useValidTileBadges
