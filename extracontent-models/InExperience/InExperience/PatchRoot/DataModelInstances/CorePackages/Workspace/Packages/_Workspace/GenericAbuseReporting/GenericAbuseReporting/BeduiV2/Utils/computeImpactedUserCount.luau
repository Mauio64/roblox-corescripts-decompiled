local Players = game:GetService("Players")

local function computeImpactedUserCount(p, p2: string)
	if not (p and p.participants) then
		return 0
	end

	local playerByUserId = Players:GetPlayerByUserId((tonumber(p2)))

	if not (playerByUserId and playerByUserId.Character and playerByUserId.Character.PrimaryPart) then
		return 0
	end

	local position = playerByUserId.Character.PrimaryPart.Position
	local count = 0

	for k in pairs(p.participants) do
		local v = tonumber(k)

		if not (v and v ~= playerByUserId.UserId) then
			continue
		end

		local playerByUserId2 = Players:GetPlayerByUserId(v)

		if not (playerByUserId2 and playerByUserId2.Character and playerByUserId2.Character.PrimaryPart and (playerByUserId2.Character.PrimaryPart.Position - position).Magnitude <= 160) then
			continue
		end

		count += 1
	end

	return count
end

return computeImpactedUserCount
