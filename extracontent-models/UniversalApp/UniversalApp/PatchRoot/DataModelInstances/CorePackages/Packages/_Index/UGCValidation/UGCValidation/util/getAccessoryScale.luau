local Players = game:GetService("Players")
local v2 = game:DefineFastFlag("HumanoidParentNil", false)
local t1 = {}
local u4 = nil
local Humanoid = nil

if not v2 then
	u4 = if not game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15) else Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
	Humanoid = u4:FindFirstChildOfClass("Humanoid")
	assert(Humanoid, "Humanoid must exist in character model")

	local BodyTypeScale = Humanoid:FindFirstChild("BodyTypeScale")
	local BodyProportionScale = Humanoid:FindFirstChild("BodyProportionScale")

	BodyTypeScale.Value = 0
	BodyProportionScale.Value = 0

	for _, descendant in pairs(u4:GetDescendants()) do
		if descendant:IsA("BasePart") then
			for _, child in descendant:GetChildren() do
				if child:IsA("Attachment") then
					t1[child.Name] = Humanoid:GetBodyPartR15(descendant)
				end
			end
		end
	end
end

return function(p1, p2) -- line: 43
	-- upvalues: v2 (copy), u4 (ref), Players (copy), Humanoid (ref), t1 (copy)
	if v2 and u4 == nil then
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			u4 = Players:CreateHumanoidModelFromDescriptionAsync(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
		else
			u4 = Players:CreateHumanoidModelFromDescription(Instance.new("HumanoidDescription"), Enum.HumanoidRigType.R15)
		end

		Humanoid = u4:FindFirstChildOfClass("Humanoid")
		assert(Humanoid, "Humanoid must exist in character model")

		local BodyTypeScale = Humanoid:FindFirstChild("BodyTypeScale")
		local BodyProportionScale = Humanoid:FindFirstChild("BodyProportionScale")

		BodyTypeScale.Value = 0
		BodyProportionScale.Value = 0

		for _, descendant in pairs(u4:GetDescendants()) do
			if descendant:IsA("BasePart") then
				for _, child in descendant:GetChildren() do
					if child:IsA("Attachment") then
						t1[child.Name] = Humanoid:GetBodyPartR15(descendant)
					end
				end
			end
		end
	end

	if Humanoid == nil then
		return (Vector3.new(1, 1, 1))
	end

	return Humanoid:GetAccessoryHandleScale(p1, t1[p2.Name])
end
