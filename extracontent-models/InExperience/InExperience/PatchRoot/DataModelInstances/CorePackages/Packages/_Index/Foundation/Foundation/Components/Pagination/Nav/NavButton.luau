local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local ButtonVariant = require(Foundation.Enums.ButtonVariant)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local PaginationDirection = require(Foundation.Enums.PaginationDirection)

require(Foundation.Components.Types)

local PaginationSize = require(Foundation.Enums.PaginationSize)
local Icon = BuilderIcons.Icon
local t1 = {
	[PaginationDirection.First] = {
		testIdSuffix = "first",
		icon = Icon.ChevronSmallLeftToLine
	},
	[PaginationDirection.Backward] = {
		testIdSuffix = "back",
		icon = Icon.ChevronSmallLeft
	},
	[PaginationDirection.Forward] = {
		testIdSuffix = "forward",
		icon = Icon.ChevronSmallRight
	},
	[PaginationDirection.Last] = {
		testIdSuffix = "last",
		icon = Icon.ChevronSmallRightToLine
	}
}

local function getInputSize(p1) -- line: 43
	-- upvalues: PaginationSize (copy), InputSize (copy)
	if p1 == PaginationSize.Small then
		return InputSize.XSmall
	end

	return InputSize.Small
end
local function NavButton(p2, p3) -- line: 60
	-- upvalues: t1 (copy), React (copy), IconButton (copy), PaginationSize (copy), InputSize (copy), ButtonVariant (copy)
	local v17 = t1[p2.direction]
	local v18 = `{ p2.baseTestId }--{ v17.testIdSuffix }`
	local v19 = React.useCallback(function() -- line: 64
		-- upvalues: p2 (copy)
		p2.onDirectionActivated(p2.direction)
	end, {
		p2.onDirectionActivated,
		p2.direction
	})

	return React.createElement(IconButton, {
		isCircular = true,
		LayoutOrder = p2.layoutOrder,
		testId = v18,
		ref = p3,
		icon = v17.icon,
		size = if p2.slotSize ~= PaginationSize.Small then InputSize.Small else InputSize.XSmall,
		variant = ButtonVariant.Utility,
		isDisabled = p2.isDisabled,
		onActivated = v19,
		Selectable = p2.Selectable,
		NextSelectionLeft = p2.NextSelectionLeft,
		NextSelectionRight = p2.NextSelectionRight,
		NextSelectionUp = p2.NextSelectionUp,
		NextSelectionDown = p2.NextSelectionDown
	})
end

return React.memo(React.forwardRef(NavButton))
