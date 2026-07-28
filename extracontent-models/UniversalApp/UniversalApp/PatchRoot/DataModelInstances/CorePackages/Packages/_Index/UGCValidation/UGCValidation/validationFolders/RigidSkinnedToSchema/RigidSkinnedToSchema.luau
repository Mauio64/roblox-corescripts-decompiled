local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	fflag = require(ParentParent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning),
	categories = { ValidationEnums.UploadCategory.RIGID_ACCESSORY },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(p1, p2) -- line: 11
		-- upvalues: ErrorSourceStrings (copy)
		local Handle = p2.renderMeshesData.Handle

		if Handle == nil then
			error("Schema should have ensured data exists for handle")
		end

		if #Handle.editable:GetBones() > 0 then
			p1:fail(ErrorSourceStrings.Keys.AccessorySkinning_RigidIsSkinned, nil, p2.rootInstance:FindFirstChild("Handle"))
		end
	end
}
