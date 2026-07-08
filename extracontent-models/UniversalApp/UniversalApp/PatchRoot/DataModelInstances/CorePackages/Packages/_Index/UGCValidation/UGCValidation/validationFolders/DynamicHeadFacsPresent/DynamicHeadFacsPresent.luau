local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateDynamicHeadData),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
		local Head = p2.renderMeshesData.Head
		local ok, result = pcall(function() -- line: 27
			-- upvalues: UGCValidationService (copy), Head (copy)
			return UGCValidationService:ValidateDynamicHeadEditableMesh(Head.editable)
		end)

		if not ok then
			p1:fetchError(string.format("Failed to load model for dynamic head '%s'. Make sure model exists and try again.", p2.rootInstance.Name))
		end

		if not result then
			p1:fail(ErrorSourceStrings.Keys.DynHead_FacsMissing, {
				headName = p2.rootInstance.Name
			})
		end
	end
}
