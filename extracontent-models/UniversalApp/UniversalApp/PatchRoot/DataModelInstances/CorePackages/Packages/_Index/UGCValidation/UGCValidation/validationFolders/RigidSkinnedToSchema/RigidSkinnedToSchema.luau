local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)

return {
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning),
	categories = { ValidationEnums.UploadCategory.RIGID_ACCESSORY },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(p1, p2) -- line: 13
		-- upvalues: ErrorSourceStrings (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
		local Handle = p2.renderMeshesData.Handle

		if Handle == nil then
			error("Schema should have ensured data exists for handle")
		end

		if #Handle.editable:GetBones() > 0 then
			p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_RigidIsSkinned, nil, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else p2.rootInstance:FindFirstChild("Handle"))
		end
	end
}
