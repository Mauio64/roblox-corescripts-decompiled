local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local R15plusUtils = require(parent.util.R15plusUtils)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)

local CurveAnimBonesHaveValidParents = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }
}

local v = { "Head", "UpperTorso", "LeftFoot", "RightFoot", "LeftHand", "RightHand" }

local v2 = nil

local function getParentMap()
	if v2 then
		return v2
	end

	local result = {}

	for _, v3 in v do
		local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(v3)
		local schemaFlatHierarchyList = R15plusUtils.getSchemaFlatHierarchyList(avatarBoneSchema, { v3 })

		for k, schemaFlatHierarchy in schemaFlatHierarchyList do
			if schemaFlatHierarchy.ClassName ~= "Bone" then
				continue
			end

			local path = schemaFlatHierarchy.path
			local v4 = path[#path - 1]
			local schemaFlatHierarchy2 = schemaFlatHierarchyList[v4]

			if schemaFlatHierarchy2 and schemaFlatHierarchy2.ClassName == "Bone" then
				result[k] = v4
			end
		end
	end

	v2 = result
	return result
end

function CurveAnimBonesHaveValidParents.run(object, p)
	local parentMap = getParentMap()

	for _, folder in p.curveAnimations do
		local nameSet = {}

		for _, folder2 in folder:GetDescendants() do
			if not (folder2:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name)) then
				continue
			end

			nameSet[folder2.Name] = true
		end

		for k in nameSet do
			local parent2 = parentMap[k]

			if parent2 == nil or nameSet[parent2] then
				continue
			end

			object:fail(ErrorSourceStrings.Keys.CurveAnim_BoneRequiresParent, {
				boneName = k,
				parentBoneName = parent2
			})
		end
	end
end

return CurveAnimBonesHaveValidParents
