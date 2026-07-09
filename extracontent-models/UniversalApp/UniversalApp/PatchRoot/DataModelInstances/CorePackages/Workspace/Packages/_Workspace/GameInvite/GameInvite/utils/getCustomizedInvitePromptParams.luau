local GameInvite = script:FindFirstAncestor("GameInvite")
local getCustomizedInvitePromptUserId = require(script.Parent.getCustomizedInvitePromptUserId)

require(GameInvite.gameInviteModalType)

return function(p1, p2, p3: ((...any) -> ...any)) -- line: 8
	-- upvalues: getCustomizedInvitePromptUserId (copy)
	local v6 = getCustomizedInvitePromptUserId(p1)
	local v7, v8 = p3(p2, v6)

	if not v7 then
		return nil
	end

	local t1 = {
		trigger = p2
	}

	if v8 and p1 then
		if p1.InviteMessageId ~= "" then
			t1.inviteMessageId = p1.InviteMessageId
		end

		if v6 then
			t1.inviteUserId = v6
		end

		if p1.PromptMessage ~= "" then
			t1.promptMessage = p1.PromptMessage
		end

		if p1.LaunchData ~= "" then
			t1.launchData = p1.LaunchData
		end
	end

	return t1
end
