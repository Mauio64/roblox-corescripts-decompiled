local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local SharedFlags = require(Parent.SharedFlags)
local v4 = game:DefineFastString("ArgoPartyLayer", "Social.ConnectTab")
local v5 = game:DefineFastString("ArgoPartyVariant", "enableArgoPartyChanges")
local v6 = game:DefineFastFlag("ForceEnableArgoPartyChanges7", false)
local v7 = game:DefineFastFlag("EnableArgoPartyExperimentation7", false)
local FFlagAppChatRenameGuacPolicyEnabled = SharedFlags.FFlagAppChatRenameGuacPolicyEnabled

local function getIsUserInTreatment(s1: string) -- line: 14
	-- upvalues: ExperimentCacheManager (copy), v4 (copy)
	local v11 = ExperimentCacheManager.default:getLayerVariables(v4)

	if v11 and v11[s1] ~= nil then
		return v11[s1]
	end

	return false
end

return {
	getIsRenameEnabled = function() -- line: 24
		-- upvalues: v6 (copy), v7 (copy), FFlagAppChatRenameGuacPolicyEnabled (copy), v5 (copy), ExperimentCacheManager (copy), v4 (copy)
		local v12 = v6

		if not v12 then
			v12 = v7

			if v12 then
				v12 = FFlagAppChatRenameGuacPolicyEnabled

				if v12 then
					local v13 = v5
					local v14 = ExperimentCacheManager.default:getLayerVariables(v4)

					if v14 and v14[v13] ~= nil then
						return v14[v13]
					end

					v12 = false
				end
			end
		end

		return v12
	end
}
