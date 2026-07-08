local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local validation = ParentParent.validation
local validateTags = require(validation.validateTags)
local validateAttributes = require(validation.validateAttributes)
local ValidatePropertiesSensible = require(validation.ValidatePropertiesSensible)
local util = ParentParent.util

require(util.Types)

local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local ParseContentIds = require(util.ParseContentIds)
local pcallDeferred = require(ParentParent.util.pcallDeferred)
local t1 = {}
local getFFlagUGCValidateHSRMeshIds = require(ParentParent.flags.getFFlagUGCValidateHSRMeshIds)

function t1.validateHiddenSurfaceRemovalAsset(t2: {[any]: any}, p1) -- line: 31
	-- upvalues: Analytics (copy), FailureReasonsAccumulator (copy), validateTags (copy), validateAttributes (copy), ValidatePropertiesSensible (copy)
	if #t2 ~= 1 then
		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p1)

		return false, { "WrapLayer HSR asset does not have exactly 1 root" }
	end

	local v16 = t2[1]

	if not v16:IsA("HiddenSurfaceRemovalAsset") then
		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p1)

		return false, { "WrapLayer HSR asset does not have a HiddenSurfaceRemovalAsset as the root Instance" }
	end

	local v17 = FailureReasonsAccumulator.new()

	v17:updateReasons(#v16:GetDescendants() == 0, { "WrapLayer HSR asset has children under the HiddenSurfaceRemovalAsset root Instance" })
	v17:updateReasons(validateTags(v16, p1))
	v17:updateReasons(validateAttributes(v16, p1))
	v17:updateReasons(ValidatePropertiesSensible.validate(v16, p1))

	if not v17:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p1)
	end

	return v17:getFinalResults()
end
function t1.validateHSRMeshIdData(p2, t3: {[any]: any}, p3) -- line: 62
	-- upvalues: getFFlagUGCValidateHSRMeshIds (copy), pcallDeferred (copy), UGCValidationService (copy), Analytics (copy)
	if not getFFlagUGCValidateHSRMeshIds() then
		return true
	end

	if #t3 ~= 1 then
		return false, { "WrapLayer HSR asset does not have exactly 1 root" }
	end

	local v21 = t3[1]

	if not v21:IsA("HiddenSurfaceRemovalAsset") then
		return false, { "WrapLayer HSR asset does not have a HiddenSurfaceRemovalAsset as the root Instance" }
	end

	local v22, v23 = pcallDeferred(function() -- line: 81
		-- upvalues: UGCValidationService (copy), p2 (copy), v21 (copy)
		return UGCValidationService:ValidateHSRMeshIds(p2, v21)
	end, p3)

	if not v22 then
		return false, { "Error occurred while validating HSR Mesh Ids" }
	end

	if not v23 then
		Analytics.reportFailure(Analytics.ErrorType.validataHSR_HSRMeshIdsMismatch, nil, p3)

		return false, { "Invalid HSR data detected. Please re-generate the asset using the Accessory Fitting Tool and try again." }
	end

	return true
end
function t1.validateInstance(p4, p5) -- line: 98
	-- upvalues: Analytics (copy), ParseContentIds (copy), getFFlagUGCValidateHSRMeshIds (copy), t1 (copy), FailureReasonsAccumulator (copy)
	if not p4:IsA("WrapLayer") then
		return true
	end

	local v26 = not not p5.isServer
	local HSRAssetId = p4.HSRAssetId

	if not HSRAssetId or HSRAssetId == "" then
		if v26 then
			Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p5)

			return false, { "WrapLayer HSRAssetId is required" }
		end

		return true
	end

	if not ParseContentIds.tryGetAssetIdFromContentId(HSRAssetId) then
		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p5)

		return false, { "WrapLayer HSRAssetId contains an invalid url" }
	end

	local ok, result = pcall(function() -- line: 124
		-- upvalues: HSRAssetId (copy)
		return game:GetObjectsAllOrNone(HSRAssetId)
	end)

	if not ok then
		if v26 then
			error("Failed to load WrapLayer HSR asset")
		end

		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p5)

		return false, { "Failed to load WrapLayer HSR asset" }
	end

	if not getFFlagUGCValidateHSRMeshIds() then
		return t1.validateHiddenSurfaceRemovalAsset(result, p5)
	end

	local v30 = FailureReasonsAccumulator.new()

	v30:updateReasons(t1.validateHiddenSurfaceRemovalAsset(result, p5))

	if v30:getFinalResults() then
		v30:updateReasons(t1.validateHSRMeshIdData(p4, result, p5))
	end

	if not v30:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validateHSR_FileDataInvalid, nil, p5)
	end

	return v30:getFinalResults()
end
function t1.validate(p6, p7) -- line: 160
	-- upvalues: FailureReasonsAccumulator (copy), t1 (copy), Analytics (copy)
	local timestamp = tick()
	local v34 = FailureReasonsAccumulator.new()

	v34:updateReasons(t1.validateInstance(p6, p7))
	Analytics.recordScriptTime(script.Name, timestamp, p7)

	return v34:getFinalResults()
end

return t1
