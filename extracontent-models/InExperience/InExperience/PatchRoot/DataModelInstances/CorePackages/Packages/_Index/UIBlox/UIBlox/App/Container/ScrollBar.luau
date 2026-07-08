local UserInputService = game:GetService("UserInputService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local React = require(ParentParentParentParent.React)

require(ParentParent.Style.StyleTypes)

local ImageSetComponent = require(ParentParentParent.Core.ImageSet.ImageSetComponent)

require(ParentParent.ImageSet.ImagesTypes)

local function ScrollBar(t1: {[any]: any}) -- line: 55
	-- upvalues: React (copy), UserInputService (copy), ImageSetComponent (copy)
	local userInteractionEnabled = t1.userInteractionEnabled
	local width = t1.width
	local anchorPoint = t1.anchorPoint
	local position = t1.position
	local zIndex = t1.zIndex
	local transparency = t1.transparency
	local backgroundColor = t1.backgroundColor
	local paddingStartEnd = t1.paddingStartEnd
	local handleWidth = t1.handleWidth
	local handleColor = t1.handleColor
	local handleCornerRadius = t1.handleCornerRadius
	local handleIcon = t1.handleIcon
	local handleIconSize = t1.handleIconSize
	local handleIconColor = t1.handleIconColor
	local onDragging = t1.onDragging
	local viewSize = t1.viewSize
	local canvasSize = t1.canvasSize
	local canvasPosition = t1.canvasPosition
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useBinding(0)
	local v31, v32 = React.useState(false)
	local v33 = React.useRef(0)
	local v34 = React.useRef(0)
	local v35 = React.useCallback(function(p1) -- line: 83
		-- upvalues: v30 (copy)
		v30(p1.AbsoluteSize.Y)
	end, { v30 })
	local v36 = React.useCallback(function(p2) -- line: 87
		-- upvalues: v28 (copy)
		local p2Parent = p2.Parent

		if p2Parent ~= nil and math.ceil(p2.AbsoluteSize.Y) < p2Parent.AbsoluteSize.Y then
			v28(true)

			return
		end

		v28(false)
	end, { v28 })
	local v37 = React.useMemo(function() -- line: 96
		-- upvalues: React (copy), viewSize (copy), canvasSize (copy), handleWidth (copy)
		return React.joinBindings({
			viewSize = viewSize,
			canvasSize = canvasSize
		}):map(function(p3) -- line: 100
			-- upvalues: handleWidth (copy)
			local v58 = math.clamp(p3.viewSize.Y / p3.canvasSize.Y, 0, 1)

			return UDim2.new(0, handleWidth, v58, 0)
		end)
	end, {
		handleWidth,
		viewSize,
		canvasSize
	})
	local v38 = React.useMemo(function() -- line: 108
		-- upvalues: React (copy), canvasPosition (copy), canvasSize (copy)
		return React.joinBindings({
			canvasPosition = canvasPosition,
			canvasSize = canvasSize
		}):map(function(p4) -- line: 112
			local v60 = p4.canvasPosition.Y / p4.canvasSize.Y

			return UDim2.fromScale(0.5, v60)
		end)
	end, {
		canvasSize,
		canvasPosition
	})
	local v39 = React.useCallback(function(_, p6) -- line: 120
		-- upvalues: v27 (copy), userInteractionEnabled (copy), v31 (copy), v33 (copy), v34 (copy), canvasPosition (copy), v32 (copy)
		if not v27 or (not userInteractionEnabled or v31) then
			return
		end

		if p6 and p6.UserInputType == Enum.UserInputType.MouseButton1 then
			v33.current = p6.Position.Y
			v34.current = canvasPosition:getValue().Y
			v32(true)
		end
	end, {
		v27,
		userInteractionEnabled,
		v31,
		v33,
		v34,
		canvasPosition,
		v32
	})
	local v40 = React.useCallback(function(p7) -- line: 141
		-- upvalues: userInteractionEnabled (copy), v31 (copy), v33 (copy), v29 (copy), paddingStartEnd (copy), viewSize (copy), v34 (copy), canvasSize (copy), onDragging (copy)
		if not userInteractionEnabled or not v31 then
			return
		end

		if p7.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end

		local v48 = (p7.Position.Y - v33.current) / (v29:getValue() - paddingStartEnd)
		local Y = viewSize:getValue().Y
		local current = v34.current
		local Y2 = canvasSize:getValue().Y
		local v52 = math.clamp(current + v48 * Y2, 0, Y2 - Y)

		onDragging(v52)
	end, {
		userInteractionEnabled,
		v31,
		v33,
		v29,
		paddingStartEnd,
		viewSize,
		v34,
		canvasSize,
		onDragging
	})
	local v41 = React.useCallback(function(p8) -- line: 172
		-- upvalues: userInteractionEnabled (copy), v31 (copy), v32 (copy)
		if not userInteractionEnabled or not v31 then
			return
		end

		if p8 and p8.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		v32(false)
	end, {
		userInteractionEnabled,
		v31,
		v32
	})

	React.useEffect(function() -- line: 184
		-- upvalues: v27 (copy), v31 (copy), UserInputService (copy), v40 (copy), v41 (copy)
		if not v27 or not v31 then
			return function() -- line: 186
			end
		end

		local connection = UserInputService.InputChanged:Connect(v40)
		local connection2 = UserInputService.InputEnded:Connect(v41)
		local connection3 = UserInputService.WindowFocusReleased:Connect(v41)

		return function() -- line: 193
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v27,
		v31,
		v40,
		v41
	})

	if not v27 then
		transparency = 1
	elseif v31 then
		transparency = 0
	end

	return React.createElement("CanvasGroup", {
		Selectable = false,
		BorderSizePixel = 0,
		Size = UDim2.new(0, width, 1, 0),
		AnchorPoint = anchorPoint,
		Position = position,
		GroupTransparency = transparency,
		BackgroundColor3 = if not backgroundColor then nil else backgroundColor.Color,
		BackgroundTransparency = not backgroundColor and 1 or backgroundColor.Transparency,
		ZIndex = zIndex
	}, {
		Padding = if not paddingStartEnd then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, paddingStartEnd),
			PaddingBottom = UDim.new(0, paddingStartEnd)
		}),
		Track = React.createElement("Frame", {
			Selectable = false,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			[React.Change.AbsoluteSize] = v35
		}, {
			TrackUICorner = if not handleCornerRadius then nil else React.createElement("UICorner", {
				CornerRadius = UDim.new(0, handleCornerRadius)
			}),
			Handle = React.createElement("Frame", {
				Active = v27 and userInteractionEnabled,
				Selectable = false,
				Size = v37,
				AnchorPoint = Vector2.new(0.5, 0),
				Position = v38,
				BackgroundColor3 = if not handleColor then nil else handleColor.Color,
				BackgroundTransparency = not handleColor and 0 or handleColor.Transparency,
				BorderSizePixel = 0,
				[React.Change.AbsoluteSize] = v36,
				[React.Event.InputBegan] = v39
			}, {
				HandleUICorner = if not handleCornerRadius then nil else React.createElement("UICorner", {
					CornerRadius = UDim.new(0, handleCornerRadius)
				}),
				Icon = if not handleIcon then nil else React.createElement(ImageSetComponent.Label, {
					Selectable = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(handleIconSize, handleIconSize),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = handleIcon,
					ImageColor3 = if not handleIconColor then nil else handleIconColor.Color,
					ImageTransparency = if not handleIconColor then nil else handleIconColor.Transparency
				})
			})
		})
	})
end

return ScrollBar
