local Parent = script:FindFirstAncestor("GameTile").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("LuaAppGameTileMigrationExpLayer", "PlayerApp.HomePage.UX.TileLayer")
local FFlagLuaAppUnifyPlayButtonTileIxp = require(Parent.SharedFlags).FFlagLuaAppUnifyPlayButtonTileIxp

local function getIsUserInTreatmentAndSendExposureLog(s1: string) -- line: 9
	-- upvalues: v3 (copy), ExperimentCacheManager (copy)
	local v7 = v3
	local v8 = ExperimentCacheManager.default:getLayerVariables(v7, true)

	if v8 and v8[s1] ~= nil then
		ExperimentCacheManager.default:sendCustomExposureLog(v7)

		return v8[s1]
	end

	return false
end

return {
	getIsTileMigrationEnabled = function() -- line: 21
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v9 = v3
		local v10 = ExperimentCacheManager.default:getLayerVariables(v9, true)

		if v10 and v10.IsTileMigrationEnabled ~= nil then
			ExperimentCacheManager.default:sendCustomExposureLog(v9)

			return v10.IsTileMigrationEnabled
		end

		return false
	end,
	getIsPlayButtonMigrationEnabled = if not FFlagLuaAppUnifyPlayButtonTileIxp then nil else if not FFlagLuaAppUnifyPlayButtonTileIxp then nil else function() -- line: 26
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v11 = v3
		local v12 = ExperimentCacheManager.default:getLayerVariables(v11, true)

		if v12 and v12.IsPlayButtonMigrationEnabled ~= nil then
			ExperimentCacheManager.default:sendCustomExposureLog(v11)

			return v12.IsPlayButtonMigrationEnabled
		end

		return false
	end
}
