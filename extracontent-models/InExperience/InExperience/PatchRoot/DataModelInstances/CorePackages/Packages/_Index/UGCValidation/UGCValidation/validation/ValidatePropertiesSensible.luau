local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)

require(util.Types)

local getFIntUGCValidateMaxHSRDataLen = require(ParentParent.flags.getFIntUGCValidateMaxHSRDataLen)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local t1 = {}
local t2 = nil

local function createPropertyLengthRestrictions() -- line: 23
	-- upvalues: t2 (ref), getFIntUGCValidateMaxHSRDataLen (copy)
	if t2 then
		return
	end

	t2 = {
		HiddenSurfaceRemovalAsset = {
			HSRData = getFIntUGCValidateMaxHSRDataLen()
		}
	}
end

function t1.resetPropertyLengthRestrictions() -- line: 33
	-- upvalues: t2 (ref)
	t2 = nil
end

local function validateIndividual(p1) -- line: 37
	-- upvalues: UGCValidationService (copy), t2 (ref)
	local v13, v14 = UGCValidationService:ValidatePropertiesSensible(p1, t2[p1.ClassName])

	if not v13 then
		return false, { string.format("%s %s has invalid properties: %s. These properties may be numeric values with NaNs or Infs, or strings/BinaryStrings longer than the max number of characters.", p1.ClassName, p1:GetFullName(), table.concat(v14, ", ")) }
	end

	return true
end

function t1.validate(p2, p3) -- line: 58
	-- upvalues: getEngineFeatureEngineUGCValidatePropertiesSensible (copy), t2 (ref), getFIntUGCValidateMaxHSRDataLen (copy), FailureReasonsAccumulator (copy), validateIndividual (copy), Analytics (copy)
	if not getEngineFeatureEngineUGCValidatePropertiesSensible() then
		return true
	end

	local timestamp = tick()

	if not t2 then
		t2 = {
			HiddenSurfaceRemovalAsset = {
				HSRData = getFIntUGCValidateMaxHSRDataLen()
			}
		}
	end

	local v18 = FailureReasonsAccumulator.new()
	local descendants = p2:GetDescendants()

	table.insert(descendants, p2)

	for _, v21 in descendants do
		v18:updateReasons(validateIndividual(v21))
	end

	if not v18:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validatePropertiesSensible_IncorrectPropertiesFound, nil, p3)
	end

	Analytics.recordScriptTime(script.Name, timestamp, p3)

	return v18:getFinalResults()
end

return t1
