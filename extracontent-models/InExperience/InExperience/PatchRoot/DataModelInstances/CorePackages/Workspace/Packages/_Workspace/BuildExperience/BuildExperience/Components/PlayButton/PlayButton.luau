local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local DisabledPlaytestTooltip = require(script.Parent.DisabledPlaytestTooltip)

local function PlayButton(props)
	local icon

	if props.isActive then
		icon = props.activeIcon
	else
		icon = props.inActiveIcon
	end

	local isDisabled = props.isDisabled == true
	local state, setState = React.useState(false)

	local onActivated = React.useCallback(function()
		if isDisabled then
			setState(function(flag: boolean): boolean
				return not flag
			end)
		else
			props.onActivated()
		end
	end, { isDisabled, props.onActivated })
	local onPressedOutside = React.useCallback(function()
		setState(false)
	end, {})

	local v = {
		icon = icon,
		variant = props.variant or ButtonVariant.OverMedia,
		size = InputSize.Medium,
		isCircular = true,
		isDisabled = isDisabled or props.isUnavailable == true,
		onActivated = onActivated,
		LayoutOrder = 0,
		testId = 0
	}
	local layoutOrder

	if not isDisabled then
		layoutOrder = props.LayoutOrder
	end

	v.LayoutOrder = layoutOrder
	v.testId = not isDisabled and "build-header-play-button" or nil

	local element = React.createElement(IconButton, v)

	if isDisabled then
		return React.createElement(
			DisabledPlaytestTooltip,
			{ LayoutOrder = props.LayoutOrder, isOpen = state, onPressedOutside = onPressedOutside },
			{
				PlayButtonAnchor = React.createElement(View, {
					onActivated = onActivated,
					selection = { Selectable = true },
					tag = "auto-xy",
					testId = "build-header-play-button"
				}, { Button = element })
			}
		)
	end

	return element
end

return PlayButton
