local Players = game:GetService("Players")

local function getPlayerFromPart(p1) -- line: 4
	-- upvalues: Players (copy)
	if not p1 then
		return nil
	end

	for _, player in pairs(Players:GetPlayers()) do
		local Character = player.Character

		if Character and p1:IsDescendantOf(Character) then
			return player
		end
	end

	return nil
end

return getPlayerFromPart
