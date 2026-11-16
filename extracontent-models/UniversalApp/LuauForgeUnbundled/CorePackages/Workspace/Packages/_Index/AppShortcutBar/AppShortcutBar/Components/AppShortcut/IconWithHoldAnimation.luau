local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Motion")
local isBuilderIcon = Foundation.Utility.isBuilderIcon

local useTokens = Foundation.Hooks.useTokens
local icon = Foundation.Icon

local function useAnimationValues(progress)
	local v5 = React.useMemo(function()
		return {
			initial = Motion.createState({ scale = 1, ringScale = 1 }, {
				default = Motion.transition({ duration = 0.2 })
			}),
			target = Motion.createState({ scale = 0.8, ringScale = 1.15 }, {
				default = Motion.transition({ duration = 0.3 })
			})
		}
	end, {})

	local v6, v7 = Motion.useMotion(v5.initial)
	React.useEffect(function()
		local v9 = if progress then v5.target else v5.initial
		v7(v9)
	end, { progress, v7, v5 })

	return v6
end

local function CircularProgress(p2)
	local v5 = useTokens()
	local size = p2.size
	local progress = p2.progress

	local v6 = React.useMemo(function()
		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, v5.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.4999, v5.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0.5)
		})
	end, { v5 })

	local v7 = React.useMemo(function()
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, v5.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.4999, v5.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.5, v5.Color.Content.Muted.Color3),
			ColorSequenceKeypoint.new(1, v5.Color.Content.Muted.Color3)
		})
	end, { v5 })

	local v8 = React.useMemo(function()
		if progress then
			return (progress:map(function(p3)
				return (math.clamp(p3 * 360, 180, 360))
			end))
		end

		return 180
	end, { progress })

	local v9 = React.useMemo(function()
		if progress then
			return (progress:map(function(p3)
				return (math.clamp(p3 * 360, 0, 180))
			end))
		end

		return 0
	end, { progress })

	return React.createElement("Frame", { Size = size, BackgroundTransparency = 1 }, {
		Left = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(0.5, 1),
				BackgroundTransparency = 1,
				ClipsDescendants = true
			},
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
							Transparency = v6,
							Color = v7,
							Rotation = v8
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
							Transparency = v6,
							Color = v7,
							Rotation = v9
						})
					}
				)
			}
		)
	})
end

function LUAUFORGE_MODULE_GLOBALS_bQH_IconWithHoldAnimation(props)
	local layoutOrder = props.layoutOrder
	local size = props.size
	local position = props.position
	local anchorPoint = props.anchorPoint
	local progress = props.progress
	local icon2 = props.icon
	local iconSize = props.iconSize

	local v5 = useAnimationValues(progress)

	local v6, v7 = React.useBinding(iconSize)
	React.useEffect(function()
		v7(iconSize)
	end, { iconSize })

	local default = useTokens().Color.Content.Default

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1
	}

	local v13 = {
		UIScale = React.createElement("UIScale", { Scale = v5.scale }),
		RingFrame = React.createElement(
			"Frame",
			{
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1
			},
			{
				RingScale = React.createElement("UIScale", { Scale = v5.ringScale }),
				Progress = React.createElement(CircularProgress, {
					size = UDim2.fromScale(1, 1),
					progress = progress
				})
			}
		),
		IconFrame = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1
	}

	local v17 = if isBuilderIcon(icon2) then React.createElement(icon, {
		name = icon2,
		size = v6,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5)
	}) else React.createElement("ImageLabel", {
		Image = icon2,
		BackgroundTransparency = 1,
		ImageColor3 = default.Color3,
		ImageTransparency = default.Transparency,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(iconSize, iconSize)
	})
	v13.IconFrame = createElement3("Frame", v15, { Icon = v17 })
	return createElement("Frame", {
		LayoutOrder = layoutOrder,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint,
		BackgroundTransparency = 1
	}, {
		AnimationFrame = createElement2("Frame", v12, v13)
	})
end

return LUAUFORGE_MODULE_GLOBALS_bQH_IconWithHoldAnimation
