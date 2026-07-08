local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local t1 = {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry),
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	conditionalData = { ValidationEnums.SharedDataMember.outerCagesData },
	expectedFailures = {}
}

local function checkTriangleArea(p1, p2, s1: string) -- line: 22
	-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
	if not UGCValidationService:ValidateEditableMeshTriangleArea(p2) then
		p1:fail(ErrorSourceStrings.Keys.MeshGeometry_ZeroAreaTriangle, {
			meshName = s1
		})
	end
end

function t1.run(p3, p4) -- line: 32
	-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
	for v12, v13 in p4.renderMeshesData do
		local editable = v13.editable

		if not UGCValidationService:ValidateEditableMeshTriangleArea(editable) then
			p3:fail(ErrorSourceStrings.Keys.MeshGeometry_ZeroAreaTriangle, {
				meshName = v12
			})
		end
	end

	if p4.outerCagesData then
		for v15, v16 in p4.outerCagesData do
			local editable = v16.editable
			local v18 = v15 .. "OuterCage"

			if not UGCValidationService:ValidateEditableMeshTriangleArea(editable) then
				p3:fail(ErrorSourceStrings.Keys.MeshGeometry_ZeroAreaTriangle, {
					meshName = v18
				})
			end
		end
	end
end

return t1
