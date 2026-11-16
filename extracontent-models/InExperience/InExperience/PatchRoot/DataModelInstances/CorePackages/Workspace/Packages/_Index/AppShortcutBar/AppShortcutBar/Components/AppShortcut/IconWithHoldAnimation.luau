local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local isBuilderIcon = Foundation.Utility.isBuilderIcon

local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon

local function useAnimationValues(progress)
	local v = React.useMemo(function()
		return {
			initial = Motion.createState({ scale = 1, ringScale = 1 }, {
				default = Motion.transition({ duration = 0.2 })
			}),
			target = Motion.createState({ scale = 0.8, ringScale = 1.15 }, {
				default = Motion.transition({ duration = 0.3 })
			})
		}
	end, {})

	local v2, v3 = Motion.useMotion(v.initial)
	React.useEffect(function()
		local v4 = if progress then v.target else v.initial
		v3(v4)
	end, { progress, v3, v })

	return v2
end

local function CircularProgress(p)
	local v = useTokens()
	local size = p.size
	local progress = p.progress

	local transparency = React.useMemo(function()
		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, v.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.4999, v.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0.5)
		})
	end, { v })

	local color = React.useMemo(function()
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, v.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.4999, v.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.5, v.Color.Content.Muted.Color3),
			ColorSequenceKeypoint.new(1, v.Color.Content.Muted.Color3)
		})
	end, { v })

	local rotation = React.useMemo(function()
		if progress then
			return (progress:map(function(p2: number)
				return (math.clamp(p2 * 360, 180, 360))
			end))
		end

		return 180
	end, { progress })

	local rotation2 = React.useMemo(function()
		if progress then
			return (progress:map(function(p2: number)
				return (math.clamp(p2 * 360, 0, 180))
			end))
		end

		return 0
	end, { progress })

	return React.createElement("Frame", { Size = size, BackgroundTransparency = 1 }, {
		Left = React.createElement(
			"Frame",
			{ Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, ClipsDescendants = true },
			{
				Image = React.createElement(
					"ImageLabel",
					{
						Image = "rbxasset://textures/ui/Controls/RadialFill@3x.png",
						Size = UDim2.fromScale(2, 1),
						BackgroundTransparency = 1
					},
					{
						Gradient = React.createElement("UIGradient", {
							Transparency = transparency,
							Color = color,
							Rotation = rotation
						})
					}
				)
			}
		),
		Right = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(0.5, 1),
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				Position = UDim2.fromScale(0.5, 0)
			},
			{
				Image = React.createElement(
					"ImageLabel",
					{
						Image = "rbxasset://textures/ui/Controls/RadialFill@3x.png",
						Size = UDim2.fromScale(2, 1),
						Position = UDim2.fromScale(-1, 0),
						BackgroundTransparency = 1
					},
					{
						Gradient = React.createElement("UIGradient", {
							Transparency = transparency,
							Color = color,
							Rotation = rotation2
						})
					}
				)
			}
		)
	})
end

function IconWithHoldAnimation(props)
	local layoutOrder = props.layoutOrder
	local size = props.size
	local position = props.position
	local anchorPoint = props.anchorPoint
	local progress = props.progress
	local icon = props.icon
	local iconSize = props.iconSize

	local v = useAnimationValues(progress)

	local size2, v2 = React.useBinding(iconSize)
	React.useEffect(function()
		v2(iconSize)
	end, { iconSize })

	local default = useTokens().Color.Content.Default

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v3 = {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1
	}

	local v4 = {
		UIScale = React.createElement("UIScale", { Scale = v.scale }),
		RingFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1
			},
			{
				RingScale = React.createElement("UIScale", { Scale = v.ringScale }),
				Progress = React.createElement(CircularProgress, {
					size = UDim2.fromScale(1, 1),
					progress = progress
				})
			}
		),
		IconFrame = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1
	}
	local icon2

	if isBuilderIcon(icon) then
		icon2 = React.createElement(Icon, {
			name = icon,
			size = size2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	else
		icon2 = React.createElement("ImageLabel", {
			Image = icon,
			BackgroundTransparency = 1,
			ImageColor3 = default.Color3,
			ImageTransparency = default.Transparency,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(iconSize, iconSize)
		})
	end

	v4.IconFrame = createElement3("Frame", v5, { Icon = icon2 })
	return createElement("Frame", {
		LayoutOrder = layoutOrder,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		BackgroundTransparency = 1
	}, {
		AnimationFrame = createElement2("Frame", v3, v4)
	})
end

return IconWithHoldAnimation
