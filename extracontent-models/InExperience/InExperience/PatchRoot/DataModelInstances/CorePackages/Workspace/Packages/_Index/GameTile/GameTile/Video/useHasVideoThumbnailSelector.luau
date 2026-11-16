local GameTile = script:FindFirstAncestor("GameTile")

local parent = GameTile.Parent
local GameInfosRodux = require(parent.GameInfosRodux)
local GameInfosReducer = GameInfosRodux.GameInfosReducer

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local getGameTileLayoutData = require(GameTile.getGameTileLayoutData)
local getLayoutDataVideo = require(GameTile.getLayoutDataVideo)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags.FFlagLuaAppHomeMomentVideoFallback

local function useHasVideoThumbnailSelector(p: string, p2: string?): boolean
	local gameTileLayoutData = getGameTileLayoutData(useSelector(function(p3)
		return p3.Personalization[GameInfosReducer.key][p]
	end), p2)

	if not FFlagLuaAppHomeMomentVideoFallback then
		return (gameTileLayoutData and gameTileLayoutData.primaryMediaAsset and gameTileLayoutData.primaryMediaAsset.wideVideoAssetId) ~= nil
	end

	local layoutDataVideo = getLayoutDataVideo(gameTileLayoutData)
	return layoutDataVideo ~= nil and layoutDataVideo.assetId ~= nil
end

return useHasVideoThumbnailSelector
