local function v1(p1) -- line: 7
	local Humanoid = p1.Humanoid

	if not Humanoid then
		return false
	end

	for _, v5 in (Humanoid:GetAccessories()) do
		local MeshPart = v5:FindFirstChildWhichIsA("MeshPart")

		if MeshPart and MeshPart:FindFirstChild("HairAttachment") and MeshPart:FindFirstChildWhichIsA("WrapLayer") then
			return true
		end
	end

	return false
end

return function(p2) -- line: 33
	-- upvalues: v1 (copy)
	local CurrentCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return false
	end

	return (v1(CurrentCharacter))
end
