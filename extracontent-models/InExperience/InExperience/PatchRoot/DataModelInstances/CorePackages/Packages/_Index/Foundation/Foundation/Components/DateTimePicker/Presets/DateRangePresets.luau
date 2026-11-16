local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeEqualityUtilities = require(script.Parent.Parent.Utilities.DateTimeEqualityUtilities)
local DateTimePickerDateRangePreset = require(Foundation.Enums.DateTimePickerDateRangePreset)
local DateTimePresetRangesUtilities = require(script.Parent.Parent.Utilities.DateTimePresetRangesUtilities)
require(script.Parent.Parent.DateTimeUtilities)

local ChipGroup = require(Foundation.Components.ChipGroup)
local ChipSize = require(Foundation.Enums.ChipSize)
local Translator = require(Foundation.Utility.Localization.Translator)

local v = {
	DateTimePickerDateRangePreset.Today,
	DateTimePickerDateRangePreset.ThisWeek,
	DateTimePickerDateRangePreset.LastWeek,
	DateTimePickerDateRangePreset.ThisMonth,
	DateTimePickerDateRangePreset.ThisYear,
	DateTimePickerDateRangePreset.LastYear
}

local function buildPresetChip(p, selectedDates, referenceDate, selectableDateRange, onPresetSelected)
	local presetRange = DateTimePresetRangesUtilities.resolvePresetRange(p, referenceDate)

	if
		selectableDateRange
		and not DateTimeEqualityUtilities.isRangeWithinSelectableRange(presetRange, selectableDateRange)
	then
		return nil
	end

	return {
		text = Translator:FormatByKey(`CommonUI.Controls.Label.{p}`),
		isChecked = DateTimeEqualityUtilities.areDatesSameDayAsRange(selectedDates, presetRange),
		onActivated = function()
			onPresetSelected(presetRange)
		end
	}
end

local function DateRangePresets(props)
	local chips = React.useMemo(function()
		local presetChips = {}

		for i = 1, #v do
			local presetChip = buildPresetChip(
				v[i],
				props.selectedDates,
				props.referenceDate,
				props.selectableDateRange,
				props.onPresetSelected
			)

			if presetChip then
				table.insert(presetChips, presetChip)
			end
		end

		return presetChips
	end, {
		props.selectedDates,
		props.referenceDate,
		props.onPresetSelected,
		props.selectableDateRange
	})

	return React.createElement(ChipGroup, {
		chips = chips,
		LayoutOrder = props.LayoutOrder,
		size = ChipSize.Small,
		testId = props.testId
	})
end

return DateRangePresets
