local Players = game:GetService("Players")

local function getLocalUserId() -- line: 14
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return nil
	end

	return LocalPlayer.UserId
end

return getLocalUserId
