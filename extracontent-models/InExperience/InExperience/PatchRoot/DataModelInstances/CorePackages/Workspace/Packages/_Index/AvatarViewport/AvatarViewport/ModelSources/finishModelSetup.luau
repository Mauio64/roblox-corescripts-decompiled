require(script.Parent.Parent.Types)

local function finishModelSetup(instance)
	instance:PivotTo(CFrame.new())

	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		instance.PrimaryPart = humanoidRootPart

		humanoidRootPart.Anchored = true
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local animator

	if humanoid then
		animator = humanoid:FindFirstChildOfClass("Animator")
	end

	if humanoid and not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	return { model = instance, humanoid = humanoid, animator = animator }
end

return finishModelSetup
