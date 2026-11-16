local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local ValidationRulesUtil = require(parent.util.ValidationRulesUtil)

local getFFlagUGCValidateIndividualMeshPartBounds = require(parent.flags.getFFlagUGCValidateIndividualMeshPartBounds)

local getEngineFeatureEngineUGCValidateMeshPartBoundsFromRules = require(parent.flags.getEngineFeatureEngineUGCValidateMeshPartBoundsFromRules)

return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	conditionalData = {},
	["fflag"] = getFFlagUGCValidateIndividualMeshPartBounds,
	expectedFailures = {},
	prereqTests = {},
	run = function(object, p)
		local rootInstance = p.rootInstance
		local renderMeshesData = p.renderMeshesData
		local v, v2

		if getEngineFeatureEngineUGCValidateMeshPartBoundsFromRules() then
			local meshRules = ValidationRulesUtil:getRules().MeshRules
			v = meshRules.MeshPartBoundsMin
			v2 = meshRules.MeshPartBoundsMax
		else
			v = 0.05
			v2 = 4
		end

		for k, v3 in renderMeshesData do
			local v4 = v3.originalSize * v3.scale

			local function checkAxis(axis: string, p2: number)
				if p2 < v then
					object:fail(
						ErrorSourceStrings.Keys.MeshPartBounds_TooSmall,
						{
							partName = k,
							axis = axis,
							currentSize = string.format("%.2f", p2),
							minSize = string.format("%.2f", v)
						},
						rootInstance
					)
				elseif v2 < p2 then
					object:fail(
						ErrorSourceStrings.Keys.MeshPartBounds_TooLarge,
						{
							partName = k,
							axis = axis,
							currentSize = string.format("%.2f", p2),
							maxSize = string.format("%.2f", v2)
						},
						rootInstance
					)
				end
			end

			checkAxis("X", v4.X)
			checkAxis("Y", v4.Y)
			checkAxis("Z", v4.Z)
		end
	end
}
