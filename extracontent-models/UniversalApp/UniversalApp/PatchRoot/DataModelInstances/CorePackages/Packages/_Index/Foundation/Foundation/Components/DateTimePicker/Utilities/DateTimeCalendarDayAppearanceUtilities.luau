local Foundation = script:FindFirstAncestor("Foundation")

local DateTimeCalendarViewUtilities = require(script.Parent.DateTimeCalendarViewUtilities)
local DateTimePickerRangeBandRole = require(Foundation.Enums.DateTimePickerRangeBandRole)
local DateTimeRangeSelectionUtilities = require(script.Parent.DateTimeRangeSelectionUtilities)
local DateTimeUtilities = require(script.Parent.Parent.DateTimeUtilities)

local function isDaySelected(p, list, flag: boolean): boolean
	local localTime = DateTimeUtilities.toLocalTime(p)

	for _, v in not flag and (list[1] == nil and {} or { list[1] }) or list do
		if v.Day == localTime.Day and v.Month == localTime.Month and v.Year == localTime.Year then
			return true
		end
	end

	return false
end

local function getRangeBand(p, list, flag: boolean, daySelected: boolean?)
	local item = list[1]
	local item2 = list[2]

	if not (flag and item and item2) then
		return nil, nil, nil
	end

	local v = { startDate = item, endDate = item2 }
	local rangeDayBounds, v2 = DateTimeCalendarViewUtilities.getRangeDayBounds(v)

	if rangeDayBounds == v2 then
		return nil, nil, nil
	end

	local roundToStartOfDay = DateTimeUtilities.roundToStartOfDay(p)
	local v3 = daySelected ~= false

	local function fullCellBand()
		return nil, nil, DateTimeCalendarViewUtilities.getRangeBandRadiusTag(p, v, DateTimePickerRangeBandRole.Full)
	end

	if roundToStartOfDay == rangeDayBounds then
		if v3 then
			return
				UDim2.fromScale(0.5, 0),
				UDim2.fromScale(0.5, 1),
				DateTimeCalendarViewUtilities.getRangeBandRadiusTag(p, v, DateTimePickerRangeBandRole.Start)
		end

		return fullCellBand()
	elseif roundToStartOfDay == v2 then
		if v3 then
			return
				UDim2.fromScale(0, 0),
				UDim2.fromScale(0.5, 1),
				DateTimeCalendarViewUtilities.getRangeBandRadiusTag(p, v, DateTimePickerRangeBandRole.End)
		end

		return fullCellBand()
	else
		local v4

		if flag and list[1] and list[2] then
			v4 = DateTimeUtilities.isDateWithinRange(p, { startDate = list[1], endDate = list[2] })
		else
			v4 = false
		end

		if v4 then
			return fullCellBand()
		end

		return nil, nil, nil
	end
end

local function isDaySelectable(p, p2): boolean -- 1 equivalent call inferred from this helper
	return not (p2 and not DateTimeUtilities.isDateWithinRange(p, p2))
end

local DateTimeCalendarDayAppearanceUtilities = {}

function DateTimeCalendarDayAppearanceUtilities.getDayCellAppearance(p, p2, list, flag: boolean, p3)
	local daySelected = isDaySelected(p, p2, flag)
	local rangeBand, bandSize, bandRadiusTag = getRangeBand(p, list, flag, daySelected)
	local isHighlighted

	if flag and list[1] and list[2] then
		isHighlighted = DateTimeUtilities.isDateWithinRange(p, {
			startDate = list[1],
			endDate = list[2]
		})
	else
		isHighlighted = false
	end

	return {
		bandPosition = rangeBand,
		bandRadiusTag = bandRadiusTag,
		bandSize = bandSize,
		isHighlighted = isHighlighted,
		isSelectable = isDaySelectable(p, p3), -- inferred equivalent call
		isSelected = daySelected
	}
end

DateTimeCalendarDayAppearanceUtilities.getRangeBand = getRangeBand

function DateTimeCalendarDayAppearanceUtilities.isDayHighlighted(p, list, flag: boolean)
	if not flag then
		return false
	end

	if list[1] and list[2] then
		return DateTimeUtilities.isDateWithinRange(p, { startDate = list[1], endDate = list[2] })
	end

	return false
end

DateTimeCalendarDayAppearanceUtilities.isDaySelectable = isDaySelectable
DateTimeCalendarDayAppearanceUtilities.isDaySelected = isDaySelected

function DateTimeCalendarDayAppearanceUtilities.resolveHighlightDates(options, p)
	if options and options[1] then
		if options[2] or not p then
			return options
		end

		return DateTimeRangeSelectionUtilities.selectRangeEndpoint(options, p)
	end

	return options or {}
end

return DateTimeCalendarDayAppearanceUtilities
