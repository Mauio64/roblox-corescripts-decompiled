local t = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/t")

local FailureReason = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Enums/FailureReason")

local GetFFlagEnableLimitHit2SVUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Flags/GetFFlagEnableLimitHit2SVUpsell")

local class = {}

function class.new(p2)
	assert(class.isValid(p2))

	class.__index = class

	setmetatable(p2, class)

	return p2
end

function class.mock(options)
	local v5 = options or {}

	return (class.new({
		failureReason = v5.failureReason,
		errorMessage = v5.errorMessage or "",
		ampRecourseActions = v5.ampRecourseActions,
		ampFeatureCheck = v5.ampFeatureCheck
	}))
end

function class.format(data)
	local failureReason = data.FailureReason or data.failureReason
	local errorMessage = data.ErrorMessage or data.errorMessage or ""
	local ampRecourseActions = data.AmpRecourseActions or data.ampRecourseActions
	local ampFeatureCheck = data.AmpFeatureCheck or data.ampFeatureCheck

	local isEligibleForElevatedLimitUpsell = nil

	if GetFFlagEnableLimitHit2SVUpsell() then
		if data.IsEligibleForElevatedLimitUpsell == nil then
			if data.isEligibleForElevatedLimitUpsell ~= nil then
				isEligibleForElevatedLimitUpsell = data.isEligibleForElevatedLimitUpsell
			end
		else
			isEligibleForElevatedLimitUpsell = data.IsEligibleForElevatedLimitUpsell
		end
	end

	local v5 = FailureReason.fromValue(failureReason)

	return (class.new({
		failureReason = v5,
		errorMessage = errorMessage,
		ampRecourseActions = ampRecourseActions,
		ampFeatureCheck = ampFeatureCheck,
		isEligibleForElevatedLimitUpsell = isEligibleForElevatedLimitUpsell
	}))
end

class.isValid = t.strictInterface({
	failureReason = t.optional(t.string),
	errorMessage = t.string,
	ampRecourseActions = t.optional(t.array(t.string)),
	ampFeatureCheck = t.optional(t.string),
	isEligibleForElevatedLimitUpsell = t.optional(t.boolean)
})

return class
