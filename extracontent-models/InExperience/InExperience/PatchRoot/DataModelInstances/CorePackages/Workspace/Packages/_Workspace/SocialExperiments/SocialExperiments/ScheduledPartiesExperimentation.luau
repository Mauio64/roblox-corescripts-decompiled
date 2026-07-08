local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("ScheduledPartiesExpLayer", "Party.Schedule")
local v4 = game:DefineFastString("ScheduledPartiesTooltipVariant", "enableScheduledPartiesTooltip")
local v5 = game:DefineFastFlag("EnableScheduledSquadsTooltip", false)
local v6 = game:DefineFastFlag("EnableScheduledPartiesExperimentation", false)
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled

local function getIsUserInTreatment(s1: string) -- line: 13
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v10 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v10 and v10[s1] ~= nil then
		return v10[s1]
	end

	return false
end

return {
	getScheduledPartiesTooltipEnabled = function() -- line: 23
		-- upvalues: v5 (copy), v6 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy), GetFFlagIsSquadEnabled (copy)
		local v11 = v5

		if not v11 then
			v11 = v6

			if v11 then
				local v12 = v4
				local v13 = ExperimentCacheManager.default:getLayerVariables(v3)

				v11 = not not v13 and (v13[v12] ~= nil and v13[v12]) and GetFFlagIsSquadEnabled()
			end
		end

		return v11
	end,
	logExposure = function() -- line: 32
		-- upvalues: v6 (copy), ExperimentCacheManager (copy), v4 (copy)
		if v6 and ExperimentCacheManager.default:getLayerVariables(v4) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v4)
		end
	end
}
