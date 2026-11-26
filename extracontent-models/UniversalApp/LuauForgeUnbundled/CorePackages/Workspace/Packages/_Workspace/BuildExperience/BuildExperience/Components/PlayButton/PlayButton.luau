local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local DisabledPlaytestTooltip = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PlayButton/DisabledPlaytestTooltip")

local function PlayButton(props)
	local v5 = if props.isActive then props.activeIcon else props.inActiveIcon
	local isDisabled = props.isDisabled == true
	local state, setState = React.useState(false)

	local v6 = React.useCallback(function()
		if isDisabled then
			setState(function(p2): boolean
				return not p2
			end)
		else
			props.onActivated()
		end
	end, { isDisabled, props.onActivated })
	local v7 = React.useCallback(function()
		setState(false)
	end, {})

	local v8 = {
		icon = v5,
		variant = props.variant or buttonVariant.OverMedia,
		size = inputSize.Medium,
		isCircular = true,
		isDisabled = isDisabled or props.isUnavailable == true,
		onActivated = v6,
		LayoutOrder = 0,
		testId = 0
	}

	local v9 = if not isDisabled then props.LayoutOrder else nil
	v8.LayoutOrder = v9
	v8.testId = not isDisabled and "build-header-play-button" or nil

	local element = React.createElement(iconButton, v8)

	if isDisabled then
		return React.createElement(
			DisabledPlaytestTooltip,
			{ LayoutOrder = props.LayoutOrder, isOpen = state, onPressedOutside = v7 },
			{
				PlayButtonAnchor = React.createElement(view, {
					onActivated = v6,
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
