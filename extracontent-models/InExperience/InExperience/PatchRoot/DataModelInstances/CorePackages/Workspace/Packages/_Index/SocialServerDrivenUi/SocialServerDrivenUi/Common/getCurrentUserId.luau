local Players = game:GetService("Players")

local function getCurrentUserId()
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return nil
	end

	return (tostring(localPlayer.UserId))
end

return getCurrentUserId
