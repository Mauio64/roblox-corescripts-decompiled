local parent = script:FindFirstAncestor("TextChannelWindow").Parent
local ChatMute = require(parent.ChatMute)

return function(p)
	local userId = tostring(p.UserId)

	if ChatMute.isUserIdMuted(userId) then
		return true
	end

	local Players = game:GetService("Players")
	local playerByUserId = Players:GetPlayerByUserId(p.UserId)
	return playerByUserId ~= nil
		and (ChatMute.isUsernameMuted(playerByUserId.Name) or ChatMute.isDisplayNameMuted(playerByUserId.DisplayName))
end
