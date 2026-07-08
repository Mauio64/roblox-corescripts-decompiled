local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Constants = require(Modules.Settings.Pages.ShareGame.Constants)

return function(p1, p2: ((...any) -> ...any)) -- line: 9
	-- upvalues: Constants (copy)
	local v5 = if not p1 or p1.InviteUser == 0 then nil else p1.InviteUser
	local v6, v7 = p2(if not v5 then Constants.Triggers.DeveloperMultiple else Constants.Triggers.DeveloperSingle, v5)

	if not v6 then
		return nil
	end

	local t1 = {}

	if v7 and p1 then
		if p1.InviteMessageId ~= "" then
			t1.inviteMessageId = p1.InviteMessageId
		end

		if p1.InviteUser ~= 0 then
			t1.inviteUserId = p1.InviteUser
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
