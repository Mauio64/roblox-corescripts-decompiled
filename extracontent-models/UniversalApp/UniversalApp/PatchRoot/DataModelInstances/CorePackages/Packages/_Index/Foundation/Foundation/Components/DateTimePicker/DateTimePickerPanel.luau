local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local DateTimeCalendarConstants = require(script.Parent.Utilities.DateTimeCalendarConstants)
local DateTimeLayoutUtilities = require(script.Parent.Utilities.DateTimeLayoutUtilities)

local Button = require(Foundation.Components.Button)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local Divider = require(Foundation.Components.Divider)
local Translator = require(Foundation.Utility.Localization.Translator)
local View = require(Foundation.Components.View)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function DateTimePickerPanel(props)
	local v = useTokens()
	local v2 = useScaledValue(DateTimeLayoutUtilities.PANE_WIDTH)
	local v3 = useScaledValue(DateTimeLayoutUtilities.CALENDAR_WIDTH)
	local v4 = useScaledValue(DateTimeLayoutUtilities.TIME_LIST_WIDTH)

	local element = React.createElement(Button, {
		isDisabled = props.isApplyButtonDisabled,
		LayoutOrder = 2,
		onActivated = props.onApply,
		testId = `{props.testId}--apply-button`,
		text = Translator:FormatByKey("CommonUI.Controls.Action.Apply"),
		variant = ButtonVariant.Emphasis
	})

	local element2 = React.createElement(Button, {
		LayoutOrder = 3,
		onActivated = props.onCancel,
		testId = `{props.testId}--cancel-button`,
		text = Translator:FormatByKey("CommonUI.Controls.Action.Cancel"),
		variant = ButtonVariant.Standard
	})

	local v5 = props.isSectioned and "padding-x-large padding-y-large" or "padding-top-large"
	local actions

	if props.showReset and props.onReset then
		actions = React.createElement(
			View,
			{
				LayoutOrder = 3,
				tag = `row align-y-center gap-small size-full-0 auto-y {v5}`
			},
			{
				ResetButton = React.createElement(Button, {
					isDisabled = props.isResetButtonDisabled,
					LayoutOrder = 1,
					onActivated = props.onReset,
					testId = `{props.testId}--reset-button`,
					text = Translator:FormatByKey("CommonUI.Controls.Action.ResetAll"),
					variant = ButtonVariant.Utility
				}),
				PrimaryActions = React.createElement(
					View,
					{ LayoutOrder = 2, tag = "row align-x-right grow gap-small auto-y" },
					{ ApplyButton = element, CancelButton = element2 }
				)
			}
		)
	else
		actions = React.createElement(
			View,
			{
				LayoutOrder = 3,
				tag = `row flex-fill gap-small size-full-0 auto-y {v5}`
			},
			{ ApplyButton = element, CancelButton = element2 }
		)
	end

	local v6 = 2 * v2 + 3 * v.Padding.Large
	local v7 = DateTimeLayoutUtilities.computeSingleWithTimeLayout(
		v3,
		v4,
		v,
		DateTimeCalendarConstants.NUM_CALENDAR_GRID_ROWS
	).contentWidth

	if props.sectionedLayout == "dual" then
		v7 = v6
	elseif props.sectionedLayout ~= "singleWithTime" then
		v7 = nil
	end

	local isSectioned = props.isSectioned == true
	local autoy = isSectioned and props.sectionedLayout ~= nil

	local createElement = React.createElement
	local size

	if v7 then
		size = UDim2.fromOffset(v7, 0)
	end

	local v8 = { Content = props.children, ActionsDivider = 0, Actions = 0 }
	local actionsDivider

	if props.isSectioned then
		actionsDivider = React.createElement(Divider, { LayoutOrder = 2 })
	end

	v8.ActionsDivider = actionsDivider

	v8.Actions = actions
	return createElement(View, {
		Size = size,
		tag = {
			col = true,
			["bg-surface-200"] = true,
			["stroke-default"] = true,
			["radius-large"] = true,
			["auto-y"] = autoy,
			["auto-xy"] = not autoy,
			clip = isSectioned,
			["padding-large"] = not isSectioned
		}
	}, v8)
end

return DateTimePickerPanel
