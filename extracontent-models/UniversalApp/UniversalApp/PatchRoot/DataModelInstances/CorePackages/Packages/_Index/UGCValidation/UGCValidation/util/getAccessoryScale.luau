local Players = game:GetService("Players")

local defineFastFlag = game:DefineFastFlag("HumanoidParentNil", false)

local bodyPartR15sByName = {}
local folder, humanoid

if defineFastFlag then
	folder = nil
	humanoid = nil
else
	if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
		folder = Players:CreateHumanoidModelFromDescriptionAsync(
			Instance.new("HumanoidDescription"),
			Enum.HumanoidRigType.R15
		)
	else
		folder = Players:CreateHumanoidModelFromDescription(
			Instance.new("HumanoidDescription"),
			Enum.HumanoidRigType.R15
		)
	end

	humanoid = folder:FindFirstChildOfClass("Humanoid")
	assert(humanoid, "Humanoid must exist in character model")

	local bodyTypeScale = humanoid:FindFirstChild("BodyTypeScale")
	local bodyProportionScale = humanoid:FindFirstChild("BodyProportionScale")

	bodyTypeScale.Value = 0
	bodyProportionScale.Value = 0

	for _, part in pairs(folder:GetDescendants()) do
		if not part:IsA("BasePart") then
			continue
		end

		for _, attachment in part:GetChildren() do
			if attachment:IsA("Attachment") then
				bodyPartR15sByName[attachment.Name] = humanoid:GetBodyPartR15(part)
			end
		end
	end
end

return function(p, p2)
	if defineFastFlag and folder == nil then
		if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
			folder = Players:CreateHumanoidModelFromDescriptionAsync(
				Instance.new("HumanoidDescription"),
				Enum.HumanoidRigType.R15
			)
		else
			folder = Players:CreateHumanoidModelFromDescription(
				Instance.new("HumanoidDescription"),
				Enum.HumanoidRigType.R15
			)
		end

		humanoid = folder:FindFirstChildOfClass("Humanoid")
		assert(humanoid, "Humanoid must exist in character model")

		local bodyTypeScale = humanoid:FindFirstChild("BodyTypeScale")
		local bodyProportionScale = humanoid:FindFirstChild("BodyProportionScale")

		bodyTypeScale.Value = 0
		bodyProportionScale.Value = 0

		for _, part in pairs(folder:GetDescendants()) do
			if not part:IsA("BasePart") then
				continue
			end

			for _, attachment in part:GetChildren() do
				if attachment:IsA("Attachment") then
					bodyPartR15sByName[attachment.Name] = humanoid:GetBodyPartR15(part)
				end
			end
		end
	end

	if humanoid == nil then
		return Vector3.new(1, 1, 1)
	end

	return humanoid:GetAccessoryHandleScale(p, bodyPartR15sByName[p2.Name])
end
