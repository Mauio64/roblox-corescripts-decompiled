local ParentParent = script.Parent.Parent
local UGCValidationService = game:GetService("UGCValidationService")
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util

require(util.Types)

local pcallDeferred = require(util.pcallDeferred)
local getEngineFeatureEngineUGCValidationLCOOB = require(ParentParent.flags.getEngineFeatureEngineUGCValidationLCOOB)
local getFFlagEnforceMaxSizeOffsetForLC = require(ParentParent.flags.getFFlagEnforceMaxSizeOffsetForLC)

return function(p1, p2) -- line: 17
	-- upvalues: getEngineFeatureEngineUGCValidationLCOOB (copy), getFFlagEnforceMaxSizeOffsetForLC (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	if p2.allowEditableInstances then
		return true
	end

	if not getEngineFeatureEngineUGCValidationLCOOB() then
		return false, { "Engine feature 'EngineUGCValidationLCOOB' is not enabled. Skipping validation for layered clothing out of bounds." }
	end

	local Handle = p1:FindFirstChild("Handle")

	if not Handle then
		return false, { "Accessory does not have a Handle. Cannot validate layered clothing out of bounds." }
	end

	local WrapLayer = Handle:FindFirstChildWhichIsA("WrapLayer")

	if not WrapLayer then
		return false, { "Accessory does not have a WrapLayer. Cannot validate layered clothing out of bounds." }
	end

	if getFFlagEnforceMaxSizeOffsetForLC() then
		if WrapLayer.MaxSize ~= Vector3.new(0, 0, 0) then
			return false, { "Accessory has a non-zero MaxSize." }
		end

		if WrapLayer.Offset ~= Vector3.new(0, 0, 0) then
			return false, { "Accessory has a non-zero Offset." }
		end
	else
		WrapLayer.MaxSize = Vector3.new(0, 0, 0)
		WrapLayer.Offset = Vector3.new(0, 0, 0)
	end

	local timestamp = tick()
	local v13, v14 = pcallDeferred(function() -- line: 51
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:IsDeformedLayeredClothingOutOfRenderBounds(p1)
	end, p2)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateDeformedLayeredClothingInRenderBounds_FailedToExecute, nil, p2)

		return false, { (string.format("Unable to validate if deformed layered clothing %s is out of render bounds.", p1.Name)) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	if v14 then
		Analytics.reportFailure(Analytics.ErrorType.validateDeformedLayeredClothingInRenderBounds_ClothingOutOfBounds, nil, p2)

		return false, { (string.format("Layered clothing validation failed for '%s'. When deformed, layered clothing becomes too large.", p1.Name)) }
	end

	return true
end
