local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("ScheduledSquadsListExpLayer", "")
local v4 = game:DefineFastString("ScheduledSquadsListChatLandingScreenEntrypointVariant", "enableTopBarEntrypoint")
local v5 = game:DefineFastFlag("EnableScheduledSquadsListExperimentation_dev", false)
local v6 = game:DefineFastFlag("EnableScheduledSquadsTopBarEntrypoint_dev", false)

local function getIsUserInTreatment(s1: string) -- line: 15
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v9 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v9 and v9[s1] ~= nil then
		return v9[s1]
	end

	return false
end

return {
	getIsTopBarEntrypointEnabled = function() -- line: 25
		-- upvalues: v6 (copy), v5 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v10 = v6

		if not v10 then
			v10 = v5

			if v10 then
				local v11 = v4
				local v12 = ExperimentCacheManager.default:getLayerVariables(v3)

				if v12 and v12[v11] ~= nil then
					return v12[v11]
				end

				v10 = false
			end
		end

		return v10
	end,
	logExposure = function() -- line: 33
		-- upvalues: v5 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v5 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
