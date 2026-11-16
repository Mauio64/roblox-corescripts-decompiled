local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)
local R15plusUtils = require(parent.util.R15plusUtils)

local getEngineFeatureEngineUGCValidateInstanceTreesEquivalent = require(parent.flags.getEngineFeatureEngineUGCValidateInstanceTreesEquivalent)
local shouldValidateR15LegacyDuplicate = require(parent.util.shouldValidateR15LegacyDuplicate)
local HrdBonesFollowSchema = {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.consumerConfig
	},
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd
}
local defineFastFlag = game:DefineFastFlag("UGCValidationRemoveHRDBlocker", false)
local function fillBoneTreeFlatList(folder, flag: boolean, bones)
	for _, bone in folder:GetChildren() do
		local v = bone:IsA("Bone") and true or flag

		if v then
			table.insert(bones, bone)
		end

		fillBoneTreeFlatList(bone, v, bones)
	end
end

local function nameIsMappedInRigDescriptions(p, humanoidRigDescription, digitsRigDescription)
	for _, v in R15plusUtils.getHrdJointLabels() do
		if p.Name == v.Name then
			local joint = humanoidRigDescription:GetJoint(v)
			return joint and joint.UniqueId == p.UniqueId
		end
	end

	if not digitsRigDescription then
		return false
	end

	for _, v in R15plusUtils.getDrdJointLabels() do
		local formatted = `{digitsRigDescription.Side.Name}Hand{v.Name}`

		if p.Name == formatted then
			local joint = digitsRigDescription:GetJoint(v)
			return joint and joint.UniqueId == p.UniqueId
		end
	end

	return false
end

local function validateBonesForRoot(p, object)
	for _, folder in getAllInstancesIsA(p, "MeshPart") do
		local name = folder.Name

		local humanoidRigDescription = folder:FindFirstChildWhichIsA("HumanoidRigDescription")
		local digitsRigDescription = folder:FindFirstChildWhichIsA("DigitsRigDescription")

		if humanoidRigDescription ~= nil and not defineFastFlag then
			object:fail(ErrorSourceStrings.Keys.HrdCheck_TempR15BonesUploadNotAllowed, nil, humanoidRigDescription)
		end

		if humanoidRigDescription == nil then
			local allInstancesIsA = getAllInstancesIsA(folder, "Bone")

			for _, v in allInstancesIsA do
				object:fail(ErrorSourceStrings.Keys.HrdCheck_BoneWithoutHrd, {
					bonePath = v:GetFullName()
				}, v)
			end

			if digitsRigDescription ~= nil then
				object:fail(ErrorSourceStrings.Keys.HrdCheck_DrdWithoutHrd, nil, digitsRigDescription)
			end
		else
			local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(name)

			local schemaFlatHierarchyList = R15plusUtils.getSchemaFlatHierarchyList(avatarBoneSchema, { name })
			local v = {}
			fillBoneTreeFlatList(folder, false, v)

			local v2 = { [name] = true }

			for _, v3 in v do
				object:setReportingInstance(v3)
				local name2 = v3.Name
				local schemaFlatHierarchy = schemaFlatHierarchyList[name2]

				if name2 == R15plusUtils.JointRotationName then
					continue
				end

				if schemaFlatHierarchy == nil or schemaFlatHierarchy.ClassName ~= v3.ClassName then
					object:fail(ErrorSourceStrings.Keys.HrdCheck_UndefinedInstanceInBoneTree, {
						instName = name2,
						className = v3.ClassName
					})
				elseif v2[name2] then
					object:fail(ErrorSourceStrings.Keys.HrdCheck_DuplicateInstance, {
						instName = name2
					})
				else
					v2[name2] = true

					if
						schemaFlatHierarchy.ClassName == "Bone"
						and not nameIsMappedInRigDescriptions(v3, humanoidRigDescription, digitsRigDescription)
					then
						object:fail(ErrorSourceStrings.Keys.HrdCheck_BoneNotMappedInHRD, {
							boneName = name2
						})
					end
				end
			end

			for _, attachment in folder:GetDescendants() do
				object:setReportingInstance(attachment)
				local schemaFlatHierarchy = schemaFlatHierarchyList[attachment.Name]

				if not (schemaFlatHierarchy and attachment:IsA("Attachment") and attachment.Name ~= R15plusUtils.JointRotationName) then
					continue
				end

				local path = schemaFlatHierarchy.path
				local v3 = #path - 1

				if attachment.ClassName == "Attachment" then
					while v3 > 1 and not v2[path[v3]] do
						v3 -= 1
					end
				end

				local expectedParentName = schemaFlatHierarchy.path[v3]
				local name2 = attachment.Parent.Name

				if name2 ~= expectedParentName then
					object:fail(ErrorSourceStrings.Keys.HrdCheck_ImproperParent, {
						instName = attachment.Name,
						parentName = name2,
						expectedParentName = expectedParentName
					})
				end
			end
		end
	end
end

function HrdBonesFollowSchema.run(object, p)
	validateBonesForRoot(p.rootInstance, object)

	if getEngineFeatureEngineUGCValidateInstanceTreesEquivalent() and shouldValidateR15LegacyDuplicate(p) then
		if p.r15LegacyDuplicateRoot == nil then
			object:fail(ErrorSourceStrings.Keys.FolderStructureMismatch)
			return
		end

		object:setReportingRoot(p.r15LegacyDuplicateRoot)
		validateBonesForRoot(p.r15LegacyDuplicateRoot, object)
		object:setReportingRoot(p.rootInstance)
	end
end

return HrdBonesFollowSchema
