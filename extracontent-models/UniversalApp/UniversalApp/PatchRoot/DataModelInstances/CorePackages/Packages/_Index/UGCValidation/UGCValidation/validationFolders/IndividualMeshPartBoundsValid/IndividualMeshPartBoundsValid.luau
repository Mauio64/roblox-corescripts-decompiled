local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateIndividualMeshPartBounds = require(ParentParent.flags.getFFlagUGCValidateIndividualMeshPartBounds)

game:DefineFastInt("UGCValidateMeshPartBoundsMinHundredths", 10)
game:DefineFastInt("UGCValidateMeshPartBoundsMaxHundredths", 200)

local v5 = game:GetFastInt("UGCValidateMeshPartBoundsMinHundredths") / 100
local v6 = game:GetFastInt("UGCValidateMeshPartBoundsMaxHundredths") / 100

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	conditionalData = {},
	fflag = getFFlagUGCValidateIndividualMeshPartBounds,
	expectedFailures = {},
	prereqTests = {},
	run = function(p1, p2) -- line: 31
		-- upvalues: v5 (copy), ErrorSourceStrings (copy), v6 (copy)
		local rootInstance = p2.rootInstance

		for v10, v11 in p2.renderMeshesData do
			local v12 = v11.originalSize * v11.scale

			local function checkAxis(s1: string, n1: number) -- line: 38
				-- upvalues: v5 (copy), p1 (copy), ErrorSourceStrings (copy), v10 (copy), rootInstance (copy), v6 (copy)
				if n1 < v5 then
					p1:fail(ErrorSourceStrings.Keys.MeshPartBounds_TooSmall, {
						partName = v10,
						axis = s1,
						currentSize = string.format("%.2f", n1),
						minSize = string.format("%.2f", v5)
					}, rootInstance)

					return
				end

				if n1 > v6 then
					p1:fail(ErrorSourceStrings.Keys.MeshPartBounds_TooLarge, {
						partName = v10,
						axis = s1,
						currentSize = string.format("%.2f", n1),
						maxSize = string.format("%.2f", v6)
					}, rootInstance)
				end
			end

			checkAxis("X", v12.X)
			checkAxis("Y", v12.Y)
			checkAxis("Z", v12.Z)
		end
	end
}
