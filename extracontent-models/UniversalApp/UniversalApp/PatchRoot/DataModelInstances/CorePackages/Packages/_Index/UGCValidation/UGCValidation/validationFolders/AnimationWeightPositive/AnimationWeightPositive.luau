local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.uploadEnum },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.ExpectedRootSchema },
	run = function(object, p)
		if p.uploadEnum.assetType ~= Enum.AssetType.IdleAnimation then
			return
		end

		for _, numberValue in p.rootInstance:GetDescendants() do
			if not (numberValue:IsA("NumberValue") and numberValue.Name == "Weight") then
				continue
			end

			local value = numberValue.Value

			if value <= 0 then
				object:fail(ErrorSourceStrings.Keys.Animation_WeightNotPositive, {
					animationName = not numberValue.Parent and "Unknown" or numberValue.Parent:GetFullName(),
					weight = tostring(value)
				})
			end
		end
	end
}
