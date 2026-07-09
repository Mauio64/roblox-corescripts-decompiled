local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("SquadCoordinationExperienceJoinExperimentLayer", "Party.Coordination.ExperienceJoin")
local v4 = game:DefineFastFlag("IsSquadCoordinationExperienceJoinExperimentExposureEnabled", false)
local v5 = game:DefineFastFlag("IsSquadLobbySessionEnabled", false)

local function getIsUserInTreatment(s1: string) -- line: 12
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v8 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v8 and v8[s1] ~= nil then
		return v8[s1]
	end

	return false
end

return {
	getIsSquadLobbySessionEnabled = function() -- line: 23
		-- upvalues: v5 (copy)
		return v5
	end,
	getShouldOpenSLPFromExpPickerEnabled = function() -- line: 27
		-- upvalues: ExperimentCacheManager (copy), v3 (copy)
		local v9 = ExperimentCacheManager.default:getLayerVariables(v3)

		if v9 and v9.ShouldOpenSLPFromExpPickerEnabled ~= nil then
			return v9.ShouldOpenSLPFromExpPickerEnabled
		end

		return false
	end,
	getShouldShowFTUXOnExpPickerEnabled = function() -- line: 31
		-- upvalues: ExperimentCacheManager (copy), v3 (copy)
		local v10 = ExperimentCacheManager.default:getLayerVariables(v3)

		if v10 and v10.ShouldShowFTUXOnExpPickerEnabled ~= nil then
			return v10.ShouldShowFTUXOnExpPickerEnabled
		end

		return false
	end,
	getIsSearchIconOnExpPickerEnabled = function() -- line: 35
		-- upvalues: ExperimentCacheManager (copy), v3 (copy)
		local v11 = ExperimentCacheManager.default:getLayerVariables(v3)

		if v11 and v11.IsSearchIconOnExpPickerEnabled ~= nil then
			return v11.IsSearchIconOnExpPickerEnabled
		end

		return false
	end,
	getIsNewTooltipCopyEnabled = function() -- line: 39
		-- upvalues: ExperimentCacheManager (copy), v3 (copy)
		local v12 = ExperimentCacheManager.default:getLayerVariables(v3)

		if v12 and v12.IsNewTooltipCopyEnabled ~= nil then
			return v12.IsNewTooltipCopyEnabled
		end

		return false
	end,
	logExposure = function() -- line: 43
		-- upvalues: v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v4 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
