local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

local getCustomizedInvitePromptUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/getCustomizedInvitePromptUserId")

return function(p2)
	return getCustomizedInvitePromptUserId(p2) and GameInviteConstants.Triggers.DeveloperSingle or GameInviteConstants.Triggers.DeveloperMultiple
end
