local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local v = {
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
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	prereqTests = { ValidationEnums.ValidationModule.DynamicHeadFacsPresent },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		local head = p.renderMeshesData.Head

		local success, result, v2 = pcall(function()
			return UGCValidationService:GetDynamicHeadEditableMeshInactiveControls(head.editable, v)
		end)

		if not success then
			if string.find(result, "Download Error") == 1 then
				object:fetchError(string.format(
					"Failed to load model for dynamic head '%s'. Make sure model exists and try again.",
					p.rootInstance.Name
				))
			end

			assert(false, result)
		end

		local meshId = p.rootInstance.MeshId

		if #result > 0 then
			object:fail(ErrorSourceStrings.Keys.DynHead_ControlsMissing, {
				headName = p.rootInstance.Name,
				meshId = meshId,
				controlList = table.concat(result, ", ")
			})
		end

		if #v2 > 0 then
			object:fail(ErrorSourceStrings.Keys.DynHead_ControlsInactive, {
				headName = p.rootInstance.Name,
				meshId = meshId,
				controlList = table.concat(v2, ", ")
			})
		end
	end
}
