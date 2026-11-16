local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local buildStaticCurveAnimationSchema = require(parent.util.buildStaticCurveAnimationSchema)
local validateInstanceTreeAgainstSchema = require(parent.util.validateInstanceTreeAgainstSchema)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)

local getFFlagUGCValidateCurveAnimStrictSchema = require(parent.flags.getFFlagUGCValidateCurveAnimStrictSchema)

local CurveAnimStrictSchema = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	["fflag"] = getFFlagUGCValidateCurveAnimStrictSchema,
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }
}

local function validateNoBodyPartDuplicates(folder, object)
	local nameSet = {}

	for _, folder2 in folder:GetDescendants() do
		if not (folder2:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder2.Name)) then
			continue
		end

		if nameSet[folder2.Name] then
			object:fail(ErrorSourceStrings.Keys.CurveAnim_DuplicateBodyPartFolder, {
				bodyPartName = folder2.Name,
				instancePath = folder2:GetFullName()
			})
		end

		nameSet[folder2.Name] = true
	end
end

function CurveAnimStrictSchema.run(p, p2)
	for _, curveAnimation in p2.curveAnimations do
		validateInstanceTreeAgainstSchema(curveAnimation, buildStaticCurveAnimationSchema, p, {
			missingErrorKey = ErrorSourceStrings.Keys.CurveAnim_StrictSchemaViolation,
			unauthorizedErrorKey = ErrorSourceStrings.Keys.CurveAnim_StrictSchemaViolation,
			skipRootClassCheck = true,
			skipInstanceContext = true
		})

		validateNoBodyPartDuplicates(curveAnimation, p)
	end
end

return CurveAnimStrictSchema
