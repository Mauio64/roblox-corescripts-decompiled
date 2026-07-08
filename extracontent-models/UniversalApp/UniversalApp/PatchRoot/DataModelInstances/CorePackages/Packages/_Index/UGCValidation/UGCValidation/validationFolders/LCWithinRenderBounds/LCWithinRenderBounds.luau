local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCageGeometry = require(ParentParent.flags.getFFlagUGCValidateMigrateCageGeometry)
local getEngineFeatureEngineUGCValidationLCOOB = require(ParentParent.flags.getEngineFeatureEngineUGCValidationLCOOB)
local getFFlagEnforceMaxSizeOffsetForLC = require(ParentParent.flags.getFFlagEnforceMaxSizeOffsetForLC)

return {
	fflag = getFFlagUGCValidateMigrateCageGeometry,
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = {},
	expectedFailures = {},
	run = function(p1, p2) -- line: 20
		-- upvalues: getEngineFeatureEngineUGCValidationLCOOB (copy), ErrorSourceStrings (copy), getFFlagEnforceMaxSizeOffsetForLC (copy), UGCValidationService (copy)
		if p2.consumerConfig.consumerEnv == "IEC" then
			return
		end

		local rootInstance = p2.rootInstance

		if not getEngineFeatureEngineUGCValidationLCOOB() then
			p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_EngineFeatureDisabled, {
				accessoryName = rootInstance.Name
			})

			return
		end

		local Handle = rootInstance:FindFirstChild("Handle")

		if not Handle then
			p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NoHandle, {
				accessoryName = rootInstance.Name
			})

			return
		end

		local WrapLayer = Handle:FindFirstChildWhichIsA("WrapLayer")

		if not WrapLayer then
			p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NoWrapLayer, {
				accessoryName = rootInstance.Name
			})

			return
		end

		if getFFlagEnforceMaxSizeOffsetForLC() then
			if WrapLayer.MaxSize ~= Vector3.new(0, 0, 0) then
				p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NonZeroMaxSize, {})

				return
			end

			if WrapLayer.Offset ~= Vector3.new(0, 0, 0) then
				p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_NonZeroOffset, {})

				return
			end
		else
			WrapLayer.MaxSize = Vector3.new(0, 0, 0)
			WrapLayer.Offset = Vector3.new(0, 0, 0)
		end

		if UGCValidationService:IsDeformedLayeredClothingOutOfRenderBounds(rootInstance) then
			p1:fail(ErrorSourceStrings.Keys.LCWithinRenderBounds_OutOfBounds, {
				accessoryName = rootInstance.Name
			})
		end
	end
}
