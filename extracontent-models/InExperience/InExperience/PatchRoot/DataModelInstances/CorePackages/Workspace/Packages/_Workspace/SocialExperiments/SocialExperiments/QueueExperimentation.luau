local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("FStringQueueExpLayer", "Party.Coordination.ExperienceJoin")
local v4 = game:DefineFastString("QueueEnableAutoJoinNewServerVariant", "enableAutoJoinNewServer")
local v5 = game:DefineFastString("QueueEnableJoinNewServerVariant", "enableJoinNewServerButton")
local v6 = game:DefineFastFlag("ForceEnableQueueAutoJoinNewServer2", false)
local v7 = game:DefineFastFlag("ForceEnableQueueJoinNewServerButton2", false)
local v8 = game:DefineFastFlag("EnableQueueExperimentation2", false) and game:GetEngineFeature("PlaceJoinStateEnabled")

local function getIsUserInTreatment(s1: string) -- line: 17
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v11 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v11 and v11[s1] ~= nil then
		return v11[s1]
	end

	return false
end

return {
	getIsJoinNewServerButtonEnabled = function() -- line: 32
		-- upvalues: v7 (copy), v8 (copy), v5 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v15 = v7

		if not v15 then
			v15 = v8

			if v15 then
				local v16 = v5
				local v17 = ExperimentCacheManager.default:getLayerVariables(v3)

				if v17 and v17[v16] ~= nil then
					return v17[v16]
				end

				v15 = false
			end
		end

		return v15
	end,
	getIsAutoJoinNewServerEnabled = function() -- line: 27
		-- upvalues: v6 (copy), v8 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v12 = v6

		if not v12 then
			v12 = v8

			if v12 then
				local v13 = v4
				local v14 = ExperimentCacheManager.default:getLayerVariables(v3)

				if v14 and v14[v13] ~= nil then
					return v14[v13]
				end

				v12 = false
			end
		end

		return v12
	end,
	isInExperiment = function() -- line: 37
		-- upvalues: v8 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v8 then
			return ExperimentCacheManager.default:getLayerVariables(v3) ~= nil
		end

		return false
	end,
	logExposure = function() -- line: 45
		-- upvalues: v8 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v8 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
