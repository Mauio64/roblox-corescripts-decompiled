local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Constants)

return {
	fixUploadInstance = function(p1) -- line: 17
		-- upvalues: Constants (copy)
		local HumanoidRigDescription = p1:FindFirstChildWhichIsA("HumanoidRigDescription")

		if not HumanoidRigDescription then
			return
		end

		for _, v6 in Constants.R15_BODY_PARTS do
			local v7 = p1:FindFirstChild(v6)

			if v7 then
				local HumanoidRigDescription2 = v7:FindFirstChildWhichIsA("HumanoidRigDescription")

				if HumanoidRigDescription2 == nil then
					HumanoidRigDescription2 = Instance.new("HumanoidRigDescription")
					HumanoidRigDescription2.Parent = v7
				end

				if v7.Name == "LowerTorso" then
					HumanoidRigDescription2.OriginOffset = HumanoidRigDescription.OriginOffset
				end

				for _, v10 in HumanoidRigDescription2:GetContainedJointLabels(v6) do
					local Joint = HumanoidRigDescription:GetJoint(v10)

					if not Joint then
						continue
					end

					if Joint:IsA("AnimationConstraint") then
						if Joint.Attachment0 and Joint.Attachment0:IsDescendantOf(v7) then
							HumanoidRigDescription2:SetJoint(v10, Joint.Attachment0)
						else
							if not Joint.Attachment1 or not Joint.Attachment1:IsDescendantOf(v7) then
								continue
							end

							HumanoidRigDescription2:SetJoint(v10, Joint.Attachment1)
						end
					else
						HumanoidRigDescription2:SetJoint(v10, Joint)
					end

					HumanoidRigDescription2:SetTposeAdjustment(v10, HumanoidRigDescription:GetTposeAdjustment(v10))
					HumanoidRigDescription2:SetJointSize(v10, HumanoidRigDescription:GetJointSize(v10))
					HumanoidRigDescription2:SetJointRangeMin(v10, HumanoidRigDescription:GetJointRangeMin(v10))
					HumanoidRigDescription2:SetJointRangeMax(v10, HumanoidRigDescription:GetJointRangeMax(v10))
				end
			end
		end

		local LeftHand = p1:FindFirstChild("LeftHand")
		local RightHand = p1:FindFirstChild("RightHand")

		for _, child in HumanoidRigDescription:GetChildren() do
			if child:IsA("DigitsRigDescription") then
				if child.Side == Enum.DigitsRigDescriptionSide.Left and LeftHand then
					child:Clone().Parent = LeftHand
				elseif child.Side == Enum.DigitsRigDescriptionSide.Right and RightHand then
					child:Clone().Parent = RightHand
				end
			end
		end
	end
}
