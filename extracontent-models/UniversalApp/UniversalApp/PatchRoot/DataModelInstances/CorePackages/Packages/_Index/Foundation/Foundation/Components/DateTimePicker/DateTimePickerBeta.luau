local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local Icon = BuilderIcons.Icon

local DateTimePickerCalendarContent = require(script.Parent.DateTimePickerCalendarContent)
local DateTimePickerPanel = require(script.Parent.DateTimePickerPanel)
require(script.Parent.DateTimePickerProps)

local useDateTimePickerState = require(script.Parent.useDateTimePickerState)

local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)

local InputSize = require(Foundation.Enums.InputSize)
local Popover = require(Foundation.Components.Popover)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local TextInput = require(Foundation.Components.TextInput)
local Translator = require(Foundation.Utility.Localization.Translator)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local v = { variant = DateTimePickerVariant.Single, testId = "--foundation-date-time-picker" }

local function DateTimePickerBeta(p)
	local v2 = withDefaults(p, v)
	local v3 = useTokens()
	local variant = v2.variant or DateTimePickerVariant.Single
	local v4 = variant == DateTimePickerVariant.DualWithPresets
	local v5 = variant == DateTimePickerVariant.SingleWithTime
	local v6 = v4 or v5

	local v7 = useDateTimePickerState(v2)

	local createElement = React.createElement
	local root = Popover.Root
	local v8 = { isOpen = v7.isOpen, testId = v2.testId }
	local v9 = {
		DateInput = React.createElement(TextInput, withCommonProps(v2, {
			hasError = v2.hasError,
			hint = v2.hint,
			iconTrailing = { name = Icon.Calendar, onActivated = v7.showDateTimePicker },
			isDisabled = v2.isDisabled,
			isRequired = v2.isRequired,
			key = "date-input",
			label = v2.label,
			onChanged = v7.updateInputText,
			onFocusGained = v7.onFocusGained,
			onFocusLost = v7.onFocusLost,
			placeholder = v2.placeholder or Translator:FormatByKey("CommonUI.Controls.Label.SelectDate"),
			ref = v7.textInputRef,
			selectableDateRange = v2.selectableDateRange,
			size = InputSize.Medium,
			testId = `{v2.testId}--text-input`,
			text = v7.inputText,
			width = v2.width
		})),
		Anchor = React.createElement(Popover.Anchor, { anchorRef = v7.textInputRef }),
		PopoverContent = 0
	}

	local createElement2 = React.createElement
	local content = Popover.Content
	local v10 = {
		align = PopoverAlign.Start,
		hasArrow = false,
		onPressedOutside = v7.closeDateTimePicker,
		selection = v2.selection,
		selectionGroup = v2.selectionGroup,
		side = {
			offset = v3.Stroke.Standard + v3.Padding.Small,
			position = PopoverSide.Bottom
		}
	}

	local v11 = v7.isOpen

	if v11 then
		local createElement3 = React.createElement

		local v12 = {
			isApplyButtonDisabled = v7.isApplyButtonDisabled,
			isResetButtonDisabled = v7.isResetButtonDisabled,
			isSectioned = v6,
			onApply = v7.onApply,
			onCancel = v7.onCancel,
			onReset = 0,
			sectionedLayout = 0,
			showReset = 0,
			testId = 0
		}
		local onReset

		if v6 then
			onReset = v7.onReset
		end

		v12.onReset = onReset
		v12.sectionedLayout = v4 and "dual" or v5 and "singleWithTime" or nil
		v12.showReset = v6
		v12.testId = v2.testId
		v11 = createElement3(DateTimePickerPanel, v12, React.createElement(DateTimePickerCalendarContent, {
			onDayActivated = v7.onDayActivated,
			onPresetSelected = v7.onPresetSelected,
			onSelectedDatesChanged = v7.onSelectedDatesChanged,
			referenceDate = v2.referenceDate,
			selectableDateRange = v2.selectableDateRange,
			selectedDates = v7.selectedDates,
			testId = v2.testId,
			variant = variant,
			viewAnchorDate = v7.viewAnchorDate
		}))
	end

	v9.PopoverContent = createElement2(content, v10, v11)
	return createElement(root, v8, v9)
end

return React.memo(DateTimePickerBeta)
