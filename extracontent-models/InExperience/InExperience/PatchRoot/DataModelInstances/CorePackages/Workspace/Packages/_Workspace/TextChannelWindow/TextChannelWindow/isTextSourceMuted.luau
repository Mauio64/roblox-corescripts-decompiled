local Parent = script:FindFirstAncestor("TextChannelWindow").Parent
local ChatMute = require(Parent.ChatMute)

return function(p1) -- line: 8
	-- upvalues: ChatMute (copy)
	local str = tostring(p1.UserId)

	if ChatMute.isUserIdMuted(str) then
		return true
	end

	local PlayerByUserId = game:GetService("Players"):GetPlayerByUserId(p1.UserId)

	return PlayerByUserId ~= nil and (ChatMute.isUsernameMuted(PlayerByUserId.Name) or ChatMute.isDisplayNameMuted(PlayerByUserId.DisplayName))
end
