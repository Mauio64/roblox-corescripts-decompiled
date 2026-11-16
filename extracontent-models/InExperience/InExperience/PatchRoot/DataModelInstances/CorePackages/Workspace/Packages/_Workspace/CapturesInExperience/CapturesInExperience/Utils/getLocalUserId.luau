local Players = game:GetService("Players")

local function getLocalUserId(p)
	local localPlayer = (p or Players).LocalPlayer

	if localPlayer then
		return (tostring(localPlayer.UserId))
	end

	return nil
end

return getLocalUserId
