local Players = game:GetService("Players")

local function respawnAvatar(p1: ((...any) -> ...any)) -- line: 9
	-- upvalues: Players (copy)
	local v4, v5 = p1()

	if not v4 then
		return
	end

	if v5 then
		v5:Fire()

		return
	end

	local LocalPlayer = Players.LocalPlayer

	if LocalPlayer then
		local Character = LocalPlayer.Character

		if Character then
			local Humanoid = Character:FindFirstChild("Humanoid")

			if Humanoid and Humanoid:IsA("Humanoid") then
				Humanoid.Health = 0
			end
		end
	end
end

return respawnAvatar
