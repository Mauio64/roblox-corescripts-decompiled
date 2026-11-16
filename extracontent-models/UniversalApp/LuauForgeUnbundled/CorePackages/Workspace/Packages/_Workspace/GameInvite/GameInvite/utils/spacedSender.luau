local FIntGameInviteSendSpacing = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Flags/FIntGameInviteSendSpacing")
return require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/createSpacedSender")({
	minIntervalSeconds = FIntGameInviteSendSpacing / 1000,
	now = os.clock,
	delay = task.delay
})
