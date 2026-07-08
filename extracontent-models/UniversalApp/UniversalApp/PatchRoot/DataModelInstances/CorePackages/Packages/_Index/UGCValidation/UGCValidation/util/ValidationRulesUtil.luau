local AvatarCreationService = game:GetService("AvatarCreationService")
local t4 = {
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
	getRules = function(p1) -- line: 36
		-- upvalues: AvatarCreationService (copy)
		if not p1.rules then
			p1.rules = AvatarCreationService:GetValidationRules()
		end

		return p1.rules
	end,
	getBodyPartMaxTrianglesRule = function(p2, p3) -- line: 44
		return p2:getRules().MeshRules.BodyPartMaxTriangles[p3]
	end,
	getMakeupRules = function(p4) -- line: 48
		local MakeupRules = p4:getRules().MakeupRules
		local t1 = {}

		for v9, v10 in MakeupRules do
			if v9 ~= "ExcludeUVBounds" and v9 ~= "IncludeUVBounds" then
				t1[v9] = v10
			end
		end

		local t2 = {}

		for v12, v13 in MakeupRules.ExcludeUVBounds do
			if not t2[v12] then
				t2[v12] = {}
			end

			for _, v15 in v13 do
				table.insert(t2[v12], {
					isIncludeBound = false,
					MinBound = v15.MinBound,
					MaxBound = v15.MaxBound
				})
			end
		end

		for v16, v17 in MakeupRules.IncludeUVBounds do
			if not t2[v16] then
				t2[v16] = {}
			end

			table.insert(t2[v16], {
				isIncludeBound = true,
				MinBound = v17.MinBound,
				MaxBound = v17.MaxBound
			})
		end

		t1.AssetUVBounds = t2

		return t1
	end,
	getAccessoryRules = function(p5, p6) -- line: 89
		for v20, v21 in p5:getRules().AccessoryRules do
			local t3 = {
				rigidAllowed = v21.RigidAllowed,
				attachmentNames = {},
				bounds = {}
			}

			for _, v24 in v21.Attachments do
				table.insert(t3.attachmentNames, v24.Name)
				t3.bounds[v24.Name] = {
					size = v24.Size,
					offset = v24.Offset
				}
			end

			p6[v20] = t3
		end
	end
}

function t4.getBodyPartRules(p7, p8) -- line: 107
	-- upvalues: t4 (copy)
	for v27, v28 in p7:getRules().BodyPartRules do
		local t5 = {
			isBodyPart = true,
			bounds = {},
			subParts = {}
		}

		for v30, v31 in v28.Bounds do
			t5.bounds[v30] = {
				minSize = v31.MinSize,
				maxSize = v31.MaxSize
			}
		end

		for v32, v33 in v28.SubParts do
			local t6 = {
				rigAttachmentToParent = {},
				otherAttachments = {}
			}
			local v35 = t4.rigAttachmentToParentMap[v32]

			for v36, v37 in v33 do
				if v35 == v36 then
					t6.rigAttachmentToParent = {
						name = v36,
						bounds = {
							min = v37.LowerBound,
							max = v37.UpperBound
						}
					}
				else
					t6.otherAttachments[v36] = {
						bounds = {
							min = v37.LowerBound,
							max = v37.UpperBound
						}
					}
				end
			end

			t5.subParts[v32] = t6
		end

		p8[v27] = t5
	end
end
function t4.getFullBodyRulesBounds(p9) -- line: 150
	local t7 = {}

	for v40, v41 in p9:getRules().FullBodyRules.Bounds do
		t7[v40] = {
			minSize = v41.MinSize,
			maxSize = v41.MaxSize
		}
	end

	return t7
end
function t4.getLCSizeLimit(_: {[any]: any}, p10, p11) -- line: 161
	-- upvalues: t4 (copy)
	for _, v46 in t4:getRules().AccessoryRules[p10].Attachments do
		if p11:FindFirstChild(v46.Name) then
			return true, v46.Size
		end
	end

	return false, nil
end

return t4
