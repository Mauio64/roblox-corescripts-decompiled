local function fn(currentCharacter): boolean
	local humanoid = currentCharacter.Humanoid

	if not humanoid then
		return false
	end

	local accessories = humanoid:GetAccessories()

	for k, accessory in accessories do
		local meshPart = accessory:FindFirstChildWhichIsA("MeshPart")

		if
			meshPart
			and meshPart:FindFirstChild("HairAttachment")
			and meshPart:FindFirstChildWhichIsA("WrapLayer")
		then
			return true
		end
	end

	return false
end

return function(p2)
	local currentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if currentCharacter then
		return fn(currentCharacter)
	end

	return false
end
