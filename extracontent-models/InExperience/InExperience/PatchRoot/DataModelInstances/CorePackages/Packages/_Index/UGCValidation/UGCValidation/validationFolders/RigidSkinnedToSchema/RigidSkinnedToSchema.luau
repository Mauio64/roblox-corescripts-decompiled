local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
return {
	["fflag"] = require(parent.flags.getEngineFeatureEngineUGCValidationConsolidateAccessorySkinning),
	categories = { ValidationEnums.UploadCategory.RIGID_ACCESSORY },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(object, p)
		local handle = p.renderMeshesData.Handle

		if handle == nil then
			error("Schema should have ensured data exists for handle")
		end

		if #handle.editable:GetBones() > 0 then
			object:fail(
				ErrorSourceStrings.Keys.AccessorySkinning_RigidIsSkinned,
				nil,
				p.rootInstance:FindFirstChild("Handle")
			)
		end
	end
}
