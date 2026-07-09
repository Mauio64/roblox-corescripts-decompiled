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

return function(p1) -- line: 25
	-- upvalues: createCreateOrJoinSquad (copy), createGetSquadActive (copy), createGetSquadFromSquadId (copy), createJoinSquad (copy), createActOnPartyNudge (copy), createLeaveSquad (copy), createSquadInvite (copy), createCreateExperienceInvite (copy), createGetExperienceInvite (copy), createVoteForExperienceInvite (copy), createReinviteToSquad (copy), createSendSquadVoiceAbuseReport (copy), createSetRegroupPromptShown (copy)
	return {
		CreateOrJoinSquad = createCreateOrJoinSquad(p1),
		GetSquadActive = createGetSquadActive(p1),
		GetSquadFromSquadId = createGetSquadFromSquadId(p1),
		JoinSquad = createJoinSquad(p1),
		ActOnPartyNudge = createActOnPartyNudge(p1),
		LeaveSquad = createLeaveSquad(p1),
		SquadInvite = createSquadInvite(p1),
		CreateExperienceInvite = createCreateExperienceInvite(p1),
		GetExperienceInvite = createGetExperienceInvite(p1),
		VoteForExperienceInvite = createVoteForExperienceInvite(p1),
		ReinviteToSquad = createReinviteToSquad(p1),
		SendSquadVoiceAbuseReport = createSendSquadVoiceAbuseReport(p1),
		SetRegroupPromptShown = createSetRegroupPromptShown(p1)
	}
end
