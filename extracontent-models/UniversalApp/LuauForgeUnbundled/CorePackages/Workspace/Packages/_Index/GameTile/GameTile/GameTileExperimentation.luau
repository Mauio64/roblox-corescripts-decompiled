local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"LuaAppGameTileMigrationExpLayer",
	"PlayerApp.HomePage.UX.TileLayer"
)
local fFlagLuaAppUnifyPlayButtonTileIxp = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/SharedFlags").FFlagLuaAppUnifyPlayButtonTileIxp

local function getIsUserInTreatmentAndSendExposureLog(p2)
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables[p2] == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables[p2]
end

local function getIsTileMigrationEnabled()
	local v5 = defineFastString
	local layerVariables = experimentCacheManager.default:getLayerVariables(v5, true)

	if not layerVariables or layerVariables.IsTileMigrationEnabled == nil then
		return false
	end

	experimentCacheManager.default:sendCustomExposureLog(v5)
	return layerVariables.IsTileMigrationEnabled
end

local v6

if fFlagLuaAppUnifyPlayButtonTileIxp then
	v6 = fFlagLuaAppUnifyPlayButtonTileIxp and function()
		local v7 = defineFastString
		local layerVariables = experimentCacheManager.default:getLayerVariables(v7, true)

		if not layerVariables or layerVariables.IsPlayButtonMigrationEnabled == nil then
			return false
		end

		experimentCacheManager.default:sendCustomExposureLog(v7)
		return layerVariables.IsPlayButtonMigrationEnabled
	end or nil
end

return {
	getIsTileMigrationEnabled = getIsTileMigrationEnabled,
	getIsPlayButtonMigrationEnabled = v6
}
