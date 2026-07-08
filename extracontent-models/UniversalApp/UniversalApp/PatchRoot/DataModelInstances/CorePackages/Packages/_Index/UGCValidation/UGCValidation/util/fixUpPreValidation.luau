local ParentParent = script.Parent.Parent
local getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload = require(ParentParent.flags.getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload)
local SplitHumanoidRigDescriptionForUpload = require(ParentParent.util.SplitHumanoidRigDescriptionForUpload)

local function fixUpPreValidation(p1) -- line: 15
	-- upvalues: getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload (copy), SplitHumanoidRigDescriptionForUpload (copy)
	local clone = p1:Clone()

	if getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload() then
		SplitHumanoidRigDescriptionForUpload.fixUploadInstance(clone)
	end

	local descendants = clone:GetDescendants()

	table.insert(descendants, clone)

	for _, v9 in descendants do
		if v9.Parent ~= nil and (v9:IsA("Motor6D") or v9.Name == "OriginalSize" or v9.Name == "OriginalPosition" or v9:IsA("Weld") and v9.Name == "AccessoryWeld" or getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload() and (v9:IsA("Constraint") or v9:isA("NoCollisionConstraint"))) then
			v9:Destroy()
		else
			if v9:IsA("BasePart") then
				v9.Velocity = Vector3.new(0, 0, 0)
				v9.RotVelocity = Vector3.new(0, 0, 0)
			end

			local v10 = not not v9.Parent and v9.Parent:IsA("Accessory")

			if v9:IsA("MeshPart") and not v10 and v9.TextureID == "" and not v9:FindFirstChildWhichIsA("SurfaceAppearance") then
				Instance.new("SurfaceAppearance").Parent = v9
			end
		end
	end

	return clone
end

return fixUpPreValidation
