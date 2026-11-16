local v5 = { week = true }

local function isSupportedTrialPeriodType(value): boolean
	if value == nil then
		return false
	end

	return v5[string.lower(value)] == true
end

return isSupportedTrialPeriodType
