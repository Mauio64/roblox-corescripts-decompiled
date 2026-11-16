local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Coachmark = Foundation.Coachmark
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide

local function InfoTooltip(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local onActivated = React.useCallback(function()
		setState(function(p): boolean
			return not p
		end)
	end, {})

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-none auto-xy padding-y-xxsmall",
			LayoutOrder = props.LayoutOrder
		},
		{
			Label = React.createElement(Text, {
				tag = "auto-xy text-caption-small text-no-wrap content-default",
				Text = props.text,
				testId = `{props.testId}-note`,
				LayoutOrder = 1
			}),
			Info = React.createElement(IconButton, {
				icon = IconName.CircleI,
				size = InputSize.XSmall,
				onActivated = onActivated,
				ref = ref,
				testId = `{props.testId}-info`,
				LayoutOrder = 2
			}),
			Tooltip = React.createElement(Coachmark, {
				title = props.tooltipTitle or "",
				text = props.tooltipText,
				isOpen = state,
				anchorRef = ref,
				onPressedOutside = onPressedOutside,
				side = PopoverSide.Top,
				align = PopoverAlign.Center,
				testId = `{props.testId}-tooltip`
			})
		}
	)
end

return React.memo(InfoTooltip)
