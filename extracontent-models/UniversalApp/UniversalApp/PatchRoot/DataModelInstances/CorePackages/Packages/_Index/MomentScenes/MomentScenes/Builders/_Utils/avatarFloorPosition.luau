local function heightForCharacter(instance)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	if humanoid == nil or humanoidRootPart == nil or not humanoidRootPart:IsA("BasePart") then
		return nil
	end

	local v = humanoid.HipHeight + 0.5 * humanoidRootPart.Size.Y

	if humanoid.RigType == Enum.HumanoidRigType.R6 then
		local leftLeg = instance:FindFirstChild("Left Leg")

		if leftLeg ~= nil and leftLeg:IsA("BasePart") then
			return v + leftLeg.Size.Y
		end
	end

	return v
end

return {
	heightForCharacter = heightForCharacter,
	positionOnFloor = function(instance, p: number, cframe: CFrame?)
		local v = cframe or CFrame.new()
		local v2 = heightForCharacter(instance)

		if v2 == nil then
			instance:PivotTo(v * CFrame.new(p, 0, 0) * CFrame.Angles(0, 3.141592653589793, 0))
			return
		end

		local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")
		humanoidRootPart.Anchored = true

		instance.PrimaryPart = humanoidRootPart
		instance:PivotTo(v * CFrame.new(p, v2, 0) * CFrame.Angles(0, 3.141592653589793, 0))
	end
}
