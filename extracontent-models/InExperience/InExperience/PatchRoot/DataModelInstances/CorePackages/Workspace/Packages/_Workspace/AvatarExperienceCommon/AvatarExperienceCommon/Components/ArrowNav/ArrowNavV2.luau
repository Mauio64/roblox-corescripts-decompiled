local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")

local parent = AvatarExperienceCommon.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local Enums = Foundation.Enums

local Constants = require(AvatarExperienceCommon.Constants)
local useArrowNavScrollBehavior = require(AvatarExperienceCommon.Hooks.useArrowNavScrollBehavior)

local function ArrowNavV2(props)
	local v = useArrowNavScrollBehavior({
		navDirection = props.navDirection,
		onPressHoldInputBegan = props.onPressHoldInputBegan,
		onPressHoldInputEnded = props.onPressHoldInputEnded,
		defaultUseProps = props.defaultUseProps
	})

	local handleInputBegan = v.handleInputBegan
	local handleInputEnded = v.handleInputEnded

	local onActivated = React.useCallback(function() end, {})

	local name = props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT and "chevron-small-left"
		or "chevron-small-right"

	local actionStandard = props.tokens.Color.ActionStandard

	local color3 = props.tokens.Color.Surface.Surface_0.Color3
	local transparency = props.tokens.Color.Surface.Surface_0.Transparency

	local size_900 = props.tokens.Size.Size_900
	local medium = props.tokens.Padding.Medium
	local size_700 = props.tokens.Size.Size_700
	local size_100 = props.tokens.Size.Size_100

	local createElement = React.createElement
	local v2 = {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Visible = props.Visible,
		Size = UDim2.fromOffset(size_900, size_900 + medium),
		BackgroundColor3 = color3,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local anchorPoint

	if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then
		anchorPoint = Vector2.new(0, 0.5)
	else
		anchorPoint = Vector2.new(1, 0.5)
	end

	local position

	if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then
		position = UDim2.new(1, 0, 0.5, 0)
	else
		position = UDim2.new(0, 0, 0.5, 0)
	end

	local children = {
		GradientFrame = createElement2("Frame", {
			AnchorPoint = anchorPoint,
			Position = position,
			Size = UDim2.fromOffset(size_700, size_900 + medium),
			BackgroundColor3 = color3,
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		}, {
			UIGradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.9, 0),
					NumberSequenceKeypoint.new(1, 0)
				}),
				Rotation = props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT and 180 or 0
			})
		}),
		InnerFrame = 0
	}

	local createElement3 = React.createElement
	local view = Foundation.View
	local anchorPoint2

	if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then
		anchorPoint2 = Vector2.new(0, 0.5)
	else
		anchorPoint2 = Vector2.new(1, 0.5)
	end

	local position2

	if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then
		position2 = UDim2.new(0, size_100, 0.5, 0)
	else
		position2 = UDim2.new(1, 0, 0.5, 0)
	end

	children.InnerFrame = createElement3(view, {
		AnchorPoint = anchorPoint2,
		Position = position2,
		Size = UDim2.fromOffset(size_900, size_900),
		backgroundStyle = actionStandard.Background,
		cornerRadius = UDim.new(0.5, 0),
		onActivated = onActivated
	}, {
		ArrowIcon = React.createElement(Icon, {
			name = name,
			size = Enums.IconSize.Medium,
			style = actionStandard.Foreground,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}),
		StopPropagationOverlay = React.createElement("TextButton", {
			Active = false,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			Text = "",
			ZIndex = 0,
			[React.Event.InputBegan] = handleInputBegan,
			[React.Event.InputEnded] = handleInputEnded
		})
	})
	return createElement("Frame", v2, children)
end

return ArrowNavV2
