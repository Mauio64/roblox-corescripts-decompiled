local GameInvite = script:FindFirstAncestor("GameInvite")
local parent = GameInvite.Parent
local getCustomizedInvitePromptUserId = require(script.Parent.getCustomizedInvitePromptUserId)
require(GameInvite.gameInviteModalType)

local SharedFlags = require(parent.SharedFlags)
local FFlagFixPromptGameInviteUIMissingDisplayName = SharedFlags.FFlagFixPromptGameInviteUIMissingDisplayName

return function(data, trigger, callback)
	local customizedInvitePromptUserId = getCustomizedInvitePromptUserId(data)

	local v, v2 = callback(trigger, customizedInvitePromptUserId)

	if not v then
		return nil
	end

	local v3 = { trigger = trigger }

	if FFlagFixPromptGameInviteUIMissingDisplayName and customizedInvitePromptUserId then
		v3.inviteUserId = customizedInvitePromptUserId
	end

	if not (v2 and data) then
		return v3
	end

	if data.InviteMessageId ~= "" then
		v3.inviteMessageId = data.InviteMessageId
	end

	if customizedInvitePromptUserId then
		v3.inviteUserId = customizedInvitePromptUserId
	end

	if data.PromptMessage ~= "" then
		v3.promptMessage = data.PromptMessage
	end

	if data.LaunchData ~= "" then
		v3.launchData = data.LaunchData
	end

	return v3
end
