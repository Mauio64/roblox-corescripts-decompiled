local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateBackendContentNotEditable = require(parent.flags.getFFlagUGCValidateBackendContentNotEditable)

return {
	["categories"] = Constants.AllAssetUploadCategoriesIncludingMakeup,
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.consumerConfig },
	fflag = getFFlagUGCValidateBackendContentNotEditable,
	expectedFailures = {},
	run = function(object, p)
		if p.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC then
			return
		end

		local descendants = p.rootInstance:GetDescendants()
		table.insert(descendants, p.rootInstance)

		for _, descendant in descendants do
			local v = Constants.CONTENT_TYPED_PROPERTIES_BY_CLASS[descendant.ClassName]

			if not v then
				continue
			end

			for _, fieldName in v do
				if descendant[fieldName].Object ~= nil then
					object:fail(ErrorSourceStrings.Keys.ContentNotEditable, {
						InstanceFullName = descendant:GetFullName(),
						FieldName = fieldName
					})
				end
			end
		end
	end
}
