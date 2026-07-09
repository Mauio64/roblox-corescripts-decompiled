local Players = game:GetService("Players")

local function computeImpactedUserCount(p1, s1: string) -- line: 11
	-- upvalues: Players (copy)
	if not p1 or not p1.participants then
		return 0
	end

	local PlayerByUserId = Players:GetPlayerByUserId((tonumber(s1)))

	if not PlayerByUserId or not PlayerByUserId.Character or not PlayerByUserId.Character.PrimaryPart then
		return 0
	end

	local PrimaryPartPosition = PlayerByUserId.Character.PrimaryPart.Position
	local n1 = 0

	for k in pairs(p1.participants) do
		local num = tonumber(k)

		if num and num ~= PlayerByUserId.UserId then
			local PlayerByUserId2 = Players:GetPlayerByUserId(num)

			if PlayerByUserId2 and PlayerByUserId2.Character and PlayerByUserId2.Character.PrimaryPart and (PlayerByUserId2.Character.PrimaryPart.Position - PrimaryPartPosition).Magnitude <= 160 then
				n1 += 1
			end
		end
	end

	return n1
end

return computeImpactedUserCount
