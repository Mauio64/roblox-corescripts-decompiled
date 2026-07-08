local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local SharedFlags = require(Parent.SharedFlags)
local v4 = game:DefineFastString("FStringSquadRegroupExpLayer", "Party.Coordination.UnifyCoplay")
local v5 = game:DefineFastString("SquadEnableRegroupVariant", "enableSquadRegroup")
local FFlagForceEnableSquadRegroup = SharedFlags.FFlagForceEnableSquadRegroup
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation

local function getIsUserInTreatment(s1: string) -- line: 14
	-- upvalues: ExperimentCacheManager (copy), v4 (copy)
	local v10 = ExperimentCacheManager.default:getLayerVariables(v4)

	if v10 and v10[s1] ~= nil then
		return v10[s1]
	end

	return false
end

return {
	getSquadRegroupEnabled = function() -- line: 24
		-- upvalues: FFlagForceEnableSquadRegroup (copy), FFlagEnableSquadRegroupExperimentation (copy), v5 (copy), ExperimentCacheManager (copy), v4 (copy)
		local v11 = FFlagForceEnableSquadRegroup

		if not v11 then
			v11 = FFlagEnableSquadRegroupExperimentation

			if v11 then
				local v12 = v5
				local v13 = ExperimentCacheManager.default:getLayerVariables(v4)

				if v13 and v13[v12] ~= nil then
					return v13[v12]
				end

				v11 = false
			end
		end

		return v11
	end,
	logExposure = function() -- line: 29
		-- upvalues: FFlagForceEnableSquadRegroup (copy), FFlagEnableSquadRegroupExperimentation (copy), ExperimentCacheManager (copy), v4 (copy)
		if not FFlagForceEnableSquadRegroup and (FFlagEnableSquadRegroupExperimentation and ExperimentCacheManager.default:getLayerVariables(v4) ~= nil) then
			ExperimentCacheManager.default:logLayerExposure(v4)
		end
	end
}
