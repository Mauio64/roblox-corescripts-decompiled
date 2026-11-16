local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local React = require(parent3.React)
require(parent.Style.StyleTypes)

local ImageSetComponent = require(parent2.Core.ImageSet.ImageSetComponent)
require(parent.ImageSet.ImagesTypes)

local function ScrollBar(props)
	local userInteractionEnabled = props.userInteractionEnabled
	local width = props.width
	local anchorPoint = props.anchorPoint
	local position = props.position
	local zIndex = props.zIndex
	local transparency = props.transparency
	local backgroundColor = props.backgroundColor
	local paddingStartEnd = props.paddingStartEnd

	local handleWidth = props.handleWidth
	local handleColor = props.handleColor
	local handleCornerRadius = props.handleCornerRadius
	local handleIcon = props.handleIcon
	local handleIconSize = props.handleIconSize
	local handleIconColor = props.handleIconColor
	local onDragging = props.onDragging

	local viewSize = props.viewSize
	local canvasSize = props.canvasSize
	local canvasPosition = props.canvasPosition

	local state, setState = React.useState(false)
	local v, v2 = React.useBinding(0)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(0)
	local ref2 = React.useRef(0)

	local v3 = React.useCallback(function(p)
		v2(p.AbsoluteSize.Y)
	end, { v2 })

	local v4 = React.useCallback(function(p)
		local parent4 = p.Parent

		if parent4 == nil or not (math.ceil(p.AbsoluteSize.Y) < parent4.AbsoluteSize.Y) then
			setState(false)
		else
			setState(true)
		end
	end, { setState })

	local size = React.useMemo(function()
		return React.joinBindings({ viewSize = viewSize, canvasSize = canvasSize }):map(function(p)
			local v5 = math.clamp(p.viewSize.Y / p.canvasSize.Y, 0, 1)
			return UDim2.new(0, handleWidth, v5, 0)
		end)
	end, { handleWidth, viewSize, canvasSize })

	local position2 = React.useMemo(function()
		return React.joinBindings({ canvasPosition = canvasPosition, canvasSize = canvasSize }):map(function(p)
			local v5 = p.canvasPosition.Y / p.canvasSize.Y
			return UDim2.fromScale(0.5, v5)
		end)
	end, { canvasSize, canvasPosition })

	local v5 = React.useCallback(function(_, p)
		if not state or not userInteractionEnabled or state2 then
			return
		end

		if p and p.UserInputType == Enum.UserInputType.MouseButton1 then
			ref.current = p.Position.Y
			ref2.current = canvasPosition:getValue().Y

			setState2(true)
		end
	end, { state, userInteractionEnabled, state2, ref, ref2, canvasPosition, setState2 })

	local v6 = React.useCallback(function(p)
		if not (userInteractionEnabled and state2 and p.UserInputType == Enum.UserInputType.MouseMovement) then
			return
		end

		local v6 = (p.Position.Y - ref.current) / (v:getValue() - paddingStartEnd)

		local y = viewSize:getValue().Y
		local current = ref2.current
		local y2 = canvasSize:getValue().Y
		onDragging((math.clamp(current + v6 * y2, 0, y2 - y)))
	end, {
		userInteractionEnabled,
		state2,
		ref,
		v,
		paddingStartEnd,
		viewSize,
		ref2,
		canvasSize,
		onDragging
	})

	local v7 = React.useCallback(function(p)
		if not (userInteractionEnabled and state2) or p and p.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		setState2(false)
	end, { userInteractionEnabled, state2, setState2 })

	React.useEffect(function()
		if not (state and state2) then
			return function() end
		end

		local inputChangedConnection = UserInputService.InputChanged:Connect(v6)
		local inputEndedConnection = UserInputService.InputEnded:Connect(v7)
		local windowFocusReleasedConnection = UserInputService.WindowFocusReleased:Connect(v7)

		return function()
			inputChangedConnection:Disconnect()
			inputEndedConnection:Disconnect()
			windowFocusReleasedConnection:Disconnect()
		end
	end, { state, state2, v6, v7 })

	local createElement = React.createElement
	local v8 = {
		Selectable = false,
		Size = UDim2.new(0, width, 1, 0),
		AnchorPoint = anchorPoint,
		Position = position,
		GroupTransparency = not state and 1 or state2 and 0 or transparency,
		BackgroundColor3 = 0,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		ZIndex = 0
	}
	local backgroundColor2

	if backgroundColor then
		backgroundColor2 = backgroundColor.Color
	end

	v8.BackgroundColor3 = backgroundColor2
	v8.BackgroundTransparency = not backgroundColor and 1 or backgroundColor.Transparency

	v8.ZIndex = zIndex
	local padding

	if paddingStartEnd then
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, paddingStartEnd),
			PaddingBottom = UDim.new(0, paddingStartEnd)
		})
	end

	local createElement2 = React.createElement
	local v9 = {
		Selectable = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		[React.Change.AbsoluteSize] = v3
	}
	local trackUICorner

	if handleCornerRadius then
		trackUICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, handleCornerRadius)
		})
	end

	local createElement3 = React.createElement
	local v10 = {
		["Active"] = nil,
		["Active"] = nil,
		["Active"] = nil,
		["Active"] = nil,
		Active = state and userInteractionEnabled,
		Selectable = false,
		Size = size,
		AnchorPoint = Vector2.new(0.5, 0),
		Position = position2
	}
	local backgroundColor3

	if handleColor then
		backgroundColor3 = handleColor.Color
	end

	v10.BackgroundColor3 = backgroundColor3
	v10.BackgroundTransparency = not handleColor and 0 or handleColor.Transparency
	v10.BorderSizePixel = 0
	v10[React.Change.AbsoluteSize] = v4
	v10[React.Event.InputBegan] = v5
	local handleUICorner

	if handleCornerRadius then
		handleUICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, handleCornerRadius)
		})
	end

	local icon

	if handleIcon then
		local createElement4 = React.createElement
		local label = ImageSetComponent.Label
		local v11 = {
			Selectable = false,
			Size = UDim2.fromOffset(handleIconSize, handleIconSize),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = handleIcon,
			ImageColor3 = 0,
			ImageTransparency = 0,
			BackgroundTransparency = 1
		}
		local imageColor

		if handleIconColor then
			imageColor = handleIconColor.Color
		end

		v11.ImageColor3 = imageColor
		local imageTransparency

		if handleIconColor then
			imageTransparency = handleIconColor.Transparency
		end

		v11.ImageTransparency = imageTransparency
		icon = createElement4(label, v11)
	end

	return createElement("CanvasGroup", v8, {
		Padding = padding,
		Track = createElement2("Frame", v9, {
			TrackUICorner = trackUICorner,
			Handle = createElement3("Frame", v10, { HandleUICorner = handleUICorner, Icon = icon })
		})
	})
end

return ScrollBar
