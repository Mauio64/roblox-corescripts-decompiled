local Players = game:GetService("Players")

local function respawnAvatar(callback)
	local v, v2 = callback()

	if not v then
		return
	end

	if v2 then
		v2:Fire()
		return
	end

	local localPlayer = Players.LocalPlayer

	local character = localPlayer and localPlayer.Character

	if character then
		local humanoid = character:FindFirstChild("Humanoid")

		if humanoid and humanoid:IsA("Humanoid") then
			humanoid.Health = 0
		end
	end
end

return respawnAvatar
