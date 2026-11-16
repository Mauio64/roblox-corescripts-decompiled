local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteConstants = require(GameInvite.GameInviteConstants)
require(GameInvite.gameInviteModalType)

local gameMenuSet = { [GameInviteConstants.Triggers.GameMenu] = true }

local function shouldShowJoinCta(p): boolean
	return gameMenuSet[p.trigger] == true
end

return shouldShowJoinCta
