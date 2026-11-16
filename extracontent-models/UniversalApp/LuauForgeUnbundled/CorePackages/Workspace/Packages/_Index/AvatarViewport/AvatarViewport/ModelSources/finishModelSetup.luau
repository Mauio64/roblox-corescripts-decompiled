require("@game/CorePackages/Workspace/Packages/_Index/AvatarViewport/AvatarViewport/Types")

local function finishModelSetup(instance)
	instance:PivotTo(CFrame.new())

	local humanoidRootPart = instance:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
		instance.PrimaryPart = humanoidRootPart

		humanoidRootPart.Anchored = true
	end

	local humanoid = instance:FindFirstChildOfClass("Humanoid")
	local v5 = if humanoid then humanoid:FindFirstChildOfClass("Animator") else nil

	if humanoid and not v5 then
		v5 = Instance.new("Animator")
		v5.Parent = humanoid
	end

	return { model = instance, humanoid = humanoid, animator = v5 }
end

return finishModelSetup
