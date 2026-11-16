local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("SquadsUnifyCoplayExpLayer", "Party.Formation.Create.PartyNudge")

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
local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled

local function getIsUserInTreatment(defineFastString4: string) -- 2 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString4] ~= nil then
		return layerVariables[defineFastString4]
	end

	return false
end

local SquadUnifyCoplayExperimentation = {}

function SquadUnifyCoplayExperimentation.getOneOnOnePartyCreationEnabled()
	local oneOnOnePartyCreationEnabled = defineFastFlag

	if not oneOnOnePartyCreationEnabled then
		oneOnOnePartyCreationEnabled = defineFastFlag3
			and getIsUserInTreatment(defineFastString2) -- inferred equivalent call
			and GetFFlagIsSquadEnabled()
	end

	return oneOnOnePartyCreationEnabled
end

function SquadUnifyCoplayExperimentation.getMultiInvitePartyCreationEnabled()
	local multiInvitePartyCreationEnabled = defineFastFlag2

	if not multiInvitePartyCreationEnabled then
		multiInvitePartyCreationEnabled = defineFastFlag3
			and getIsUserInTreatment(defineFastString3) -- inferred equivalent call
			and GetFFlagIsSquadEnabled()
	end

	return multiInvitePartyCreationEnabled
end

function SquadUnifyCoplayExperimentation.logExposure()
	if defineFastFlag3 and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return SquadUnifyCoplayExperimentation
