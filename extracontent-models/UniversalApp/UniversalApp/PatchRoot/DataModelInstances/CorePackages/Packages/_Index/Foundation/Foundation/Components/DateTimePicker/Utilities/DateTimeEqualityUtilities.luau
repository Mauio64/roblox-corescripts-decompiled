local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local function isSameDay(p, p2): boolean -- 2 equivalent calls inferred from this helper
	return DateTimeUtilities.roundToStartOfDay(p) == DateTimeUtilities.roundToStartOfDay(p2)
end

local DateTimeEqualityUtilities = {}

function DateTimeEqualityUtilities.areDatesEqual(list, list2): boolean
	if list == nil and list2 == nil then
		return true
	end

	if list == nil or list2 == nil then
		return false
	end

	local item = list[1]
	local item2 = list2[1]

	if (item == nil) ~= (item2 == nil) or item and item2 and item.UnixTimestamp ~= item2.UnixTimestamp then
		return false
	end

	local item3 = list[2]
	local item4 = list2[2]

	if (item3 == nil) ~= (item4 == nil) then
		return false
	end

	return not (item3 and item4) or item3.UnixTimestamp == item4.UnixTimestamp
end

function DateTimeEqualityUtilities.areDatesSameDayAsRange(list, p)
	if not (list and list[1] and list[2]) then
		return false
	end

	return isSameDay(list[1], p.startDate) and isSameDay(list[2], p.endDate) -- inferred equivalent call
end

function DateTimeEqualityUtilities.isRangeWithinSelectableRange(p, p2)
	return DateTimeUtilities.isDateWithinRange(p.startDate, p2) and DateTimeUtilities.isDateWithinRange(p.endDate, p2)
end

DateTimeEqualityUtilities.isSameDay = isSameDay
return DateTimeEqualityUtilities
