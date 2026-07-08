local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateAnimBonesSupport = require(ParentParent.flags.getFFlagUGCValidateAnimBonesSupport)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidateAnimBonesSupport() and getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }
t1.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }

function t1.fflag() -- line: 23
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimBonesSupport (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimBonesSupport()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local t2 = {
	"Head",
	"UpperTorso",
	"LeftFoot",
	"RightFoot",
	"LeftHand",
	"RightHand"
}
local u11 = nil

local function getParentMap() -- line: 33
	-- upvalues: u11 (ref), t2 (copy), R15plusUtils (copy)
	if u11 then
		return u11
	end

	local t3 = {}

	for _, v15 in t2 do
		local v16 = R15plusUtils.getAvatarBoneSchema(v15)
		local v17 = R15plusUtils.getSchemaFlatHierarchyList(v16, { v15 })

		for v18, v19 in v17 do
			if v19.ClassName == "Bone" then
				local path = v19.path
				local v21 = path[#path - 1]
				local v22 = v17[v21]

				if v22 and v22.ClassName == "Bone" then
					t3[v18] = v21
				end
			end
		end
	end

	u11 = t3

	return t3
end

function t1.run(p1, p2) -- line: 61
	-- upvalues: getParentMap (copy), CurveAnimBoneHierarchyUtils (copy), ErrorSourceStrings (copy)
	local v25 = getParentMap()

	for _, v27 in p2.curveAnimations do
		local t4 = {}

		for _, descendant in v27:GetDescendants() do
			if descendant:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(descendant.Name) then
				t4[descendant.Name] = true
			end
		end

		for v31 in t4 do
			local v32 = v25[v31]

			if v32 ~= nil and not t4[v32] then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_BoneRequiresParent, {
					boneName = v31,
					parentBoneName = v32
				})
			end
		end
	end
end

return t1
