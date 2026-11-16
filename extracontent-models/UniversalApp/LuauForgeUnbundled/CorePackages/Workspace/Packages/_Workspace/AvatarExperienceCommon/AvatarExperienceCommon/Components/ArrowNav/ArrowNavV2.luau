local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")
local icon = Foundation.Icon
local enums = Foundation.Enums

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Constants")
local useArrowNavScrollBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Hooks/useArrowNavScrollBehavior")

local function ArrowNavV2(props)
	local v5 = useArrowNavScrollBehavior({
		navDirection = props.navDirection,
		onPressHoldInputBegan = props.onPressHoldInputBegan,
		onPressHoldInputEnded = props.onPressHoldInputEnded,
		defaultUseProps = props.defaultUseProps
	})

	local handleInputBegan = v5.handleInputBegan
	local handleInputEnded = v5.handleInputEnded

	local v6 = React.useCallback(function() end, {})

	local v7 = props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT and "chevron-small-left"
		or "chevron-small-right"

	local actionStandard = props.tokens.Color.ActionStandard

	local color3 = props.tokens.Color.Surface.Surface_0.Color3
	local transparency = props.tokens.Color.Surface.Surface_0.Transparency

	local size_900 = props.tokens.Size.Size_900
	local medium = props.tokens.Padding.Medium
	local size_700 = props.tokens.Size.Size_700
	local size_100 = props.tokens.Size.Size_100

	local createElement = React.createElement
	local v9 = {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		Visible = props.Visible,
		Size = UDim2.fromOffset(size_900, size_900 + medium),
		BackgroundColor3 = color3,
		BackgroundTransparency = transparency,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local v12 = if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then Vector2.new(0, 0.5) else Vector2.new(1, 0.5)
	local v13 = if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then UDim2.new(1, 0, 0.5, 0) else UDim2.new(0, 0, 0.5, 0)
	local children = {
		GradientFrame = createElement2("Frame", {
			AnchorPoint = v12,
			Position = v13,
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
	local v15 = if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then Vector2.new(0, 0.5) else Vector2.new(1, 0.5)
	local v16 = if props.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then UDim2.new(0, size_100, 0.5, 0) else UDim2.new(1, 0, 0.5, 0)
	children.InnerFrame = createElement3(view, {
		AnchorPoint = v15,
		Position = v16,
		Size = UDim2.fromOffset(size_900, size_900),
		backgroundStyle = actionStandard.Background,
		cornerRadius = UDim.new(0.5, 0),
		onActivated = v6
	}, {
		ArrowIcon = React.createElement(icon, {
			name = v7,
			size = enums.IconSize.Medium,
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
	return createElement("Frame", v9, children)
end

return ArrowNavV2
