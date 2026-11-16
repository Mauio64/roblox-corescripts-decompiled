require(script.Parent.networkingSquadTypes)

local networkRequests = script.Parent.networkRequests
local createCreateOrJoinSquad = require(networkRequests.createCreateOrJoinSquad)
local createGetSquadActive = require(networkRequests.createGetSquadActive)

local createGetSquadFromSquadId = require(networkRequests.createGetSquadFromSquadId)
local createJoinSquad = require(networkRequests.createJoinSquad)
local createActOnPartyNudge = require(networkRequests.createActOnPartyNudge)
local createLeaveSquad = require(networkRequests.createLeaveSquad)
local createSquadInvite = require(networkRequests.createSquadInvite)

local createCreateExperienceInvite = require(networkRequests.createCreateExperienceInvite)

local createGetExperienceInvite = require(networkRequests.createGetExperienceInvite)

local createVoteForExperienceInvite = require(networkRequests.createVoteForExperienceInvite)

local createSendSquadVoiceAbuseReport = require(networkRequests.createSendSquadVoiceAbuseReport)
local createReinviteToSquad = require(networkRequests.createReinviteToSquad)

local createSetRegroupPromptShown = require(networkRequests.createSetRegroupPromptShown)

return function(p)
	return {
		CreateOrJoinSquad = createCreateOrJoinSquad(p),
		GetSquadActive = createGetSquadActive(p),
		GetSquadFromSquadId = createGetSquadFromSquadId(p),
		JoinSquad = createJoinSquad(p),
		ActOnPartyNudge = createActOnPartyNudge(p),
		LeaveSquad = createLeaveSquad(p),
		SquadInvite = createSquadInvite(p),
		CreateExperienceInvite = createCreateExperienceInvite(p),
		GetExperienceInvite = createGetExperienceInvite(p),
		VoteForExperienceInvite = createVoteForExperienceInvite(p),
		ReinviteToSquad = createReinviteToSquad(p),
		SendSquadVoiceAbuseReport = createSendSquadVoiceAbuseReport(p),
		SetRegroupPromptShown = createSetRegroupPromptShown(p)
	}
end
