local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteConstants = require(GameInvite.GameInviteConstants)

require(GameInvite.gameInviteModalType)

function isTriggerDDI(p1) -- line: 5
	-- upvalues: GameInviteConstants (copy)
	return p1 == GameInviteConstants.Triggers.DeveloperSingle or p1 == GameInviteConstants.Triggers.DeveloperMultiple
end
function isTriggerGameMenu(p2) -- line: 9
	-- upvalues: GameInviteConstants (copy)
	return p2 == GameInviteConstants.Triggers.GameMenu
end

return {
	isTriggerDDI = isTriggerDDI,
	isTriggerGameMenu = isTriggerGameMenu
}
