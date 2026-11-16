local AvatarCreationService = game:GetService("AvatarCreationService")

local ValidationRulesUtil = {
	rigAttachmentToParentMap = {
		Head = "NeckRigAttachment",
		UpperTorso = "WaistRigAttachment",
		LowerTorso = "RootRigAttachment",
		RightHand = "RightWristRigAttachment",
		RightLowerArm = "RightElbowRigAttachment",
		RightUpperArm = "RightShoulderRigAttachment",
		LeftHand = "LeftWristRigAttachment",
		LeftLowerArm = "LeftElbowRigAttachment",
		LeftUpperArm = "LeftShoulderRigAttachment",
		RightFoot = "RightAnkleRigAttachment",
		RightLowerLeg = "RightKneeRigAttachment",
		RightUpperLeg = "RightHipRigAttachment",
		LeftFoot = "LeftAnkleRigAttachment",
		LeftLowerLeg = "LeftKneeRigAttachment",
		LeftUpperLeg = "LeftHipRigAttachment"
	},
	getRules = function(self)
		if not self.rules then
			self.rules = AvatarCreationService:GetValidationRules()
		end

		return self.rules
	end,
	getBodyPartMaxTrianglesRule = function(self, p)
		return self:getRules().MeshRules.BodyPartMaxTriangles[p]
	end,
	getMakeupRules = function(self)
		local makeupRules = self:getRules().MakeupRules
		local makeupRules2 = {}

		for k, makeupRule in makeupRules do
			if k ~= "ExcludeUVBounds" and k ~= "IncludeUVBounds" then
				makeupRules2[k] = makeupRule
			end
		end

		local assetUVBounds = {}

		for k, excludeUVBound in makeupRules.ExcludeUVBounds do
			if not assetUVBounds[k] then
				assetUVBounds[k] = {}
			end

			for _, v in excludeUVBound do
				table.insert(assetUVBounds[k], {
					isIncludeBound = false,
					MinBound = v.MinBound,
					MaxBound = v.MaxBound
				})
			end
		end

		for k, includeUVBound in makeupRules.IncludeUVBounds do
			if not assetUVBounds[k] then
				assetUVBounds[k] = {}
			end

			table.insert(assetUVBounds[k], {
				isIncludeBound = true,
				MinBound = includeUVBound.MinBound,
				MaxBound = includeUVBound.MaxBound
			})
		end

		makeupRules2.AssetUVBounds = assetUVBounds

		return makeupRules2
	end,
	getAccessoryRules = function(self, p)
		for k, accessoryRule in self:getRules().AccessoryRules do
			local v = {
				rigidAllowed = accessoryRule.RigidAllowed,
				attachmentNames = {},
				bounds = {}
			}

			for _, attachment in accessoryRule.Attachments do
				table.insert(v.attachmentNames, attachment.Name)
				v.bounds[attachment.Name] = { size = attachment.Size, offset = attachment.Offset }
			end

			p[k] = v
		end
	end
}

function ValidationRulesUtil.getBodyPartRules(object, p)
	for k, bodyPartRule in object:getRules().BodyPartRules do
		local v = { isBodyPart = true, bounds = {}, subParts = {} }

		for k2, bound in bodyPartRule.Bounds do
			v.bounds[k2] = { minSize = bound.MinSize, maxSize = bound.MaxSize }
		end

		for k2, subPart in bodyPartRule.SubParts do
			local rigAttachmentToParent = ValidationRulesUtil.rigAttachmentToParentMap[k2]
			local v2 = { rigAttachmentToParent = {}, otherAttachments = {} }

			for k3, v3 in subPart do
				if rigAttachmentToParent == k3 then
					v2.rigAttachmentToParent = {
						name = k3,
						bounds = { min = v3.LowerBound, max = v3.UpperBound }
					}
				else
					v2.otherAttachments[k3] = {
						bounds = { min = v3.LowerBound, max = v3.UpperBound }
					}
				end
			end

			v.subParts[k2] = v2
		end

		p[k] = v
	end
end

function ValidationRulesUtil.getFullBodyRulesBounds(object)
	local fullBodyRulesBounds = {}

	for k, bound in object:getRules().FullBodyRules.Bounds do
		fullBodyRulesBounds[k] = { minSize = bound.MinSize, maxSize = bound.MaxSize }
	end

	return fullBodyRulesBounds
end

function ValidationRulesUtil.getLCSizeLimit(_, p, instance)
	for _, attachment in ValidationRulesUtil:getRules().AccessoryRules[p].Attachments do
		if instance:FindFirstChild(attachment.Name) then
			return true, attachment.Size
		end
	end

	return false, nil
end

return ValidationRulesUtil
