local getCustomizedInvitePromptUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/utils/getCustomizedInvitePromptUserId")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/gameInviteModalType")

local fFlagFixPromptGameInviteUIMissingDisplayName = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/SharedFlags").FFlagFixPromptGameInviteUIMissingDisplayName

return function(data, p2, callback)
	local v5 = getCustomizedInvitePromptUserId(data)

	local v6, v7 = callback(p2, v5)

	if not v6 then
		return nil
	end

	local v8 = { trigger = p2 }

	if fFlagFixPromptGameInviteUIMissingDisplayName and v5 then
		v8.inviteUserId = v5
	end

	if not (v7 and data) then
		return v8
	end

	if data.InviteMessageId ~= "" then
		v8.inviteMessageId = data.InviteMessageId
	end

	if v5 then
		v8.inviteUserId = v5
	end

	if data.PromptMessage ~= "" then
		v8.promptMessage = data.PromptMessage
	end

	if data.LaunchData ~= "" then
		v8.launchData = data.LaunchData
	end

	return v8
end
