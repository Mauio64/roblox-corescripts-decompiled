local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteConstants = require(GameInvite.GameInviteConstants)

require(GameInvite.gameInviteModalType)

local getCustomizedInvitePromptUserId = require(script.Parent.getCustomizedInvitePromptUserId)

return function(p1) -- line: 7
	-- upvalues: getCustomizedInvitePromptUserId (copy), GameInviteConstants (copy)
	return getCustomizedInvitePromptUserId(p1) and GameInviteConstants.Triggers.DeveloperSingle or GameInviteConstants.Triggers.DeveloperMultiple
end
