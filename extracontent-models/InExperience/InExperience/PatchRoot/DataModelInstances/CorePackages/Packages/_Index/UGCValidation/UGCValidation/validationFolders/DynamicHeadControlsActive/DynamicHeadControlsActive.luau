local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local t1 = {
	"LeftEyeClosed",
	"EyesLookDown",
	"RightEyeClosed",
	"JawDrop",
	"Pucker",
	"LeftLipCornerPuller",
	"RightLipCornerPuller",
	"ChinRaiser",
	"ChinRaiserUpperLip",
	"LeftCheekRaiser",
	"RightCheekRaiser",
	"LeftInnerBrowRaiser",
	"RightInnerBrowRaiser",
	"LeftLipCornerDown",
	"RightLipCornerDown",
	"LeftLowerLipDepressor",
	"RightLowerLipDepressor"
}

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateDynamicHeadData),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	prereqTests = { ValidationEnums.ValidationModule.DynamicHeadFacsPresent },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 45
		-- upvalues: UGCValidationService (copy), t1 (copy), ErrorSourceStrings (copy)
		local Head = p2.renderMeshesData.Head
		local ok, result, v11 = pcall(function() -- line: 48
			-- upvalues: UGCValidationService (copy), Head (copy), t1 (copy)
			return UGCValidationService:GetDynamicHeadEditableMeshInactiveControls(Head.editable, t1)
		end)

		if not ok then
			if string.find(result, "Download Error") == 1 then
				p1:fetchError(string.format("Failed to load model for dynamic head '%s'. Make sure model exists and try again.", p2.rootInstance.Name))
			end

			assert(false, result)
		end

		local MeshId = p2.rootInstance.MeshId

		if #result > 0 then
			p1:fail(ErrorSourceStrings.Keys.DynHead_ControlsMissing, {
				headName = p2.rootInstance.Name,
				meshId = MeshId,
				controlList = table.concat(result, ", ")
			})
		end

		if #v11 > 0 then
			p1:fail(ErrorSourceStrings.Keys.DynHead_ControlsInactive, {
				headName = p2.rootInstance.Name,
				meshId = MeshId,
				controlList = table.concat(v11, ", ")
			})
		end
	end
}
