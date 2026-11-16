local GameInviteConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/GameInviteConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

local gameMenuSet = { [GameInviteConstants.Triggers.GameMenu] = true }

local function shouldShowJoinCta(p2): boolean
	return gameMenuSet[p2.trigger] == true
end

return shouldShowJoinCta
