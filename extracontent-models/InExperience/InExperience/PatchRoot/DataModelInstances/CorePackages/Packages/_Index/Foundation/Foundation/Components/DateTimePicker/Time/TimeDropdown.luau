local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeUtilities = require(Foundation.Components.DateTimePicker.DateTimeUtilities)
local Dropdown = require(Foundation.Components.Dropdown)
local InputSize = require(Foundation.Enums.InputSize)
local Wrappers = require(Foundation.Utility.Wrappers)
local LocalizationService = Wrappers.Services.LocalizationService
local Translator = require(Foundation.Utility.Localization.Translator)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = {
	dateTime = DateTime.fromLocalTime(2000, 1, 1, 0, 0, 0),
	testId = "--foundation-time-dropdown"
}

local function TimeSelector(p)
	local v2 = withDefaults(p, v)

	local roundDownToNearestMinute = DateTimeUtilities.roundDownToNearestMinute(v2.dateTime)
	local localTime = roundDownToNearestMinute:ToLocalTime()

	local maxHeight = useScaledValue(200)

	local function fn()
		local v3 = localTime.Minute % 30 ~= 0
		local result = {}

		for i = 0, 47 do
			local v4 = math.floor(i / 2)
			local dateTime = DateTime.fromLocalTime(
				localTime.Year,
				localTime.Month,
				localTime.Day,
				v4,
				i % 2 * 30,
				localTime.Second
			)

			if v3 and roundDownToNearestMinute.UnixTimestamp < dateTime.UnixTimestamp then
				table.insert(result, {
					icon = nil,
					id = roundDownToNearestMinute.UnixTimestamp,
					isChecked = true,
					isDisabled = true,
					text = roundDownToNearestMinute:FormatLocalTime("LT", LocalizationService.RobloxLocaleId)
				})
				v3 = false
			end

			table.insert(result, {
				icon = nil,
				id = dateTime.UnixTimestamp,
				isChecked = dateTime.UnixTimestamp == roundDownToNearestMinute.UnixTimestamp,
				isDisabled = dateTime.UnixTimestamp == roundDownToNearestMinute.UnixTimestamp,
				text = dateTime:FormatLocalTime("LT", LocalizationService.RobloxLocaleId)
			})
		end

		return result
	end

	return React.createElement(Dropdown.Root, {
		items = fn(),
		label = "",
		LayoutOrder = v2.LayoutOrder,
		maxHeight = maxHeight,
		onItemChanged = v2.onItemChanged,
		placeholder = Translator:FormatByKey("CommonUI.Controls.Label.SelectTheTime"),
		size = InputSize.Medium,
		testId = v2.testId,
		width = v2.width,
		value = roundDownToNearestMinute.UnixTimestamp
	})
end

return TimeSelector
