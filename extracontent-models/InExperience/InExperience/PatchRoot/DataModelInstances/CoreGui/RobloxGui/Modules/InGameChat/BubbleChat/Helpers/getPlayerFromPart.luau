local Players = game:GetService("Players")

local function getPlayerFromPart(instance)
	if not instance then
		return nil
	end

	for _, v in pairs(Players:GetPlayers()) do
		local character = v.Character

		if character and instance:IsDescendantOf(character) then
			return v
		end
	end

	return nil
end

return getPlayerFromPart
