local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Constants = require(Foundation.Constants)
local Dash = require(FoundationParent.Dash)
local Image = require(Foundation.Components.Image)
local PopoverContext = require(script.Parent.Parent.PopoverContext)
local View = require(Foundation.Components.View)
local isPointInGuiObjectBounds = require(Foundation.Utility.isPointInGuiObjectBounds)
local useFloating = require(script.Parent.Parent.useFloating)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local usePointerPosition = require(Foundation.Utility.usePointerPosition)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local Flags = require(Foundation.Utility.Flags)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local Radius = require(Foundation.Enums.Radius)
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local ElevationLayer = require(Foundation.Enums.ElevationLayer)

require(Foundation.Components.Types)

local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope
local t1 = {
	hasArrow = true,
	side = PopoverSide.Bottom,
	align = PopoverAlign.Center,
	selection = Constants.MODAL.DISABLE_SELECTION,
	selectionGroup = Constants.MODAL.TRAP_FOCUS,
	radius = Radius.Medium
}
local t2 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium",
	[Radius.Circle] = "radius-circle"
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function PopoverContent(t3: {[any]: any}, p1) -- line: 77
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), PopoverContext (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePointerPosition (copy), useFloating (copy), isPointInGuiObjectBounds (copy), View (copy), StateLayerAffordance (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy), Flags (copy), Dash (copy), t2 (copy), ElevationOwnerScope (copy), ReactRoblox (copy)
	local v31 = withDefaults(t3, t1)
	local v32 = React.useContext(PopoverContext)
	local v33 = typeof(v32.anchor) == "Instance"
	local v34 = not not v33 and v31.hasArrow
	local v35 = useOverlay()
	local v36 = useTokens()
	local v37 = useElevation(ElevationLayer.Popover, {
		stackAboveOwner = true
	})
	local Size_200 = v36.Size.Size_200
	local v39 = Size_200 * 1.4142135623730951 / 2
	local v40 = v31.backgroundStyle or v36.Color.Surface.Surface_100
	local v41, v42 = React.useState(nil)
	local v43, v44 = React.useState(nil)
	local v45 = usePointerPosition(v43)

	React.useImperativeHandle(p1, function() -- line: 96
		-- upvalues: v41 (copy)
		return v41
	end, { v41 })

	local v46, v47, v48, v49, v50, v51 = useFloating(v32.isOpen, v32.anchor, v41, v35, v31.side, v31.align, not v34 and 0 or v39)
	local v52 = React.useRef(nil)
	local v53 = React.useCallback(function(p2) -- line: 112
		-- upvalues: v52 (copy), v44 (copy), v31 (copy), v32 (copy), v33 (copy), v45 (copy), isPointInGuiObjectBounds (copy)
		if v52.current then
			v52.current:Disconnect()
		end

		v44(p2)

		if p2 ~= nil and v31.onPressedOutside then
			v52.current = p2:GetPropertyChangedSignal("GuiState"):Connect(function() -- line: 119
				-- upvalues: p2 (copy), v32 (copy), v33 (copy), v45 (copy), isPointInGuiObjectBounds (copy), v31 (copy)
				if p2.GuiState == Enum.GuiState.Press then
					if v32.anchor and v33 then
						local anchor = v32.anchor
						local v63 = v45:getValue()

						if isPointInGuiObjectBounds(anchor, v63) then
							return
						end

						if anchor.GuiState ~= Enum.GuiState.Idle then
							return
						end
					end

					v31.onPressedOutside()
				end
			end)
		end
	end, {
		v31.onPressedOutside,
		v32.anchor
	})

	React.useEffect(function() -- line: 142
		-- upvalues: v52 (copy)
		return function() -- line: 143
			-- upvalues: v52 (copy)
			if v52.current then
				v52.current:Disconnect()
			end
		end
	end, {})

	local v54 = if not v32.isOpen then nil else React.createElement(View, {
		tag = "size-full",
		ZIndex = v37.zIndex,
		Visible = v47,
		testId = `{ v32.testId }--container`
	}, {
		Backdrop = if not v31.onPressedOutside or not v32.isOpen then nil else React.createElement(View, {
			ZIndex = 1,
			tag = "position-center-center anchor-center-center",
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			Size = UDim2.fromScale(2, 2),
			ref = v53,
			testId = `{ v32.testId }--backdrop`
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			AnchorPoint = v51,
			Image = SHADOW_IMAGE,
			Size = v48:map(function(uDim2: UDim2) -- line: 173
				-- upvalues: SHADOW_SIZE (copy)
				return uDim2 + UDim2.fromOffset(SHADOW_SIZE, SHADOW_SIZE)
			end),
			Position = React.joinBindings({
				v46,
				v51
			}):map(function(t4: {[any]: any}) -- line: 176
				-- upvalues: SHADOW_SIZE (copy)
				local v58 = t4[2].X ~= 0 and 1 or -1
				local v59 = t4[2].Y ~= 0 and 1 or -1

				return UDim2.fromOffset(t4[1].X + SHADOW_SIZE / 2 * v58, t4[1].Y + SHADOW_SIZE / 2 * v59 + 2)
			end),
			slice = {
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v36.Color.Extended.Black.Black_20,
			testId = `{ v32.testId }--shadow`
		}),
		Arrow = if not v34 then nil else React.createElement(View, {
			Rotation = 45,
			ZIndex = 3,
			tag = "anchor-center-center",
			Size = UDim2.fromOffset(Size_200, Size_200),
			Position = v49:map(function(vector2: Vector2) -- line: 194
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			backgroundStyle = v40,
			testId = `{ v32.testId }--arrow`
		}),
		Content = React.createElement(View, {
			ZIndex = 4,
			AnchorPoint = v51,
			Position = v46:map(function(vector2: Vector2) -- line: 206
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			selection = v31.selection,
			selectionGroup = v31.selectionGroup,
			sizeConstraint = {
				MaxSize = v50
			},
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = if not v31.onPressedOutside and (not Flags.FoundationCoachmarkInteractionFixes or not v31.DO_NOT_USE_hasContentInputSink) then nil else Dash.noop,
			backgroundStyle = v40,
			tag = `auto-xy { t2[v31.radius] }`,
			ref = v42,
			testId = `{ v32.testId }--content`
		}, React.createElement(ElevationOwnerScope, {
			owner = v37
		}, v31.children))
	})

	if v35 == nil then
		return v54
	end

	return ReactRoblox.createPortal(v54, v35)
end

return React.forwardRef(PopoverContent)
