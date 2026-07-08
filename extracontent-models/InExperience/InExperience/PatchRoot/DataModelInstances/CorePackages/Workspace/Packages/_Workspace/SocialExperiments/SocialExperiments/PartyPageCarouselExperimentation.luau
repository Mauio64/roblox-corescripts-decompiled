local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("FStringPartyPageCarouselExpLayer", "Party.Coordination.UI")
local v4 = game:DefineFastString("PartyPageCarouselVariant", "enablePartyCoordinationUi")
local v5 = game:DefineFastFlag("ForceEnableSocialCarouselPartyPage5", false)
local v6 = game:DefineFastFlag("EnablePartyPageCarouselExperimentation4", false)

local function getIsUserInTreatment(s1: string) -- line: 13
	-- upvalues: ExperimentCacheManager (copy), v3 (copy)
	local v9 = ExperimentCacheManager.default:getLayerVariables(v3)

	if v9 and v9[s1] ~= nil then
		return v9[s1]
	end

	return false
end

return {
	getAppChatFormFactorEnabled = function() -- line: 28
		-- upvalues: v5 (copy), v6 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v13 = v5

		if not v13 then
			v13 = v6

			if v13 then
				local v14 = v4
				local v15 = ExperimentCacheManager.default:getLayerVariables(v3)

				if v15 and v15[v14] ~= nil then
					return v15[v14]
				end

				v13 = false
			end
		end

		return v13
	end,
	getPartyPageCarouselEnabled = function() -- line: 23
		-- upvalues: v5 (copy), v6 (copy), v4 (copy), ExperimentCacheManager (copy), v3 (copy)
		local v10 = v5

		if not v10 then
			v10 = v6

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
		-- upvalues: v6 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v6 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
