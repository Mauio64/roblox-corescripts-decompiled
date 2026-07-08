local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local DateTimeUtilities = require(Foundation.Components.DateTimePicker.DateTimeUtilities)
local Dropdown = require(Foundation.Components.Dropdown)
local InputSize = require(Foundation.Enums.InputSize)
local LocalizationService = require(Foundation.Utility.Wrappers).Services.LocalizationService
local Translator = require(Foundation.Utility.Localization.Translator)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local withDefaults = require(Foundation.Utility.withDefaults)
local t1 = {
	testId = "--foundation-time-dropdown",
	dateTime = DateTime.fromLocalTime(2000, 1, 1, 0, 0, 0)
}

local function TimeSelector(t2: {[any]: any}) -- line: 35
	-- upvalues: withDefaults (copy), t1 (copy), DateTimeUtilities (copy), useScaledValue (copy), LocalizationService (copy), React (copy), Dropdown (copy), Translator (copy), InputSize (copy)
	local v14 = withDefaults(t2, t1)
	local v15 = DateTimeUtilities.roundDownToNearestMinute(v14.dateTime)
	local v16 = v15:ToLocalTime()
	local v17 = useScaledValue(200)

	return React.createElement(Dropdown.Root, {
		label = "",
		items = (function() -- line: 43
			-- upvalues: v16 (copy), v15 (copy), DateTimeUtilities (copy), LocalizationService (copy)
			local t3 = {}
			local v19 = v16.Minute % 30 ~= 0

			for i = 0, 47 do
				local v21 = math.floor(i / 2)
				local v22 = i % 2 * 30
				local dateTime = DateTime.fromLocalTime(v16.Year, v16.Month, v16.Day, v21, v22, v16.Second)

				if v19 and v15.UnixTimestamp < dateTime.UnixTimestamp then
					table.insert(t3, {
						icon = nil,
						isChecked = true,
						isDisabled = true,
						id = v15.UnixTimestamp,
						text = v15:FormatLocalTime(DateTimeUtilities.TIME_COMPOSITE_TOKEN, LocalizationService.RobloxLocaleId)
					})
					v19 = false
				end

				table.insert(t3, {
					icon = nil,
					id = dateTime.UnixTimestamp,
					isChecked = dateTime.UnixTimestamp == v15.UnixTimestamp,
					isDisabled = dateTime.UnixTimestamp == v15.UnixTimestamp,
					text = dateTime:FormatLocalTime(DateTimeUtilities.TIME_COMPOSITE_TOKEN, LocalizationService.RobloxLocaleId)
				})
			end

			return t3
		end)(),
		LayoutOrder = v14.layoutOrder,
		maxHeight = v17,
		onItemChanged = v14.onItemChanged,
		placeholder = Translator:FormatByKey("CommonUI.Controls.Label.SelectTheTime"),
		size = InputSize.Medium,
		testId = v14.testId,
		width = v14.width,
		value = v15.UnixTimestamp
	})
end

return TimeSelector
