local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("SquadCoordinationUiExperimentLayer", "Party.Coordination.UI")
local v4 = game:DefineFastString("SquadEnablePartyCoordinationUiVariant", "enablePartyCoordinationUi")
local v5 = game:DefineFastFlag("ForceEnablePartyCoordinationUiChanges3", false)
local v6 = game:DefineFastFlag("PartyCoordinationUIExposureEnabled", false)

local function getIsUserInTreatment(s1: string) -- line: 14
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v9 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v9 and v9[s1] ~= nil then
		return v9[s1]
	end

	return false
end

return {
	getPartyCoordinationUiChangesEnabled = function() -- line: 24
		-- upvalues: v5 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v10 = v5

		if not v10 then
			local v11 = v4
			local v12 = ExperimentCacheManager.default:getLayerVariables(v3)

			if v12 and v12[v11] ~= nil then
				return v12[v11]
			end

			v10 = false
		end

		return v10
	end,
	logExposure = function() -- line: 29
		-- upvalues: v6 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v6 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end,
	isLogExposureEnabled = v6
}
