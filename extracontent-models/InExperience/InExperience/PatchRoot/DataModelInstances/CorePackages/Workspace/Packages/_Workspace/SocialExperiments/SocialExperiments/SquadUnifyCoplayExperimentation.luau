local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("SquadsUnifyCoplayExpLayer", "Party.Formation.Create.PartyNudge")
local v4 = game:DefineFastString("SquadsUnifyCoplayOneOnOnePartyCreationVariant", "enableOneOnOnePartyCreation")
local v5 = game:DefineFastString("SquadsUnifyCoplayMultiInvitePartyCreationVariant", "enableMultiInvitePartyCreation")
local v6 = game:DefineFastFlag("EnableSquadsUnifyCoplayOneOnOnePartyCreation_dev", false)
local v7 = game:DefineFastFlag("EnableSquadsUnifyCoplayMultiInvitePartyCreation_dev", false)
local v8 = game:DefineFastFlag("EnableSquadsUnifyCoplayExperimentation_dev", false)
local GetFFlagIsSquadEnabled = require(Parent.SharedFlags).GetFFlagIsSquadEnabled

local function getIsUserInTreatment(s1: string) -- line: 20
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v12 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v12 and v12[s1] ~= nil then
		return v12[s1]
	end

	return false
end

return {
	getOneOnOnePartyCreationEnabled = function() -- line: 30
		-- upvalues: v6 (copy), v8 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy), GetFFlagIsSquadEnabled (copy)
		local v13 = v6

		if not v13 then
			v13 = v8

			if v13 then
				local v14 = v4
				local v15 = ExperimentCacheManager.default:getLayerVariables(v3)

				v13 = not not v15 and (v15[v14] ~= nil and v15[v14]) and GetFFlagIsSquadEnabled()
			end
		end

		return v13
	end,
	getMultiInvitePartyCreationEnabled = function() -- line: 39
		-- upvalues: v7 (copy), v8 (copy), v5 (copy), ExperimentCacheManager (copy), v3 (copy), GetFFlagIsSquadEnabled (copy)
		local v16 = v7

		if not v16 then
			v16 = v8

			if v16 then
				local v17 = v5
				local v18 = ExperimentCacheManager.default:getLayerVariables(v3)

				v16 = not not v18 and (v18[v17] ~= nil and v18[v17]) and GetFFlagIsSquadEnabled()
			end
		end

		return v16
	end,
	logExposure = function() -- line: 48
		-- upvalues: v8 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v8 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
