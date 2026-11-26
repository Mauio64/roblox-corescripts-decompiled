local Players = game:GetService("Players")

game:DefineFastString("AXCommunityAvatarsEntryPointWhiteList", "")

return function(): boolean
	local fastString = game:GetFastString("AXCommunityAvatarsEntryPointWhiteList") or ""
	local v5 = string.split(fastString, ",") or {}
	local userId = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)

	return table.find(v5, userId) ~= nil
end
