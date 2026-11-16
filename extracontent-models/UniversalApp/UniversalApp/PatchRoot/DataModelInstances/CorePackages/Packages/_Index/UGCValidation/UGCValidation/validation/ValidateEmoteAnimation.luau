local parent = script.Parent.Parent

local util = parent.util
require(util.Types)
local createEmoteSchema = require(util.createEmoteSchema)
local FailureReasonsAccumulator = require(util.FailureReasonsAccumulator)
local validation = parent.validation
local validateSingleInstance = require(validation.validateSingleInstance)
local validateInstanceTree = require(validation.validateInstanceTree)
local validateTags = require(validation.validateTags)
local validateDependencies = require(validation.validateDependencies)
local ValidatePropertiesSensible = require(validation.ValidatePropertiesSensible)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)

local ValidateEmoteAnimation = {}

function ValidateEmoteAnimation.validateStructure(p)
	local v, v2 = validateSingleInstance(p.instances or {}, p)

	if not v then
		return false, v2
	end

	local instance = p.instances[1]

	local v3, v4 = validateInstanceTree(createEmoteSchema(), instance, p)

	if v3 then
		return true, nil, instance
	end

	return false, v4
end

function ValidateEmoteAnimation.validate(p)
	local v, v2, v3 = ValidateEmoteAnimation.validateStructure(p)

	if not v then
		return false, v2
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v4, v5 = ValidatePropertiesSensible.validate(v3, p)

		if not v4 then
			return false, v5
		end
	end

	local v4, v5 = validateDependencies(v3, p, {
		skipExistenceCheck = true,
		skipOwnershipCheck = true
	})

	if not v4 then
		return false, v5
	end

	local v6 = FailureReasonsAccumulator.new()
	v6:updateReasons(validateTags(v3, p))

	return v6:getFinalResults()
end

return ValidateEmoteAnimation
