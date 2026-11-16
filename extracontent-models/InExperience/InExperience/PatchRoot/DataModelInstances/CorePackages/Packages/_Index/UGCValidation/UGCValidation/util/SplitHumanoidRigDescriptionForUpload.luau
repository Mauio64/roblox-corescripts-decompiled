local parent = script.Parent.Parent
local Constants = require(parent.Constants)

return {
	fixUploadInstance = function(instance)
		local humanoidRigDescription = instance:FindFirstChildWhichIsA("HumanoidRigDescription")

		if not humanoidRigDescription then
			return
		end

		for _, childName in Constants.R15_BODY_PARTS do
			local child = instance:FindFirstChild(childName)

			if not child then
				continue
			end

			local v = child:FindFirstChildWhichIsA("HumanoidRigDescription")

			if v == nil then
				v = Instance.new("HumanoidRigDescription")
				v.Parent = child
			end

			if child.Name == "LowerTorso" then
				v.OriginOffset = humanoidRigDescription.OriginOffset
			end

			for _, v2 in v:GetContainedJointLabels(childName) do
				local joint = humanoidRigDescription:GetJoint(v2)

				if not joint then
					continue
				end

				if joint:IsA("AnimationConstraint") then
					if joint.Attachment0 and joint.Attachment0:IsDescendantOf(child) then
						v:SetJoint(v2, joint.Attachment0)
					elseif joint.Attachment1 and joint.Attachment1:IsDescendantOf(child) then
						v:SetJoint(v2, joint.Attachment1)
					else
						continue
					end
				else
					v:SetJoint(v2, joint)
				end

				v:SetTposeAdjustment(v2, humanoidRigDescription:GetTposeAdjustment(v2))
				v:SetJointSize(v2, humanoidRigDescription:GetJointSize(v2))
				v:SetJointRangeMin(v2, humanoidRigDescription:GetJointRangeMin(v2))
				v:SetJointRangeMax(v2, humanoidRigDescription:GetJointRangeMax(v2))
			end
		end

		local leftHand = instance:FindFirstChild("LeftHand")
		local rightHand = instance:FindFirstChild("RightHand")

		for _, digitsRigDescription in humanoidRigDescription:GetChildren() do
			if not digitsRigDescription:IsA("DigitsRigDescription") then
				continue
			end

			if digitsRigDescription.Side == Enum.DigitsRigDescriptionSide.Left and leftHand then
				local clone = digitsRigDescription:Clone()
				clone.Parent = leftHand
			elseif digitsRigDescription.Side == Enum.DigitsRigDescriptionSide.Right and rightHand then
				local clone = digitsRigDescription:Clone()
				clone.Parent = rightHand
			end
		end
	end
}
