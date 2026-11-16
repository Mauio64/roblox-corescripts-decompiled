local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

local util = parent.util
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
require(util.Types)

local getFIntUGCValidateMaxHSRDataLen = require(parent.flags.getFIntUGCValidateMaxHSRDataLen)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)

local v = nil

local function createPropertyLengthRestrictions() -- 1 equivalent call inferred from this helper
	if v then
		return
	end

	v = {
		HiddenSurfaceRemovalAsset = {
			HSRData = getFIntUGCValidateMaxHSRDataLen()
		}
	}
end

local ValidatePropertiesSensible = {}

function ValidatePropertiesSensible.resetPropertyLengthRestrictions()
	v = nil
end

local function validateIndividual(descendant)
	local v2, v3 = UGCValidationService:ValidatePropertiesSensible(descendant, v[descendant.ClassName])

	if v2 then
		return true
	end

	return
		false,
		{ string.format(
				"%s %s has invalid properties: %s. These properties may be numeric values with NaNs or Infs, or strings/BinaryStrings longer than the max number of characters.",
				descendant.ClassName,
				descendant:GetFullName(),
				table.concat(v3, ", ")
			) }
end

function ValidatePropertiesSensible.validate(folder, p)
	if not getEngineFeatureEngineUGCValidatePropertiesSensible() then
		return true
	end

	local now = tick()
	createPropertyLengthRestrictions() -- inferred equivalent call
	local v2 = FailureReasonsAccumulator.new()

	local descendants = folder:GetDescendants()
	table.insert(descendants, folder)

	for _, descendant in descendants do
		v2:updateReasons(validateIndividual(descendant))
	end

	if not v2:getFinalResults() then
		Analytics.reportFailure(Analytics.ErrorType.validatePropertiesSensible_IncorrectPropertiesFound, nil, p)
	end

	Analytics.recordScriptTime(script.Name, now, p)
	return v2:getFinalResults()
end

return ValidatePropertiesSensible
