local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastString = game:DefineFastString("UGCValidationBodyPartCollisionFidelity", "Default")

return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {},
	run = function(object, p)
		local rootInstance = p.rootInstance

		local v = Enum.CollisionFidelity.Default

		pcall(function()
			v = Enum.CollisionFidelity[defineFastString]
		end)

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, 1, rootInstance)

		for _, part in descendants do
			if part:IsA("MeshPart") and part.CollisionFidelity ~= v then
				object:fail(ErrorSourceStrings.Keys.CollisionFidelityWrong, {
					InstancePath = part:GetFullName(),
					ExpectedFidelity = v.Name
				})
			end
		end
	end
}
