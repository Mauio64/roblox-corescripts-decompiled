local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local SharedFlags = require(Parent.SharedFlags)
local v4 = game:DefineFastString("ArgoPartyLayer", "Social.ConnectTab")
local v5 = game:DefineFastString("ArgoPartyVariant", "enableArgoPartyChanges")
local v6 = game:DefineFastFlag("ForceEnableArgoPartyChanges7", false)
local v7 = game:DefineFastFlag("EnableArgoPartyExperimentation7", false)
local FFlagAppChatRenameGuacPolicyEnabled = SharedFlags.FFlagAppChatRenameGuacPolicyEnabled
local v9 = game:DefineFastFlag("EnableArgoPartyChanges", false)

local function getIsUserInTreatment(s1: string) -- line: 15
	-- upvalues: ExperimentCacheManager (copy), v4 (copy)
	local v12 = ExperimentCacheManager.default:getLayerVariables(v4)

	if v12 and v12[s1] ~= nil then
		return v12[s1]
	end

	return false
end

return {
	getIsRenameEnabled = function() -- line: 25
		-- upvalues: v6 (copy), v9 (copy), FFlagAppChatRenameGuacPolicyEnabled (copy), v7 (copy), v5 (copy), ExperimentCacheManager (copy), v4 (copy)
		local v13 = v6

		if not v13 then
			if v9 then
				v13 = FFlagAppChatRenameGuacPolicyEnabled

				if v13 then
					return v13
				end
			end

			v13 = v7

			if v13 then
				v13 = FFlagAppChatRenameGuacPolicyEnabled

				if v13 then
					local v14 = v5
					local v15 = ExperimentCacheManager.default:getLayerVariables(v4)

					if v15 and v15[v14] ~= nil then
						return v15[v14]
					end

					v13 = false
				end
			end
		end

		return v13
	end
}
