local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)

local PaginationDirection = require(Foundation.Enums.PaginationDirection)
require(Foundation.Components.Types)

local PaginationSize = require(Foundation.Enums.PaginationSize)

local Icon = BuilderIcons.Icon

local v = {
	[PaginationDirection.First] = { icon = Icon.ChevronSmallLeftToLine, testIdSuffix = "first" },
	[PaginationDirection.Backward] = { icon = Icon.ChevronSmallLeft, testIdSuffix = "back" },
	[PaginationDirection.Forward] = { icon = Icon.ChevronSmallRight, testIdSuffix = "forward" },
	[PaginationDirection.Last] = { icon = Icon.ChevronSmallRightToLine, testIdSuffix = "last" }
}

local function getInputSize(slotSize) -- 1 equivalent call inferred from this helper
	if slotSize == PaginationSize.Small then
		return InputSize.XSmall
	end

	return InputSize.Small
end

local function NavButton(props, ref)
	local v2 = v[props.direction]
	local formatted = `{props.baseTestId}--{v2.testIdSuffix}`

	local onActivated = React.useCallback(function()
		props.onDirectionActivated(props.direction)
	end, { props.onDirectionActivated, props.direction })

	return React.createElement(IconButton, {
		LayoutOrder = props.LayoutOrder,
		testId = formatted,
		ref = ref,
		icon = v2.icon,
		size = getInputSize(props.slotSize), -- inferred equivalent call
		variant = ButtonVariant.Utility,
		isCircular = true,
		isDisabled = props.isDisabled,
		onActivated = onActivated,
		Selectable = props.Selectable,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	})
end

return React.memo(React.forwardRef(NavButton))
