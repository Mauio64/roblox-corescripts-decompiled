local Players = game:GetService("Players")

local function computeImpactedUserCount(p2, p3)
	if not (p2 and p2.participants) then
		return 0
	end

	local playerByUserId = Players:GetPlayerByUserId((tonumber(p3)))

	if not (playerByUserId and playerByUserId.Character and playerByUserId.Character.PrimaryPart) then
		return 0
	end

	local position = playerByUserId.Character.PrimaryPart.Position
	local count = 0

	for k in pairs(p2.participants) do
		local v5 = tonumber(k)

		if not (v5 and v5 ~= playerByUserId.UserId) then
			continue
		end

		local playerByUserId2 = Players:GetPlayerByUserId(v5)

		if not (playerByUserId2 and playerByUserId2.Character and playerByUserId2.Character.PrimaryPart and (playerByUserId2.Character.PrimaryPart.Position - position).Magnitude <= 160) then
			continue
		end

		count += 1
	end

	return count
end

return computeImpactedUserCount
