local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local TriangleAreaValid = {}
TriangleAreaValid.categories = {
	ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
	ValidationEnums.UploadCategory.DYNAMIC_HEAD
}

TriangleAreaValid.requiredData = { ValidationEnums.SharedDataMember.renderMeshesData }
TriangleAreaValid.conditionalData = { ValidationEnums.SharedDataMember.outerCagesData }
TriangleAreaValid.expectedFailures = {}

local function checkTriangleArea(object, editable, meshName: string) -- 2 equivalent calls inferred from this helper
	if not UGCValidationService:ValidateEditableMeshTriangleArea(editable) then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_ZeroAreaTriangle, { meshName = meshName })
	end
end

function TriangleAreaValid.run(object, p)
	for k, v in p.renderMeshesData do
		checkTriangleArea(object, v.editable, k) -- inferred equivalent call
	end

	if p.outerCagesData then
		for k, v in p.outerCagesData do
			checkTriangleArea(object, v.editable, k .. "OuterCage") -- inferred equivalent call
		end
	end
end

return TriangleAreaValid
