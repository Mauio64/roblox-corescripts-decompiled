local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(p): boolean
	if LocalPlayer and LocalPlayer.UserId % 10000 < p then
		return true
	end

	return false
end
