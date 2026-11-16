local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getEngineFeatureEngineUGCValidationLCOOB = require(parent.flags.getEngineFeatureEngineUGCValidationLCOOB)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = {},
	expectedFailures = {},
	run = function(object, p)
		if p.consumerConfig.consumerEnv == "IEC" then
			return
		end

		local rootInstance = p.rootInstance

		if not getEngineFeatureEngineUGCValidationLCOOB() then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_EngineFeatureDisabled, {
				accessoryName = rootInstance.Name
			})

			return
		end

		local handle = rootInstance:FindFirstChild("Handle")

		if not handle then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NoHandle, {
				accessoryName = rootInstance.Name
			})

			return
		end

		local wrapLayer = handle:FindFirstChildWhichIsA("WrapLayer")

		if not wrapLayer then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NoWrapLayer, {
				accessoryName = rootInstance.Name
			})
		elseif wrapLayer.MaxSize ~= Vector3.new(0, 0, 0) then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NonZeroMaxSize, {})
		elseif wrapLayer.Offset ~= Vector3.new(0, 0, 0) then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NonZeroOffset, {})
		elseif UGCValidationService:IsDeformedLayeredClothingOutOfRenderBounds(rootInstance) then
			object:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_OutOfBounds, {
				accessoryName = rootInstance.Name
			})
		end
	end
}
