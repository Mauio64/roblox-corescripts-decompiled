local Players = game:GetService("Players")

return function()
	local localPlayer = Players.LocalPlayer
	return if localPlayer ~= nil then localPlayer.UserId else nil
end
