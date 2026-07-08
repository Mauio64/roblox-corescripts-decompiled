local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local v5 = game:DefineFastString("UGCValidationBodyPartCollisionFidelity", "Default")

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: v5 (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance
		local Default = Enum.CollisionFidelity.Default

		pcall(function() -- line: 32
			-- upvalues: Default (ref), v5 (copy)
			Default = Enum.CollisionFidelity[v5]
		end)

		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, 1, rootInstance)

		for _, v12 in descendants do
			if v12:IsA("MeshPart") and v12.CollisionFidelity ~= Default then
				p1:fail(ErrorSourceStrings.Keys.CollisionFidelityWrong, {
					InstancePath = v12:GetFullName(),
					ExpectedFidelity = Default.Name
				})
			end
		end
	end
}
