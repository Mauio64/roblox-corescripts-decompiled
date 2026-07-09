local Players = game:GetService("Players")

game:DefineFastString("AXCommunityAvatarsEntryPointWhiteList", "")

return function() -- line: 5
	-- upvalues: Players (copy)
	local v2 = game:GetFastString("AXCommunityAvatarsEntryPointWhiteList") or ""
	local v3 = string.split(v2, ",") or {}
	local str = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId or 0)

	return table.find(v3, str) ~= nil
end
