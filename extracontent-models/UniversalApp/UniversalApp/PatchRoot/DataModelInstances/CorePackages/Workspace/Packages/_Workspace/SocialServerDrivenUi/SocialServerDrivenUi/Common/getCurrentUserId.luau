local Players = game:GetService("Players")

local function getCurrentUserId() -- line: 7
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return nil
	end

	return (tostring(LocalPlayer.UserId))
end

return getCurrentUserId
