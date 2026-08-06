local Players = game:GetService("Players")

local function getDefaultAuthHeaders() -- line: 9
	-- upvalues: Players (copy)
	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer == nil then
		return {}
	end

	local str = tostring(LocalPlayer.UserId)

	return {
		["X-Roblox-User-Id"] = str,
		["Robloxctx-authenticated-userid"] = str
	}
end

return getDefaultAuthHeaders
