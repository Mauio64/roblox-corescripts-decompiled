local CurrentExperienceInviteUpdated = require(script.CurrentExperienceInviteUpdated)
local CurrentExperienceInviteDismissed = require(script.CurrentExperienceInviteDismissed)
local CurrentExperienceInviteReceived = require(script.CurrentExperienceInviteReceived)
local CurrentExperienceInviteStatusUpdated = require(script.CurrentExperienceInviteStatusUpdated)
local CurrentSquadUpdated = require(script.CurrentSquadUpdated)
local PartialSquadAdded = require(script.PartialSquadAdded)
local PartialSquadRemoved = require(script.PartialSquadRemoved)
local SelfPermissionUpdated = require(script.SelfPermissionUpdated)

return {
	CurrentExperienceInviteUpdated = CurrentExperienceInviteUpdated,
	CurrentExperienceInviteDismissed = CurrentExperienceInviteDismissed,
	CurrentExperienceInviteReceived = CurrentExperienceInviteReceived,
	CurrentExperienceInviteStatusUpdated = CurrentExperienceInviteStatusUpdated,
	CurrentSquadUpdated = CurrentSquadUpdated,
	PartialSquadAdded = PartialSquadAdded,
	PartialSquadRemoved = PartialSquadRemoved,
	SelfPermissionUpdated = SelfPermissionUpdated
}
