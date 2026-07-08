local Players = game:GetService("Players")

local function getLocalUserId(p1) -- line: 3
	-- upvalues: Players (copy)
	local LocalPlayer = (p1 or Players).LocalPlayer

	if LocalPlayer then
		return (tostring(LocalPlayer.UserId))
	end

	return nil
end

return getLocalUserId
