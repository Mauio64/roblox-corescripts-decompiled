local parent = script.Parent.Parent

local getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload = require(parent.flags.getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload)

local getFFlagUGCValidationStripAccessoryHandleAttributes = require(parent.flags.getFFlagUGCValidationStripAccessoryHandleAttributes)
local SplitHumanoidRigDescriptionForUpload = require(parent.util.SplitHumanoidRigDescriptionForUpload)

local function fixUpPreValidation(instance)
	local clone = instance:Clone()

	if getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload() then
		SplitHumanoidRigDescriptionForUpload.fixUploadInstance(clone)
	end

	local descendants = clone:GetDescendants()
	table.insert(descendants, clone)

	for _, instance2 in descendants do
		if
			instance2.Parent == nil
			or not instance2:IsA("Motor6D")
			and instance2.Name ~= "OriginalSize"
			and instance2.Name ~= "OriginalPosition"
			and (not instance2:IsA("Weld") or instance2.Name ~= "AccessoryWeld")
			and not (getEngineFeatureEngineSplitHumanoidRigDescriptionInUpload() and (instance2:IsA("Constraint") or instance2:isA("NoCollisionConstraint")))
		then
			if instance2:IsA("BasePart") then
				instance2.Velocity = Vector3.new(0, 0, 0)
				instance2.RotVelocity = Vector3.new(0, 0, 0)
			end

			local v

			if instance2.Parent then
				v = instance2.Parent:IsA("Accessory")
			else
				v = false
			end

			if
				instance2:IsA("MeshPart")
				and not v
				and instance2.TextureID == ""
				and not instance2:FindFirstChildWhichIsA("SurfaceAppearance")
			then
				local surfaceAppearance = Instance.new("SurfaceAppearance")
				surfaceAppearance.Parent = instance2
			end

			if
				getFFlagUGCValidationStripAccessoryHandleAttributes()
				and (instance2:IsA("MeshPart") or instance2:IsA("Part"))
				and instance2.Name == "Handle"
				and v
			then
				for k in instance2:GetAttributes() do
					instance2:SetAttribute(k, nil)
				end
			end
		else
			instance2:Destroy()
		end
	end

	return clone
end

return fixUpPreValidation
