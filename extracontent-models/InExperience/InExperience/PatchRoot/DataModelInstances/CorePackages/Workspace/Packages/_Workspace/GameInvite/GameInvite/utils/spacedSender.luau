local GameInvite = script:FindFirstAncestor("GameInvite")

local FIntGameInviteSendSpacing = require(GameInvite.Flags.FIntGameInviteSendSpacing)
local createSpacedSender = require(GameInvite.utils.createSpacedSender)

return createSpacedSender({
	minIntervalSeconds = FIntGameInviteSendSpacing / 1000,
	now = os.clock,
	delay = task.delay
})
