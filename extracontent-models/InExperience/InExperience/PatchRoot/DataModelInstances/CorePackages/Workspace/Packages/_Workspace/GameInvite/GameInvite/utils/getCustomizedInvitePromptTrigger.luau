local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteConstants = require(GameInvite.GameInviteConstants)
require(GameInvite.gameInviteModalType)

local getCustomizedInvitePromptUserId = require(script.Parent.getCustomizedInvitePromptUserId)

return function(p)
	return getCustomizedInvitePromptUserId(p) and GameInviteConstants.Triggers.DeveloperSingle
		or GameInviteConstants.Triggers.DeveloperMultiple
end
