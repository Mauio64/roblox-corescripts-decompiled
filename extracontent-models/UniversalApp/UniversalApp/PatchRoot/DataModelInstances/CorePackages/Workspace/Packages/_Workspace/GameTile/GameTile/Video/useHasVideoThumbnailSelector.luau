local GameTile = script:FindFirstAncestor("GameTile")
local GameTileParent = GameTile.Parent
local GameInfosReducer = require(GameTileParent.GameInfosRodux).GameInfosReducer
local useSelector = require(GameTileParent.RoactUtils).Hooks.RoactRodux.useSelector
local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)

local function useHasVideoThumbnailSelector(s1: string, s2: string?) -- line: 10
	-- upvalues: useSelector (copy), GameInfosReducer (copy), getGameTileLayoutData (copy)
	local v9 = useSelector(function(p1) -- line: 11
		-- upvalues: GameInfosReducer (copy), s1 (copy)
		return p1.Personalization[GameInfosReducer.key][s1]
	end)
	local v10 = getGameTileLayoutData(v9, s2)

	return (v10 and (v10.primaryMediaAsset and v10.primaryMediaAsset.wideVideoAssetId)) ~= nil
end

return useHasVideoThumbnailSelector
