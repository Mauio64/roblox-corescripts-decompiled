local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local Icon = BuilderIcons.Icon
local Calendar = require(script.Parent.Calendar)
local DateTimeUtilities = require(script.Parent.DateTimeUtilities)
local Button = require(Foundation.Components.Button)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local GuiService = require(Foundation.Utility.Wrappers.Services).GuiService
local InputSize = require(Foundation.Enums.InputSize)
local Popover = require(Foundation.Components.Popover)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local TextInput = require(Foundation.Components.TextInput)
local Translator = require(Foundation.Utility.Localization.Translator)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local DateTimePickerVariant = require(Foundation.Enums.DateTimePickerVariant)
local t1 = {
	testId = "--foundation-date-time-picker",
	variant = DateTimePickerVariant.Single
}

local function DateTimePicker(p1) -- line: 69
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), React (copy), DateTimePickerVariant (copy), DateTimeUtilities (copy), GuiService (copy), Popover (copy), TextInput (copy), withCommonProps (copy), Icon (copy), Translator (copy), InputSize (copy), PopoverSide (copy), View (copy), Calendar (copy), Button (copy), ButtonVariant (copy)
	local v24 = withDefaults(p1, t1)
	local v25 = useTokens()
	local v26, v27 = React.useState(false)
	local v28 = React.useRef(nil)
	local v29 = React.useMemo(function() -- line: 76
		-- upvalues: v24 (copy)
		local defaultDates = v24.defaultDates

		if defaultDates then
			if typeof(defaultDates) ~= "table" then
				return { defaultDates }
			end

			return defaultDates
		end

		return nil
	end, { v24.defaultDates })
	local v30, v31 = React.useState(not v29 and "" or if v24.variant ~= DateTimePickerVariant.Dual then DateTimeUtilities.formatLocalTime(v29[1], v24.variant == DateTimePickerVariant.SingleWithTime) else `{ DateTimeUtilities.formatLocalTime(v29[1]) } - { not v29[2] and "" or DateTimeUtilities.formatLocalTime(v29[2]) }`)
	local v32, v33 = React.useState(v29)
	local v34 = React.useCallback(function() -- line: 105
		-- upvalues: v27 (copy)
		v27(false)
	end, {})
	local v35 = React.useCallback(function() -- line: 109
		-- upvalues: v27 (copy)
		v27(true)
	end, {})
	local v36 = React.useCallback(function() -- line: 113
		-- upvalues: GuiService (copy), v35 (copy)
		if GuiService.ViewportDisplaySize ~= Enum.DisplaySize.Small then
			v35()
		end
	end, {
		v35,
		GuiService.ViewportDisplaySize
	})
	local v37 = React.useCallback(function(s1: string) -- line: 120
		-- upvalues: v31 (copy), v24 (copy), DateTimePickerVariant (copy), DateTimeUtilities (copy)
		v31(s1)

		if s1:match("^%s*$") then
			return
		end

		if v24.variant == DateTimePickerVariant.Dual then
			local parts = s1:split("-")
			local v42 = DateTimeUtilities.getDateTimeFromText(parts[1])
			local v43 = DateTimeUtilities.getDateTimeFromText(parts[2])

			v24.onChanged(v42, v43)

			return
		end

		local v44 = s1:match("^%s*(.-)%s*$") or ""
		local v45 = DateTimeUtilities.getDateTimeFromText(v44)

		v24.onChanged(v45)
	end, { v24.onChanged })
	local v38 = React.useCallback(function() -- line: 144
		-- upvalues: v24 (copy), DateTimePickerVariant (copy), DateTimeUtilities (copy), v32 (copy), v31 (copy), v34 (copy)
		if v24.variant == DateTimePickerVariant.Dual then
			local v46 = DateTimeUtilities.formatLocalTime(v32[1])
			local v47 = not v32[2] and "" or DateTimeUtilities.formatLocalTime(v32[2])

			v31(v46 .. " - " .. v47)
		else
			v31(DateTimeUtilities.formatLocalTime(v32[1], v24.variant == DateTimePickerVariant.SingleWithTime))
		end

		v34()
	end, {
		v32,
		v34
	})

	return React.createElement(Popover.Root, {
		isOpen = v26,
		testId = v24.testId
	}, {
		DateInput = React.createElement(TextInput, withCommonProps(v24, {
			key = "date-input",
			hasError = v24.hasError,
			hint = v24.hint,
			iconTrailing = {
				name = Icon.Calendar,
				onActivated = v35
			},
			isDisabled = v24.isDisabled,
			isRequired = v24.isRequired,
			label = v24.label,
			onChanged = v37,
			onFocusGained = v36,
			placeholder = Translator:FormatByKey("CommonUI.Controls.Label.SelectDate"),
			ref = v28,
			selectableDateRange = v24.selectableDateRange,
			size = InputSize.Medium,
			text = v30,
			testId = `{ v24.testId }--text-input`,
			width = v24.width
		})),
		Anchor = React.createElement(Popover.Anchor, {
			anchorRef = v28
		}),
		Calendar = React.createElement(Popover.Content, {
			hasArrow = false,
			onPressedOutside = v34,
			side = {
				position = PopoverSide.Bottom,
				offset = v25.Stroke.Standard + v25.Padding.Small
			},
			selection = v24.selection,
			selectionGroup = v24.selectionGroup
		}, v26 and React.createElement(View, {
			tag = "col auto-xy padding-large stroke-default radius-medium"
		}, {
			Calendar = React.createElement(Calendar, {
				LayoutOrder = 1,
				testId = "--foundation-calendar",
				defaultDates = v32,
				onSelectedDateChanged = v33,
				selectableDateRange = v24.selectableDateRange,
				showStartDateTimeCalendarInput = v24.variant ~= DateTimePickerVariant.SingleWithTime,
				showEndDateTimeCalendarInput = v24.variant == DateTimePickerVariant.Dual,
				showTimeDropdown = v24.variant == DateTimePickerVariant.SingleWithTime
			}),
			BottomBar = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row flex-fill gap-small size-full-0 auto-y padding-top-large"
			}, {
				ApplyButton = React.createElement(Button, {
					isDisabled = if v32 then if v24.variant ~= DateTimePickerVariant.Single and v24.variant ~= DateTimePickerVariant.SingleWithTime then v24.variant == DateTimePickerVariant.Dual and (v32[1] == nil or (v32[2] == nil or v32[1].UnixTimestamp > v32[2].UnixTimestamp)) else v32[1] == nil else false,
					onActivated = v38,
					text = Translator:FormatByKey("CommonUI.Controls.Action.Apply"),
					variant = ButtonVariant.Emphasis,
					testId = `{ v24.testId }--apply-button`
				}),
				CancelButton = React.createElement(Button, {
					onActivated = v34,
					text = Translator:FormatByKey("CommonUI.Controls.Action.Cancel"),
					variant = ButtonVariant.Standard,
					testId = `{ v24.testId }--cancel-button`
				})
			})
		}))
	})
end

return React.memo(DateTimePicker)
