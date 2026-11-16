local v = { week = true }

local function isSupportedTrialPeriodType(value: string?): boolean
	return value ~= nil and v[string.lower(value)] == true
end

return isSupportedTrialPeriodType
