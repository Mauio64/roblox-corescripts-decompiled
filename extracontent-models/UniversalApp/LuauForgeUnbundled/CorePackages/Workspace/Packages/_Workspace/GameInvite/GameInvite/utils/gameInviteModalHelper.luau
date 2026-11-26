local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

function LUAUFORGE_MODULE_GLOBALS_diy_isTriggerDDI(p2): boolean
	return p2 == GameInviteConstants.Triggers.DeveloperSingle or p2 == GameInviteConstants.Triggers.DeveloperMultiple
end

function LUAUFORGE_MODULE_GLOBALS_diy_isTriggerGameMenu(p2): boolean
	return p2 == GameInviteConstants.Triggers.GameMenu
end

return {
	isTriggerDDI = LUAUFORGE_MODULE_GLOBALS_diy_isTriggerDDI,
	isTriggerGameMenu = LUAUFORGE_MODULE_GLOBALS_diy_isTriggerGameMenu
}
