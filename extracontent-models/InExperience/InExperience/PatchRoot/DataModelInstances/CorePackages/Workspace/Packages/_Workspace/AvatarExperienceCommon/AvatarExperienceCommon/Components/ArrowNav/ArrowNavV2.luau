local AvatarExperienceCommon = script:FindFirstAncestor("AvatarExperienceCommon")
local AvatarExperienceCommonParent = AvatarExperienceCommon.Parent
local React = require(AvatarExperienceCommonParent.React)
local Foundation = require(AvatarExperienceCommonParent.Foundation)
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local Constants = require(AvatarExperienceCommon.Constants)
local useArrowNavScrollBehavior = require(AvatarExperienceCommon.Hooks.useArrowNavScrollBehavior)

local function ArrowNavV2(t1: {[any]: any}) -- line: 39
	-- upvalues: useArrowNavScrollBehavior (copy), React (copy), Constants (copy), Foundation (copy), Icon (copy), Enums (copy)
	local v11 = useArrowNavScrollBehavior({
		navDirection = t1.navDirection,
		onPressHoldInputBegan = t1.onPressHoldInputBegan,
		onPressHoldInputEnded = t1.onPressHoldInputEnded,
		defaultUseProps = t1.defaultUseProps
	})
	local handleInputBegan = v11.handleInputBegan
	local handleInputEnded = v11.handleInputEnded
	local v14 = React.useCallback(function() -- line: 52
	end, {})
	local s1 = "chevron-small-right"

	if t1.navDirection == Constants.NAVIGATION_DIRECTION.IS_LEFT then
		s1 = "chevron-small-left"
	end

	local ActionStandard = t1.tokens.Color.ActionStandard
	local Surface_0Color3 = t1.tokens.Color.Surface.Surface_0.Color3
	local Surface_0Transparency = t1.tokens.Color.Surface.Surface_0.Transparency
	local Size_900 = t1.tokens.Size.Size_900
	local Medium = t1.tokens.Padding.Medium
	local Size_700 = t1.tokens.Size.Size_700
	local Size_100 = t1.tokens.Size.Size_100

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		AnchorPoint = t1.AnchorPoint,
		Position = t1.Position,
		Visible = t1.Visible,
		Size = UDim2.fromOffset(Size_900, Size_900 + Medium),
		BackgroundColor3 = Surface_0Color3,
		BackgroundTransparency = Surface_0Transparency
	}, {
		GradientFrame = React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			AnchorPoint = if t1.navDirection ~= Constants.NAVIGATION_DIRECTION.IS_LEFT then Vector2.new(1, 0.5) else Vector2.new(0, 0.5),
			Position = if t1.navDirection ~= Constants.NAVIGATION_DIRECTION.IS_LEFT then UDim2.new(0, 0, 0.5, 0) else UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.fromOffset(Size_700, Size_900 + Medium),
			BackgroundColor3 = Surface_0Color3
		}, {
			UIGradient = React.createElement("UIGradient", {
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.9, 0),
					NumberSequenceKeypoint.new(1, 0)
				}),
				Rotation = t1.navDirection ~= Constants.NAVIGATION_DIRECTION.IS_LEFT and 0 or 180
			})
		}),
		InnerFrame = React.createElement(Foundation.View, {
			AnchorPoint = if t1.navDirection ~= Constants.NAVIGATION_DIRECTION.IS_LEFT then Vector2.new(1, 0.5) else Vector2.new(0, 0.5),
			Position = if t1.navDirection ~= Constants.NAVIGATION_DIRECTION.IS_LEFT then UDim2.new(1, 0, 0.5, 0) else UDim2.new(0, Size_100, 0.5, 0),
			Size = UDim2.fromOffset(Size_900, Size_900),
			backgroundStyle = ActionStandard.Background,
			cornerRadius = UDim.new(0.5, 0),
			onActivated = v14
		}, {
			ArrowIcon = React.createElement(Icon, {
				name = s1,
				size = Enums.IconSize.Medium,
				style = ActionStandard.Foreground,
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
	})
end

return ArrowNavV2
