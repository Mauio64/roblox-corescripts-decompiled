local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Constants = require(Foundation.Constants)
local Dash = require(parent.Dash)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
local PopoverContext = require(script.Parent.Parent.PopoverContext)
local View = require(Foundation.Components.View)
local isPointInGuiObjectBounds = require(Foundation.Utility.isPointInGuiObjectBounds)
local useFloating = require(script.Parent.Parent.useFloating)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local usePointerPosition = require(Foundation.Utility.usePointerPosition)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local ElevationLayer = require(Foundation.Enums.ElevationLayer)
require(Foundation.Components.Types)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope

local v = {
	side = PopoverSide.Bottom,
	align = PopoverAlign.Center,
	hasArrow = true,
	selection = Constants.MODAL.DISABLE_SELECTION,
	selectionGroup = Constants.MODAL.TRAP_FOCUS,
	radius = Radius.Medium
}

local v2 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium",
	[Radius.Circle] = "radius-circle"
}

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function PopoverContent(p, p2)
	local v3 = withDefaults(p, v)
	local v4 = React.useContext(PopoverContext)
	local v5 = typeof(v4.anchor) == "Instance"
	local v6 = if v5 then v3.hasArrow else false
	local v7 = useOverlay()

	local v8 = useTokens()
	local owner = useElevation(ElevationLayer.Popover, { stackAboveOwner = true })

	local size_200 = v8.Size.Size_200
	local v9 = size_200 * 1.4142135623730951 / 2
	local backgroundStyle = v3.backgroundStyle or v8.Color.Surface.Surface_100

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local v10 = usePointerPosition(state2)

	React.useImperativeHandle(p2, function()
		return state
	end, { state })

	local v11, visible, size, v12, maxSize, anchorPoint = useFloating(
		v4.isOpen,
		v4.anchor,
		state,
		v7,
		v3.side,
		v3.align,
		not v6 and 0 or v9
	)

	local ref = React.useRef(nil)

	local ref2 = React.useCallback(function(instance)
		if ref.current then
			ref.current:Disconnect()
		end

		setState2(instance)

		if instance ~= nil and v3.onPressedOutside then
			ref.current = instance:GetPropertyChangedSignal("GuiState"):Connect(function()
				if instance.GuiState == Enum.GuiState.Press then
					if v4.anchor and v5 then
						local anchor = v4.anchor

						if
							isPointInGuiObjectBounds(anchor, (v10:getValue()))
							or anchor.GuiState ~= Enum.GuiState.Idle
						then
							return
						end
					end

					v3.onPressedOutside()
				end
			end)
		end
	end, { v3.onPressedOutside, v4.anchor })

	React.useEffect(function()
		return function()
			if ref.current then
				ref.current:Disconnect()
			end
		end
	end, {})
	local position

	if Flags.FoundationPopoverContentAnchorFix then
		position = React.joinBindings({ v11, anchorPoint, size }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local item3 = list[3]
			return UDim2.fromOffset(item.X - item2.X * item3.X.Offset, item.Y - item2.Y * item3.Y.Offset)
		end)
	end

	local v13

	if v4.isOpen then
		local createElement = React.createElement
		local v14 = {
			ZIndex = owner.zIndex,
			tag = "size-full",
			Visible = visible,
			testId = `{v4.testId}--container`
		}
		local backdrop

		if v3.onPressedOutside and v4.isOpen then
			backdrop = React.createElement(View, {
				ZIndex = 1,
				stateLayer = { affordance = StateLayerAffordance.None },
				Size = UDim2.fromScale(2, 2),
				tag = "position-center-center anchor-center-center",
				ref = ref2,
				testId = `{v4.testId}--backdrop`
			})
		end

		local shadow

		if Flags.FoundationPopoverOverlayShadow then
			shadow = React.createElement(View, {
				AnchorPoint = anchorPoint,
				Size = size,
				Position = v11:map(function(vector2: Vector2)
					return UDim2.fromOffset(vector2.X, vector2.Y)
				end),
				ZIndex = 2,
				tag = `shadow-overlay-300 {v2[v3.radius]}`,
				testId = `{v4.testId}--shadow`
			})
		else
			shadow = React.createElement(Image, {
				AnchorPoint = anchorPoint,
				Image = SHADOW_IMAGE,
				Size = size:map(function(udim: UDim2)
					return udim + UDim2.fromOffset(SHADOW_SIZE, SHADOW_SIZE)
				end),
				Position = React.joinBindings({ v11, anchorPoint }):map(function(list)
					local v15 = list[2].X == 0 and -1 or 1
					local v16 = list[2].Y == 0 and -1 or 1
					return UDim2.fromOffset(list[1].X + SHADOW_SIZE / 2 * v15, list[1].Y + SHADOW_SIZE / 2 * v16 + 2)
				end),
				ZIndex = 2,
				slice = {
					center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
				},
				imageStyle = v8.Color.Extended.Black.Black_20,
				testId = `{v4.testId}--shadow`
			})
		end

		local arrow

		if v6 then
			arrow = React.createElement(View, {
				Size = UDim2.fromOffset(size_200, size_200),
				Position = v12:map(function(vector2: Vector2)
					return UDim2.fromOffset(vector2.X, vector2.Y)
				end),
				Rotation = 45,
				ZIndex = 3,
				backgroundStyle = backgroundStyle,
				tag = "anchor-center-center",
				testId = `{v4.testId}--arrow`
			})
		end

		local createElement2 = React.createElement

		if Flags.FoundationPopoverContentAnchorFix then
			anchorPoint = Vector2.zero
		end

		if not Flags.FoundationPopoverContentAnchorFix then
			position = v11:map(function(vector2: Vector2)
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end)
		end

		local v15 = {
			AnchorPoint = anchorPoint,
			Position = position,
			selection = v3.selection,
			selectionGroup = v3.selectionGroup,
			sizeConstraint = { MaxSize = maxSize },
			stateLayer = { affordance = StateLayerAffordance.None },
			ZIndex = 4,
			onActivated = 0,
			backgroundStyle = 0,
			tag = 0,
			ref = 0,
			testId = 0
		}
		local onActivated

		if v3.onPressedOutside or v3.DO_NOT_USE_hasContentInputSink then
			onActivated = Dash.noop
		end

		v15.onActivated = onActivated
		v15.backgroundStyle = backgroundStyle
		v15.tag = `auto-xy {v2[v3.radius]}`
		v15.ref = setState
		v15.testId = `{v4.testId}--content`
		v13 = createElement(View, v14, {
			Backdrop = backdrop,
			Shadow = shadow,
			Arrow = arrow,
			Content = createElement2(
				View,
				v15,
				React.createElement(ElevationOwnerScope, { owner = owner }, v3.children)
			)
		})
	end

	if v7 == nil then
		return v13
	end

	return ReactRoblox.createPortal(v13, v7)
end

return React.forwardRef(PopoverContent)
