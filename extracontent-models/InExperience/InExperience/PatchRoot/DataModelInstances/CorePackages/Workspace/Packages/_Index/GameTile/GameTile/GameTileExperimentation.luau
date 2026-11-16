local parent = script:FindFirstAncestor("GameTile").Parent
local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("LuaAppGameTileMigrationExpLayer", "PlayerApp.HomePage.UX.TileLayer")
local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonTileIxp = SharedFlags.FFlagLuaAppUnifyPlayButtonTileIxp

local function getIsUserInTreatmentAndSendExposureLog(p: string) -- 2 equivalent calls inferred from this helper
	local v = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v, true)

	if not layerVariables or layerVariables[p] == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v)
	return layerVariables[p]
end

local function getIsTileMigrationEnabled()
	return getIsUserInTreatmentAndSendExposureLog("IsTileMigrationEnabled") -- inferred equivalent call
end

local getIsPlayButtonMigrationEnabled

if FFlagLuaAppUnifyPlayButtonTileIxp then
	getIsPlayButtonMigrationEnabled = FFlagLuaAppUnifyPlayButtonTileIxp and function()
		return getIsUserInTreatmentAndSendExposureLog("IsPlayButtonMigrationEnabled") -- inferred equivalent call
	end or nil
end

return {
	getIsTileMigrationEnabled = getIsTileMigrationEnabled,
	getIsPlayButtonMigrationEnabled = getIsPlayButtonMigrationEnabled
}
