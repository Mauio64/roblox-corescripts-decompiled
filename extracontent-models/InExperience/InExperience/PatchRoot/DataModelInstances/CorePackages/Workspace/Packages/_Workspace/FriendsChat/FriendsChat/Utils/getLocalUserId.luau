local Players = game:GetService("Players")

local function getLocalUserId()
	local localPlayer = Players.LocalPlayer

	return if localPlayer ~= nil then localPlayer.UserId else nil
end

return getLocalUserId
