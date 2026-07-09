local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local t = require(CurrencyTransfersParent.t)
local FailureReason = require(CurrencyTransfers.Enums.FailureReason)
local t1 = {}

function t1.new(p1) -- line: 17
	-- upvalues: t1 (copy)
	assert(t1.isValid(p1))
	t1.__index = t1
	setmetatable(p1, t1)

	return p1
end
function t1.mock(p2) -- line: 29
	-- upvalues: t1 (copy)
	local v8 = p2 or {}

	return (t1.new({
		failureReason = v8.failureReason,
		errorMessage = v8.errorMessage or "",
		ampRecourseActions = v8.ampRecourseActions,
		ampFeatureCheck = v8.ampFeatureCheck
	}))
end
function t1.format(p3) -- line: 42
	-- upvalues: FailureReason (copy), t1 (copy)
	local v10 = p3.FailureReason or p3.failureReason
	local v11 = p3.ErrorMessage or (p3.errorMessage or "")
	local v12 = p3.AmpRecourseActions or p3.ampRecourseActions
	local v13 = p3.AmpFeatureCheck or p3.ampFeatureCheck
	local v14 = FailureReason.fromValue(v10)

	return (t1.new({
		failureReason = v14,
		errorMessage = v11,
		ampRecourseActions = v12,
		ampFeatureCheck = v13
	}))
end

t1.isValid = t.strictInterface({
	failureReason = t.optional(t.string),
	errorMessage = t.string,
	ampRecourseActions = t.optional(t.array(t.string)),
	ampFeatureCheck = t.optional(t.string)
})

return t1
