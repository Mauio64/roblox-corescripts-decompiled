local Parent = script:FindFirstAncestor("AppShortcutBar").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Motion = require(Parent.Motion)
local isBuilderIcon = Foundation.Utility.isBuilderIcon
local useTokens = Foundation.Hooks.useTokens
local Icon = Foundation.Icon

local function useAnimationValues(p1) -- line: 35
	-- upvalues: React (copy), Motion (copy)
	local v11 = React.useMemo(function() -- line: 36
		-- upvalues: Motion (copy)
		return {
			initial = Motion.createState({
				scale = 1,
				ringScale = 1
			}, {
				default = Motion.transition({
					duration = 0.2
				})
			}),
			target = Motion.createState({
				scale = 0.8,
				ringScale = 1.15
			}, {
				default = Motion.transition({
					duration = 0.3
				})
			})
		}
	end, {})
	local v12, v13 = Motion.useMotion(v11.initial)

	React.useEffect(function() -- line: 55
		-- upvalues: v13 (copy), p1 (copy), v11 (copy)
		v13(if not p1 then v11.initial else v11.target)
	end, {
		p1,
		v13,
		v11
	})

	return v12
end
local function CircularProgress(t1: {[any]: any}) -- line: 62
	-- upvalues: useTokens (copy), React (copy)
	local v15 = useTokens()
	local size = t1.size
	local progress = t1.progress
	local v18 = React.useMemo(function() -- line: 67
		-- upvalues: v15 (copy)
		return NumberSequence.new({
			NumberSequenceKeypoint.new(0, v15.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.4999, v15.Color.Content.Emphasis.Transparency),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0.5)
		})
	end, { v15 })
	local v19 = React.useMemo(function() -- line: 76
		-- upvalues: v15 (copy)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, v15.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.4999, v15.Color.Content.Emphasis.Color3),
			ColorSequenceKeypoint.new(0.5, v15.Color.Content.Muted.Color3),
			ColorSequenceKeypoint.new(1, v15.Color.Content.Muted.Color3)
		})
	end, { v15 })
	local v20 = React.useMemo(function() -- line: 85
		-- upvalues: progress (copy)
		if progress then
			return (progress:map(function(n1: number) -- line: 87
				return (math.clamp(n1 * 360, 180, 360))
			end))
		end

		return 180
	end, { progress })
	local v21 = React.useMemo(function() -- line: 93
		-- upvalues: progress (copy)
		if progress then
			return (progress:map(function(n2: number) -- line: 95
				return (math.clamp(n2 * 360, 0, 180))
			end))
		end

		return 0
	end, { progress })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = size
	}, {
		Left = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.fromScale(0.5, 1)
		}, {
			Image = React.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/Controls/RadialFill@3x.png",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(2, 1)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = v18,
					Color = v19,
					Rotation = v20
				})
			})
		}),
		Right = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Size = UDim2.fromScale(0.5, 1),
			Position = UDim2.fromScale(0.5, 0)
		}, {
			Image = React.createElement("ImageLabel", {
				Image = "rbxasset://textures/ui/Controls/RadialFill@3x.png",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(2, 1),
				Position = UDim2.fromScale(-1, 0)
			}, {
				Gradient = React.createElement("UIGradient", {
					Transparency = v18,
					Color = v19,
					Rotation = v21
				})
			})
		})
	})
end

function IconWithHoldAnimation(t2: {[any]: any}) -- line: 144
	-- upvalues: useAnimationValues (copy), React (copy), useTokens (copy), CircularProgress (copy), isBuilderIcon (copy), Icon (copy)
	local layoutOrder = t2.layoutOrder
	local size = t2.size
	local position = t2.position
	local anchorPoint = t2.anchorPoint
	local progress = t2.progress
	local icon = t2.icon
	local iconSize = t2.iconSize
	local v30 = useAnimationValues(progress)
	local v31, v32 = React.useBinding(iconSize)

	React.useEffect(function() -- line: 156
		-- upvalues: v32 (copy), iconSize (copy)
		v32(iconSize)
	end, { iconSize })

	local Default = useTokens().Color.Content.Default

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Size = size,
		Position = position,
		AnchorPoint = anchorPoint
	}, {
		AnimationFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		}, {
			UIScale = React.createElement("UIScale", {
				Scale = v30.scale
			}),
			RingFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				RingScale = React.createElement("UIScale", {
					Scale = v30.ringScale
				}),
				Progress = React.createElement(CircularProgress, {
					size = UDim2.fromScale(1, 1),
					progress = progress
				})
			}),
			IconFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				Icon = if isBuilderIcon(icon) then React.createElement(Icon, {
					name = icon,
					size = v31,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5)
				}) else React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Image = icon,
					ImageColor3 = Default.Color3,
					ImageTransparency = Default.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(iconSize, iconSize)
				})
			})
		})
	})
end

return IconWithHoldAnimation
