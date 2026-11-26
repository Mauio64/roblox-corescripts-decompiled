local Players = game:GetService("Players")

return function()
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return nil
	end

	return localPlayer.UserId
end
