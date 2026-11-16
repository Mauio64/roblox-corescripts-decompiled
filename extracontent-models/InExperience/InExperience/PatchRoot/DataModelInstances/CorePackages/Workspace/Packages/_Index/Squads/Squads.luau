require(script.Common.ModelTypes)

local Components = require(script.Components)
local Squads = {}
Squads.AppSquadEventReceiver = Components.AppSquadEventReceiver
Squads.Enums = require(script.Enums)
Squads.Logger = require(script.Logger)
local SquadInviteFriends = require(script.Components.SquadInviteFriends)
Squads.QuickStartSquadInviteFriendsContainer = SquadInviteFriends.QuickStartSquadInviteFriendsContainer
local ScheduledSquads = require(script.Components.ScheduledSquads)
Squads.ScheduledSquadSheet = ScheduledSquads.ScheduledSquadSheet
local Components2 = require(script.Components)
Squads.ScheduledSquadsListSheet = Components2.ScheduledSquadsListSheet
local Components3 = require(script.Components)
Squads.ScheduledSquadsMoreInfoSheet = Components3.ScheduledSquadsMoreInfoSheet
local Components4 = require(script.Components)
Squads.SquadComponentAccessWrapper = Components4.SquadComponentAccessWrapper
local SquadInviteFriends2 = require(script.Components.SquadInviteFriends)
Squads.SquadInviteFriends = SquadInviteFriends2.SquadInviteFriends
local SquadInviteFriends3 = require(script.Components.SquadInviteFriends)
Squads.SquadInviteFriendsContainer = SquadInviteFriends3.SquadInviteFriendsContainer
local SquadVoiceChangers = require(script.Components.SquadVoiceChangers)
Squads.SquadVoiceChangers = SquadVoiceChangers.SquadVoiceChangers
local SquadVoiceChangers2 = require(script.Components.SquadVoiceChangers)
Squads.SquadVoiceChangerOverlay = SquadVoiceChangers2.SquadVoiceChangerOverlay
local Components5 = require(script.Components)
Squads.SquadJoinButton = Components5.SquadJoinButton
local Components6 = require(script.Components)
Squads.SquadLobby = Components6.SquadLobby
local Components7 = require(script.Components)
Squads.SquadTopBanner = Components7.SquadTopBanner
local Components8 = require(script.Components)
Squads.SquadVoiceAbuseReportScreen = Components8.SquadVoiceAbuseReportScreen
Squads.Thunks = require(script.Thunks)
Squads.Hooks = {
	useCanAccessParty = require(script.Hooks.useCanAccessParty),
	useIsExperienceInvitePending = require(script.Hooks.useIsExperienceInvitePending)
}

Squads["jest.config"] = script["jest.config"]
return Squads
