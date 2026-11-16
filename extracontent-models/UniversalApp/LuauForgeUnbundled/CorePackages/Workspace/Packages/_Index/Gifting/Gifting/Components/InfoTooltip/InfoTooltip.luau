local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local coachmark = Foundation.Coachmark
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide

local function InfoTooltip(props)
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)

	local v5 = React.useCallback(function()
		setState(false)
	end, {})

	local v6 = React.useCallback(function()
		setState(function(p2): boolean
			return not p2
		end)
	end, {})

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-none auto-xy padding-y-xxsmall",
			LayoutOrder = props.LayoutOrder
		},
		{
			Label = React.createElement(text, {
				tag = "auto-xy text-caption-small text-no-wrap content-default",
				Text = props.text,
				testId = `{props.testId}-note`,
				LayoutOrder = 1
			}),
			Info = React.createElement(iconButton, {
				icon = iconName.CircleI,
				size = inputSize.XSmall,
				onActivated = v6,
				ref = ref,
				testId = `{props.testId}-info`,
				LayoutOrder = 2
			}),
			Tooltip = React.createElement(coachmark, {
				title = props.tooltipTitle or "",
				text = props.tooltipText,
				isOpen = state,
				anchorRef = ref,
				onPressedOutside = v5,
				side = popoverSide.Top,
				align = popoverAlign.Center,
				testId = `{props.testId}-tooltip`
			})
		}
	)
end

return React.memo(InfoTooltip)
