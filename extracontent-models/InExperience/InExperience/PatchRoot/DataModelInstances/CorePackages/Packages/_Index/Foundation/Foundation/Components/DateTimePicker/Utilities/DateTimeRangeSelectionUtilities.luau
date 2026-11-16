local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)
local DateTimeRangeSelectionUtilities = {}

function DateTimeRangeSelectionUtilities.normalizeDates(p)
	local v

	if typeof(p.dates) == "table" then
		v = p.dates
	else
		v = { p.dates }
	end

	local v2 = v[2]

	if p.acceptsDateRange or v2 == nil then
		return v
	end

	return { v[1] }
end

function DateTimeRangeSelectionUtilities.selectRangeEndpoint(list, p)
	if not list or not list[1] or list[2] then
		return { p }
	end

	local item = list[1]

	if DateTimeUtilities.roundToStartOfDay(p) < DateTimeUtilities.roundToStartOfDay(item) then
		return { p, item }
	end

	return { item, p }
end

return DateTimeRangeSelectionUtilities
