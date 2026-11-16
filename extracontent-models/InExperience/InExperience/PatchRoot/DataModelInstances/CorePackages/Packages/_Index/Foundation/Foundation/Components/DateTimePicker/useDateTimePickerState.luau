local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeCalendarViewUtilities = require(script.Parent.Utilities.DateTimeCalendarViewUtilities)
local DateTimeEqualityUtilities = require(script.Parent.Utilities.DateTimeEqualityUtilities)
local DateTimeParsingUtilities = require(script.Parent.Utilities.DateTimeParsingUtilities)
require(script.Parent.DateTimePickerProps)
local DateTimeRangeSelectionUtilities = require(script.Parent.Utilities.DateTimeRangeSelectionUtilities)
local DateTimeUtilities = require(script.Parent.DateTimeUtilities)

local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)

require(Foundation.Components.Types)
local Services = require(Foundation.Utility.Wrappers.Services)
local GuiService = Services.GuiService

local function useDateTimePickerState(data)
	local variant = data.variant or DateTimePickerVariant.Single
	local acceptsDateRange = variant == DateTimePickerVariant.Dual or variant == DateTimePickerVariant.DualWithPresets
	local v = variant == DateTimePickerVariant.DualWithPresets
	local v2 = variant == DateTimePickerVariant.SingleWithTime

	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local dates = React.useMemo(function()
		local defaultDates = data.defaultDates

		if defaultDates == nil then
			return nil
		end

		return DateTimeRangeSelectionUtilities.normalizeDates({
			acceptsDateRange = acceptsDateRange,
			dates = defaultDates
		})
	end, { data.defaultDates, acceptsDateRange })

	local state2, setState2 = React.useState(not dates and "" or DateTimeParsingUtilities.formatInputText({
		dates = dates,
		variant = variant
	}))

	local ref2 = React.useRef(state2)
	ref2.current = state2

	local state3, setState3 = React.useState(function()
		return dates
	end)

	local ref3 = React.useRef(state3)
	ref3.current = state3

	local state4, setState4 = React.useState(nil)

	local state5, setState5 = React.useState(function()
		return dates
	end)

	local closeDateTimePicker = React.useCallback(function()
		setState(false)
	end, {})

	local showDateTimePicker = React.useCallback(function()
		setState(true)
	end, {})

	local onFocusGained = React.useCallback(function()
		if GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small then
			showDateTimePicker()
		end
	end, { showDateTimePicker, GuiService.ViewportDisplaySize })

	local v3 = React.useCallback(function(current, p)
		setState3(current)
		ref3.current = current

		if p and p.asApplied then
			setState5(current)
		end

		if p and p.anchor then
			setState4(p.anchor)
		end
	end, {})

	local function resolvedViewAnchor(state6) -- 2 equivalent calls inferred from this helper
		local anchorDate = DateTimeCalendarViewUtilities.resolveAnchorDate(state6, data.referenceDate)
		return DateTime.fromUnixTimestamp(anchorDate.UnixTimestamp)
	end

	local ref4 = React.useRef(nil)

	local updateInputText = React.useCallback(function(value: string)
		setState2(value)

		if ref4.current ~= nil then
			local current = ref4.current
			ref4.current = nil

			if value == current then
				return
			end
		end

		local function clearDraftToReference()
			v3({}, { anchor = resolvedViewAnchor(nil), asApplied = true }) -- inferred equivalent call
		end

		if value:match("^%s*$") then
			clearDraftToReference()
			data.onChanged(nil)
		elseif acceptsDateRange then
			local dualInputEndpoints, v4 = DateTimeParsingUtilities.parseDualInputEndpoints(value)
			data.onChanged(dualInputEndpoints, v4)

			local inputToDraftDates = DateTimeParsingUtilities.parseInputToDraftDates(value, data.selectableDateRange)

			if inputToDraftDates then
				v3(inputToDraftDates, { anchor = inputToDraftDates[1], asApplied = true })
			else
				clearDraftToReference()
			end
		else
			local dateTimeFromText = DateTimeParsingUtilities.parseDateTimeFromText(DateTimeParsingUtilities.trimInputText(value))

			if
				dateTimeFromText
				and (data.selectableDateRange == nil or DateTimeUtilities.isDateWithinRange(
					dateTimeFromText,
					data.selectableDateRange
				))
			then
				v3({ dateTimeFromText }, { anchor = dateTimeFromText, asApplied = true })
			else
				clearDraftToReference()
			end

			data.onChanged(dateTimeFromText)
		end
	end, { data.onChanged, acceptsDateRange, v2, data.referenceDate, data.selectableDateRange, v3 })

	local onFocusLost = React.useCallback(function(_)
		if not acceptsDateRange then
			return
		end

		local current = ref2.current
		local inputToDraftDates = DateTimeParsingUtilities.parseInputToDraftDates(current, data.selectableDateRange)

		if not inputToDraftDates then
			return
		end

		local formatInputText = DateTimeParsingUtilities.formatInputText({
			dates = inputToDraftDates,
			variant = variant
		})

		if formatInputText == current then
			return
		end

		local current2 = ref3.current

		if not (current2 and current2[1] and current2[2] and DateTimeEqualityUtilities.isSameDay(
			current2[1],
			inputToDraftDates[1]
		) and DateTimeEqualityUtilities.isSameDay(current2[2], inputToDraftDates[2])) then
			return
		end

		ref4.current = formatInputText
		setState2(formatInputText)
		data.onChanged(inputToDraftDates[1], inputToDraftDates[2])
	end, { acceptsDateRange, data.onChanged, data.selectableDateRange, variant })

	local onDayActivated = React.useCallback(function(p)
		v3((DateTimeRangeSelectionUtilities.selectRangeEndpoint(ref3.current, p)))
	end, { v3 })

	local onPresetSelected = React.useCallback(function(p)
		if
			data.selectableDateRange
			and not DateTimeEqualityUtilities.isRangeWithinSelectableRange(p, data.selectableDateRange)
		then
			return
		end

		v3({ p.startDate, p.endDate }, { anchor = p.startDate })
	end, { data.selectableDateRange, v3 })

	local onSelectedDatesChanged = React.useCallback(function(list)
		local current = ref3.current
		local v4

		if current then
			v4 = current[1]
		end

		local v5

		if current then
			v5 = current[2]
		end

		local item = list[1]
		local item2 = list[2]

		if
			current
			and item
			and v4
			and v4.UnixTimestamp == item.UnixTimestamp
			and not v5 == not item2
			and (not v5 or not item2 or v5.UnixTimestamp == item2.UnixTimestamp)
		then
			return
		end

		v3(list)
	end, { v3 })

	local v4 = React.useCallback(function()
		v3(state5, { anchor = resolvedViewAnchor(state5) }) -- inferred equivalent call
	end, { state5, data.referenceDate, v3 })

	local onCancel = React.useCallback(function()
		v4()
		closeDateTimePicker()
	end, { v4, closeDateTimePicker })

	local onReset = React.useCallback(function()
		v4()
	end, { v4 })

	local v5 = React.useCallback(function(list)
		local item = list[1]

		if not item then
			return
		end

		v3(list, { anchor = item })

		if acceptsDateRange then
			local item2 = list[2]
			local current = DateTimeUtilities.formatLocalTime(item) .. " - " .. (not item2 and "" or DateTimeUtilities.formatLocalTime(item2))
			ref4.current = current
			setState2(current)
			data.onChanged(item, item2)
		else
			local formatLocalTime = DateTimeUtilities.formatLocalTime(item, v2)
			ref4.current = formatLocalTime
			setState2(formatLocalTime)
			data.onChanged(item)
		end
	end, { data.onChanged, acceptsDateRange, v2, v3 })

	local onApply = React.useCallback(function()
		local current = ref3.current

		if current then
			if v and not (current[1] and current[2]) then
				closeDateTimePicker()
				return
			end

			setState5(current)
			v5(current)
		end

		closeDateTimePicker()
	end, { closeDateTimePicker, v5, v })

	local isApplyButtonDisabled = false

	if state3 then
		local v6 = state3[1]
		local v7 = state3[2]

		if v or acceptsDateRange then
			isApplyButtonDisabled = v6 == nil or v7 == nil or v6.UnixTimestamp > v7.UnixTimestamp
		elseif variant == DateTimePickerVariant.Single or v2 then
			isApplyButtonDisabled = v6 == nil
		end
	else
		isApplyButtonDisabled = v and true or false
	end

	return {
		closeDateTimePicker = closeDateTimePicker,
		isOpen = state,
		onFocusGained = onFocusGained,
		onFocusLost = onFocusLost,
		showDateTimePicker = showDateTimePicker,
		textInputRef = ref,
		selectedDates = state3,
		inputText = state2,
		updateInputText = updateInputText,
		viewAnchorDate = state4,
		onDayActivated = onDayActivated,
		onPresetSelected = onPresetSelected,
		onSelectedDatesChanged = onSelectedDatesChanged,
		onApply = onApply,
		onCancel = onCancel,
		onReset = onReset,
		isApplyButtonDisabled = isApplyButtonDisabled,
		isResetButtonDisabled = not (v or v2) or DateTimeEqualityUtilities.areDatesEqual(state3, state5)
	}
end

return useDateTimePickerState
