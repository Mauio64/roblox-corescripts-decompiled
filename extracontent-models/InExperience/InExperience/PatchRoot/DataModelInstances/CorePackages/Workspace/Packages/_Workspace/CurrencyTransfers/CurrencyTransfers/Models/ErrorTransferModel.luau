local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local t = require(parent.t)

local FailureReason = require(CurrencyTransfers.Enums.FailureReason)

local GetFFlagEnableLimitHit2SVUpsell = require(CurrencyTransfers.Flags.GetFFlagEnableLimitHit2SVUpsell)

local ErrorTransferModel = {}

function ErrorTransferModel.new(p)
	assert(ErrorTransferModel.isValid(p))

	ErrorTransferModel.__index = ErrorTransferModel

	setmetatable(p, ErrorTransferModel)

	return p
end

function ErrorTransferModel.mock(options)
	local v = options or {}

	return (ErrorTransferModel.new({
		failureReason = v.failureReason,
		errorMessage = v.errorMessage or "",
		ampRecourseActions = v.ampRecourseActions,
		ampFeatureCheck = v.ampFeatureCheck
	}))
end

function ErrorTransferModel.format(data)
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

	local failureReason2 = FailureReason.fromValue(failureReason)

	return (ErrorTransferModel.new({
		failureReason = failureReason2,
		errorMessage = errorMessage,
		ampRecourseActions = ampRecourseActions,
		ampFeatureCheck = ampFeatureCheck,
		isEligibleForElevatedLimitUpsell = isEligibleForElevatedLimitUpsell
	}))
end

ErrorTransferModel.isValid = t.strictInterface({
	failureReason = t.optional(t.string),
	errorMessage = t.string,
	ampRecourseActions = t.optional(t.array(t.string)),
	ampFeatureCheck = t.optional(t.string),
	isEligibleForElevatedLimitUpsell = t.optional(t.boolean)
})

return ErrorTransferModel
