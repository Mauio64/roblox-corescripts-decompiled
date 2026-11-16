local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		local head = p.renderMeshesData.Head

		local success, result = pcall(function()
			return UGCValidationService:ValidateDynamicHeadEditableMesh(head.editable)
		end)

		if not success then
			object:fetchError(string.format(
				"Failed to load model for dynamic head '%s'. Make sure model exists and try again.",
				p.rootInstance.Name
			))
		end

		if not result then
			object:fail(ErrorSourceStrings.Keys.DynHead_FacsMissing, {
				headName = p.rootInstance.Name
			})
		end
	end
}
