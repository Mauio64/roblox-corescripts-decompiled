local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"SquadsUnifyCoplayExpLayer",
	"Party.Formation.Create.PartyNudge"
)

local defineFastString2 = game:DefineFastString(
	"SquadsUnifyCoplayOneOnOnePartyCreationVariant",
	"enableOneOnOnePartyCreation"
)

local defineFastString3 = game:DefineFastString(
	"SquadsUnifyCoplayMultiInvitePartyCreationVariant",
	"enableMultiInvitePartyCreation"
)

local defineFastFlag = game:DefineFastFlag("EnableSquadsUnifyCoplayOneOnOnePartyCreation_dev", false)

local defineFastFlag2 = game:DefineFastFlag("EnableSquadsUnifyCoplayMultiInvitePartyCreation_dev", false)

local defineFastFlag3 = game:DefineFastFlag("EnableSquadsUnifyCoplayExperimentation_dev", false)
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SharedFlags").GetFFlagIsSquadEnabled

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getOneOnOnePartyCreationEnabled = function()
		local oneOnOnePartyCreationEnabled = defineFastFlag

		if oneOnOnePartyCreationEnabled then
			return oneOnOnePartyCreationEnabled
		end

		oneOnOnePartyCreationEnabled = defineFastFlag3

		if oneOnOnePartyCreationEnabled then
			local v5 = defineFastString2
			local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

			oneOnOnePartyCreationEnabled = (if layerVariables and layerVariables[v5] ~= nil then layerVariables[v5] else false)
				and getFFlagIsSquadEnabled()
		end

		return oneOnOnePartyCreationEnabled
	end,
	getMultiInvitePartyCreationEnabled = function()
		local multiInvitePartyCreationEnabled = defineFastFlag2

		if multiInvitePartyCreationEnabled then
			return multiInvitePartyCreationEnabled
		end

		multiInvitePartyCreationEnabled = defineFastFlag3

		if multiInvitePartyCreationEnabled then
			local v5 = defineFastString3
			local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

			multiInvitePartyCreationEnabled = (if layerVariables and layerVariables[v5] ~= nil then layerVariables[v5] else false)
				and getFFlagIsSquadEnabled()
		end

		return multiInvitePartyCreationEnabled
	end,
	logExposure = function()
		if
			defineFastFlag3
			and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
		then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
