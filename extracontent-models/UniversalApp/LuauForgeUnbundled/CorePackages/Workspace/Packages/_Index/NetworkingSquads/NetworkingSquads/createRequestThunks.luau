require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkingSquadTypes")

local createCreateOrJoinSquad = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createCreateOrJoinSquad")
local createGetSquadActive = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createGetSquadActive")

local createGetSquadFromSquadId = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createGetSquadFromSquadId")
local createJoinSquad = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createJoinSquad")
local createActOnPartyNudge = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createActOnPartyNudge")
local createLeaveSquad = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createLeaveSquad")
local createSquadInvite = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createSquadInvite")

local createCreateExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createCreateExperienceInvite")

local createGetExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createGetExperienceInvite")

local createVoteForExperienceInvite = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createVoteForExperienceInvite")

local createSendSquadVoiceAbuseReport = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createSendSquadVoiceAbuseReport")
local createReinviteToSquad = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createReinviteToSquad")

local createSetRegroupPromptShown = require("@game/CorePackages/Workspace/Packages/_Index/NetworkingSquads/NetworkingSquads/networkRequests/createSetRegroupPromptShown")

return function(p2)
	return {
		CreateOrJoinSquad = createCreateOrJoinSquad(p2),
		GetSquadActive = createGetSquadActive(p2),
		GetSquadFromSquadId = createGetSquadFromSquadId(p2),
		JoinSquad = createJoinSquad(p2),
		ActOnPartyNudge = createActOnPartyNudge(p2),
		LeaveSquad = createLeaveSquad(p2),
		SquadInvite = createSquadInvite(p2),
		CreateExperienceInvite = createCreateExperienceInvite(p2),
		GetExperienceInvite = createGetExperienceInvite(p2),
		VoteForExperienceInvite = createVoteForExperienceInvite(p2),
		ReinviteToSquad = createReinviteToSquad(p2),
		SendSquadVoiceAbuseReport = createSendSquadVoiceAbuseReport(p2),
		SetRegroupPromptShown = createSetRegroupPromptShown(p2)
	}
end
