local createLazyComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Components.createLazyComponent
return {
	AppSquadEventReceiver = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/AppSquadEventReceiver")
	end),
	ScheduledSquadsListSheet = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/ScheduledSquads/ScheduledSquadsListSheet")
	end),
	ScheduledSquadsMoreInfoSheet = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/ScheduledSquads/ScheduledSquadsMoreInfoSheet")
	end),
	SquadComponentAccessWrapper = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadComponentAccessWrapper")
	end),
	SquadInviteFriends = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadInviteFriends")
	end),
	SquadJoinButton = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadJoinButton")
	end),
	SquadLobby = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby")
	end),
	SquadTopBanner = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadTopBanner")
	end),
	SquadVoiceAbuseReportScreen = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadVoiceAbuseReportScreen")
	end)
}
