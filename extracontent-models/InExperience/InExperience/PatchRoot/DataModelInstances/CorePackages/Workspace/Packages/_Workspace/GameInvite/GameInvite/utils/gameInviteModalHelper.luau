local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteConstants = require(GameInvite.GameInviteConstants)
require(GameInvite.gameInviteModalType)

function isTriggerDDI(p): boolean
	return p == GameInviteConstants.Triggers.DeveloperSingle or p == GameInviteConstants.Triggers.DeveloperMultiple
end

function isTriggerGameMenu(p): boolean
	return p == GameInviteConstants.Triggers.GameMenu
end

return { isTriggerDDI = isTriggerDDI, isTriggerGameMenu = isTriggerGameMenu }
