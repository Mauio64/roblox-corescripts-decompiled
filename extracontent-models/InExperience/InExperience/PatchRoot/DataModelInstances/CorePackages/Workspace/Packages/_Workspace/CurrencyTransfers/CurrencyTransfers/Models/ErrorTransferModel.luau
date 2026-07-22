local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local t = require(CurrencyTransfersParent.t)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local GetFFlagEnableLimitHit2SVUpsell = require(CurrencyTransfers.Flags.GetFFlagEnableLimitHit2SVUpsell)
local t1 = {}

function t1.new(p1) -- line: 20
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 32
	-- upvalues: t1 (copy)
	local v9 = p2 or {}

	return (t1.new({
		failureReason = v9.failureReason,
		errorMessage = v9.errorMessage or "",
		ampRecourseActions = v9.ampRecourseActions,
		ampFeatureCheck = v9.ampFeatureCheck
	}))
end
function t1.format(p3) -- line: 45
	-- upvalues: GetFFlagEnableLimitHit2SVUpsell (copy), FailureReason (copy), t1 (copy)
	local v11 = p3.FailureReason or p3.failureReason
	local v12 = p3.ErrorMessage or (p3.errorMessage or "")
	local v13 = p3.AmpRecourseActions or p3.ampRecourseActions
	local v14 = p3.AmpFeatureCheck or p3.ampFeatureCheck
	local IsEligibleForElevatedLimitUpsell = nil

	if GetFFlagEnableLimitHit2SVUpsell() then
		if p3.IsEligibleForElevatedLimitUpsell ~= nil then
			IsEligibleForElevatedLimitUpsell = p3.IsEligibleForElevatedLimitUpsell
		elseif p3.isEligibleForElevatedLimitUpsell ~= nil then
			IsEligibleForElevatedLimitUpsell = p3.isEligibleForElevatedLimitUpsell
		end
	end

	local v16 = FailureReason.fromValue(v11)

	return (t1.new({
		failureReason = v16,
		errorMessage = v12,
		ampRecourseActions = v13,
		ampFeatureCheck = v14,
		isEligibleForElevatedLimitUpsell = IsEligibleForElevatedLimitUpsell
	}))
end

t1.isValid = t.strictInterface({
	failureReason = t.optional(t.string),
	errorMessage = t.string,
	ampRecourseActions = t.optional(t.array(t.string)),
	ampFeatureCheck = t.optional(t.string),
	isEligibleForElevatedLimitUpsell = t.optional(t.boolean)
})

return t1
