local Players = game:GetService("Players")

local function getDefaultAuthHeaders()
	local localPlayer = Players.LocalPlayer

	if localPlayer == nil then
		return {}
	end

	local userId = tostring(localPlayer.UserId)
	return {
		["X-Roblox-User-Id"] = userId,
		["Robloxctx-authenticated-userid"] = userId
	}
end

return getDefaultAuthHeaders
