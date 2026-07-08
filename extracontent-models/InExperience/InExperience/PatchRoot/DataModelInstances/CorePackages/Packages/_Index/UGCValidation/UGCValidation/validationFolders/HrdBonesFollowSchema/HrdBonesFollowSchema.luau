local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
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
local v8 = game:DefineFastFlag("UGCValidationRemoveHRDBlocker", false)

local function fillBoneTreeFlatList(p1, b1: boolean, t2: {[any]: any}) -- line: 18
	-- upvalues: fillBoneTreeFlatList (copy)
	for _, child in p1:GetChildren() do
		local v16 = b1

		if child:IsA("Bone") then
			v16 = true
		end

		if v16 then
			table.insert(t2, child)
		end

		fillBoneTreeFlatList(child, v16, t2)
	end
end
local function nameIsMappedInRigDescriptions(p2, p3, p4) -- line: 33
	-- upvalues: R15plusUtils (copy)
	for _, v21 in R15plusUtils.getHrdJointLabels() do
		if p2.Name == v21.Name then
			local Joint = p3:GetJoint(v21)

			return Joint and Joint.UniqueId == p2.UniqueId
		end
	end

	if p4 then
		for _, v24 in R15plusUtils.getDrdJointLabels() do
			if `{ p4.Side.Name }Hand{ v24.Name }` == p2.Name then
				local Joint = p4:GetJoint(v24)

				return Joint and Joint.UniqueId == p2.UniqueId
			end
		end
	end

	return false
end

function t1.run(p5, p6) -- line: 59
	-- upvalues: getAllInstancesIsA (copy), v8 (copy), ErrorSourceStrings (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), R15plusUtils (copy), fillBoneTreeFlatList (copy), nameIsMappedInRigDescriptions (copy)
	local rootInstance = p6.rootInstance

	for _, v30 in getAllInstancesIsA(rootInstance, "MeshPart") do
		local Name = v30.Name
		local HumanoidRigDescription = v30:FindFirstChildWhichIsA("HumanoidRigDescription")
		local DigitsRigDescription = v30:FindFirstChildWhichIsA("DigitsRigDescription")

		if HumanoidRigDescription ~= nil and not v8 then
			p5:fail(ErrorSourceStrings.Keys.HrdCheck_TempR15BonesUploadNotAllowed, nil, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else HumanoidRigDescription)
		end

		if HumanoidRigDescription == nil then
			for _, v35 in (getAllInstancesIsA(v30, "Bone")) do
				p5:fail(ErrorSourceStrings.Keys.HrdCheck_BoneWithoutHrd, {
					bonePath = v35:GetFullName()
				}, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else v35)
			end

			if DigitsRigDescription ~= nil then
				p5:fail(ErrorSourceStrings.Keys.HrdCheck_DrdWithoutHrd, nil, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else DigitsRigDescription)
			end
		else
			local v36 = R15plusUtils.getAvatarBoneSchema(Name)
			local v37 = R15plusUtils.getSchemaFlatHierarchyList(v36, { Name })
			local t3 = {}

			fillBoneTreeFlatList(v30, false, t3)

			local t4 = {
				[Name] = true
			}

			for _, v41 in t3 do
				if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
					p5:setReportingInstance(v41)
				end

				local Name2 = v41.Name
				local v43 = v37[Name2]

				if Name2 ~= R15plusUtils.JointRotationName then
					if v43 == nil or v43.ClassName ~= v41.ClassName then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_UndefinedInstanceInBoneTree, {
							instName = Name2,
							className = v41.ClassName
						})
					elseif t4[Name2] then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_DuplicateInstance, {
							instName = Name2
						})
					else
						t4[Name2] = true

						if v43.ClassName == "Bone" and not nameIsMappedInRigDescriptions(v41, HumanoidRigDescription, DigitsRigDescription) then
							p5:fail(ErrorSourceStrings.Keys.HrdCheck_BoneNotMappedInHRD, {
								boneName = Name2
							})
						end
					end
				end
			end

			for _, descendant in v30:GetDescendants() do
				if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
					p5:setReportingInstance(descendant)
				end

				local v46 = v37[descendant.Name]

				if v46 and descendant:IsA("Attachment") and descendant.Name ~= R15plusUtils.JointRotationName then
					local path = v46.path
					local v48 = #path - 1

					if descendant.ClassName == "Attachment" then
						while v48 > 1 and not t4[path[v48]] do
							v48 -= 1
						end
					end

					local v49 = v46.path[v48]
					local ParentName = descendant.Parent.Name

					if ParentName ~= v49 then
						p5:fail(ErrorSourceStrings.Keys.HrdCheck_ImproperParent, {
							instName = descendant.Name,
							parentName = ParentName,
							expectedParentName = v49
						})
					end
				end
			end
		end
	end
end

return t1
