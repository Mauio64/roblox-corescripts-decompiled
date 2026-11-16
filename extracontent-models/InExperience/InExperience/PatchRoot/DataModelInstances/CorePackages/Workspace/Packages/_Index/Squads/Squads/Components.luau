local parent = script:FindFirstAncestor("Squads").Parent

local RoactUtils = require(parent.RoactUtils)
local createLazyComponent = RoactUtils.Components.createLazyComponent
return {
	AppSquadEventReceiver = createLazyComponent(function()
		local AppSquadEventReceiver = require(script.AppSquadEventReceiver)
		return AppSquadEventReceiver
	end),
	ScheduledSquadsListSheet = createLazyComponent(function()
		local ScheduledSquadsListSheet = require(script.ScheduledSquads.ScheduledSquadsListSheet)
		return ScheduledSquadsListSheet
	end),
	ScheduledSquadsMoreInfoSheet = createLazyComponent(function()
		local ScheduledSquadsMoreInfoSheet = require(script.ScheduledSquads.ScheduledSquadsMoreInfoSheet)
		return ScheduledSquadsMoreInfoSheet
	end),
	SquadComponentAccessWrapper = createLazyComponent(function()
		local SquadComponentAccessWrapper = require(script.SquadComponentAccessWrapper)
		return SquadComponentAccessWrapper
	end),
	SquadInviteFriends = createLazyComponent(function()
		local SquadInviteFriends = require(script.SquadInviteFriends)
		return SquadInviteFriends
	end),
	SquadJoinButton = createLazyComponent(function()
		local SquadJoinButton = require(script.SquadJoinButton)
		return SquadJoinButton
	end),
	SquadLobby = createLazyComponent(function()
		local SquadLobby = require(script.SquadLobby)
		return SquadLobby
	end),
	SquadTopBanner = createLazyComponent(function()
		local SquadTopBanner = require(script.SquadTopBanner)
		return SquadTopBanner
	end),
	SquadVoiceAbuseReportScreen = createLazyComponent(function()
		local SquadVoiceAbuseReportScreen = require(script.SquadVoiceAbuseReportScreen)
		return SquadVoiceAbuseReportScreen
	end)
}
