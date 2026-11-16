require("@luauforge/deferred/egZ")

local module = require("@luauforge/deferred/ehD")

local function useClassYears(p2)
	local v5 = module(p2)

	return {
		status = v5.status,
		years = not v5.data and {} or v5.data.years
	}
end

return useClassYears
