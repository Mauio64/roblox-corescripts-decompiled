local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local util = ParentParent.util

require(util.Types)

local createEmoteSchema = require(util.createEmoteSchema)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local pcallDeferred = require(util.pcallDeferred)
local validation = ParentParent.validation
local validateSingleInstance = require(validation.validateSingleInstance)
local validateInstanceTree = require(validation.validateInstanceTree)
local validateTags = require(validation.validateTags)
local validateAttributes = require(validation.validateAttributes)
local validateDependencies = require(validation.validateDependencies)
local validateModeration = require(validation.validateModeration)
local ValidateCurveAnimation = require(validation.ValidateCurveAnimation)
local ValidatePropertiesSensible = require(validation.ValidatePropertiesSensible)
local getEngineFeatureEngineUGCValidatePropertiesSensible = require(ParentParent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local t1 = {}

local function reportError(s1: string, s2: string, p1) -- line: 34
	-- upvalues: Analytics (copy)
	if p1.isServer ~= nil and p1.isServer then
		error(s1)
	end

	Analytics.reportFailure(s2, nil, p1)

	return false, { s1 }
end

function t1.validateStructure(p2) -- line: 49
	-- upvalues: validateSingleInstance (copy), validateInstanceTree (copy), createEmoteSchema (copy)
	local v26, v27 = validateSingleInstance(p2.instances or {}, p2)

	if not v26 then
		return false, v27
	end

	local v28 = p2.instances[1]
	local v29, v30 = validateInstanceTree(createEmoteSchema(), v28, p2)

	if not v29 then
		return false, v30
	end

	return true, nil, v28
end
function t1.validate(p3) -- line: 70
	-- upvalues: t1 (copy), getEngineFeatureEngineUGCValidatePropertiesSensible (copy), ValidatePropertiesSensible (copy), getFFlagUGCValidateMigrateSchemaProperties (copy), getFFlagUGCValidationCombineEntrypointResults (copy), validateDependencies (copy), FailureReasonsAccumulator (copy), validateTags (copy), validateAttributes (copy), getFFlagUGCValidateMigrateCurveAnim (copy), pcallDeferred (copy), reportError (copy), Analytics (copy), ValidateCurveAnimation (copy), validateModeration (copy)
	local v32, v33, v34 = t1.validateStructure(p3)

	if not v32 then
		return false, v33
	end

	local u35 = v34

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v36, v37 = ValidatePropertiesSensible.validate(u35, p3)

		if not v36 then
			return false, v37
		end
	end

	local t2 = {
		skipExistenceCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults(),
		skipOwnershipCheck = getFFlagUGCValidateMigrateSchemaProperties() and getFFlagUGCValidationCombineEntrypointResults()
	}
	local v39, v40 = validateDependencies(u35, p3, t2)

	if not v39 then
		return false, v40
	end

	local v41 = FailureReasonsAccumulator.new()

	v41:updateReasons(validateTags(u35, p3))

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v41:updateReasons(validateAttributes(u35, p3))
	end

	if not getFFlagUGCValidateMigrateCurveAnim() or not getFFlagUGCValidationCombineEntrypointResults() then
		local v42, v43 = pcallDeferred(function() -- line: 109
			-- upvalues: u35 (ref)
			return (game:GetObjectsAllOrNone(u35.AnimationId))
		end, p3)

		if not v42 or not v43 then
			return reportError("Could not download Curve animation.", Analytics.ErrorType.validateEmoteAnimation_FailedToDownloadCurveAnimation, p3)
		end

		if #v43 ~= 1 then
			Analytics.reportFailure(Analytics.ErrorType.validateCurveAnimation_AnimationHierarchyIsIncorrect, nil, p3)

			return false, { "Downloaded Curve animation did not have exactly one root. Please fix the animation." }
		end

		local v44 = v43[1]

		v41:updateReasons(ValidateCurveAnimation.validate(v44, p3))
	end

	if not getFFlagUGCValidateMigrateSchemaProperties() or not getFFlagUGCValidationCombineEntrypointResults() then
		v41:updateReasons(validateModeration(u35, p3.restrictedUserIds, p3))
	end

	return v41:getFinalResults()
end

return t1
