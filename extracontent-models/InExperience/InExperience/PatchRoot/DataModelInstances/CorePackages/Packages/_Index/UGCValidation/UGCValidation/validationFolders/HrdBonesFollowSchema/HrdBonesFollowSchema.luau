local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}
local v7 = game:DefineFastFlag("UGCValidationRemoveHRDBlocker", false)

local function fillBoneTreeFlatList(p1, b1: boolean, t2: {[any]: any}) -- line: 16
	-- upvalues: fillBoneTreeFlatList (copy)
	for _, child in p1:GetChildren() do
		local v15 = b1

		if child:IsA("Bone") then
			v15 = true
		end

		if v15 then
			table.insert(t2, child)
		end

		fillBoneTreeFlatList(child, v15, t2)
	end
end
local function nameIsMappedInRigDescriptions(p2, p3, p4) -- line: 31
	-- upvalues: R15plusUtils (copy)
	for _, v20 in R15plusUtils.getHrdJointLabels() do
		if p2.Name == v20.Name then
			local Joint = p3:GetJoint(v20)

			return Joint and Joint.UniqueId == p2.UniqueId
		end
	end

	if p4 then
		for _, v23 in R15plusUtils.getDrdJointLabels() do
			if `{ p4.Side.Name }Hand{ v23.Name }` == p2.Name then
				local Joint = p4:GetJoint(v23)

				return Joint and Joint.UniqueId == p2.UniqueId
			end
		end
	end

	return false
end

function t1.run(p5, p6) -- line: 57
	-- upvalues: getAllInstancesIsA (copy), v7 (copy), ErrorSourceStrings (copy), R15plusUtils (copy), fillBoneTreeFlatList (copy), nameIsMappedInRigDescriptions (copy)
	local rootInstance = p6.rootInstance

	for _, v29 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local Name = v29.Name
		local HumanoidRigDescription = v29:FindFirstChildWhichIsA("HumanoidRigDescription")
		local DigitsRigDescription = v29:FindFirstChildWhichIsA("DigitsRigDescription")

		if HumanoidRigDescription ~= nil and not v7 then
			p5:fail(ErrorSourceStrings.Keys.HrdCheck_TempR15BonesUploadNotAllowed, nil, HumanoidRigDescription)
		end

		if HumanoidRigDescription == nil then
			for _, v34 in (getAllInstancesIsA(v29, "Bone")) do
				p5:fail(ErrorSourceStrings.Keys.HrdCheck_BoneWithoutHrd, {
					bonePath = v34:GetFullName()
				}, v34)
			end

			if DigitsRigDescription ~= nil then
				p5:fail(ErrorSourceStrings.Keys.HrdCheck_DrdWithoutHrd, nil, DigitsRigDescription)
			end
		else
			local v35 = R15plusUtils.getAvatarBoneSchema(Name)
			local v36 = R15plusUtils.getSchemaFlatHierarchyList(v35, { Name })
			local t3 = {}

			fillBoneTreeFlatList(v29, false, t3)

			local t4 = {
				[Name] = true
			}

			for _, v40 in t3 do
				p5:setReportingInstance(v40)

				local Name2 = v40.Name
				local v42 = v36[Name2]

				if Name2 ~= R15plusUtils.JointRotationName then
					if v42 == nil or v42.ClassName ~= v40.ClassName then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_UndefinedInstanceInBoneTree, {
							instName = Name2,
							className = v40.ClassName
						})
					elseif t4[Name2] then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_DuplicateInstance, {
							instName = Name2
						})
					else
						t4[Name2] = true

						if v42.ClassName == "Bone" and not nameIsMappedInRigDescriptions(v40, HumanoidRigDescription, DigitsRigDescription) then
							p5:fail(ErrorSourceStrings.Keys.HrdCheck_BoneNotMappedInHRD, {
								boneName = Name2
							})
						end
					end
				end
			end

			for _, descendant in v29:GetDescendants() do
				p5:setReportingInstance(descendant)

				local v45 = v36[descendant.Name]

				if v45 and descendant:IsA("Attachment") and descendant.Name ~= R15plusUtils.JointRotationName then
					local path = v45.path
					local v47 = #path - 1

					if descendant.ClassName == "Attachment" then
						while v47 > 1 and not t4[path[v47]] do
							v47 -= 1
						end
					end

					local v48 = v45.path[v47]
					local ParentName = descendant.Parent.Name

					if ParentName ~= v48 then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_ImproperParent, {
							instName = descendant.Name,
							parentName = ParentName,
							expectedParentName = v48
						})
					end
				end
			end
		end
	end
end

return t1
