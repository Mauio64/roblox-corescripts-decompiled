local gameInfosReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/GameInfosRodux").GameInfosReducer

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/RoactUtils").Hooks.RoactRodux.useSelector

local getGameTileLayoutData = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getGameTileLayoutData")
local getLayoutDataVideo = require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/getLayoutDataVideo")

local fFlagLuaAppHomeMomentVideoFallback = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppHomeMomentVideoFallback

local function useHasVideoThumbnailSelector(p2, p3): boolean
	local v6 = getGameTileLayoutData(useSelector(function(p4)
		return p4.Personalization[gameInfosReducer.key][p2]
	end), p3)

	if not fFlagLuaAppHomeMomentVideoFallback then
		return (v6 and v6.primaryMediaAsset and v6.primaryMediaAsset.wideVideoAssetId) ~= nil
	end

	local v7 = getLayoutDataVideo(v6)
	return v7 ~= nil and v7.assetId ~= nil
end

return useHasVideoThumbnailSelector
