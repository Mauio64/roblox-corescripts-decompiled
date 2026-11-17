local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)

local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local PluginPopoverParentContext = require(Foundation.Providers.StudioPanels.PluginPopoverParentContext)
local PopoverAlign = require(Foundation.Enums.PopoverAlign)
local PopoverArrow = require(script.Parent.Parent.PopoverArrow)
require(script.Parent.Parent.Content)
local PopoverContext = require(script.Parent.Parent.PopoverContext)
local PopoverShadow = require(script.Parent.Parent.PopoverShadow)
local PopoverSide = require(Foundation.Enums.PopoverSide)
local getPanelPosition = require(script.Parent.getPanelPosition)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local usePanel = require(Foundation.Providers.StudioPanels.usePanel)
local usePanelsContext = require(Foundation.Providers.StudioPanels.usePanelsContext)
local StyleSheetContext = require(Foundation.Providers.Style.StyleSheetContext)
local useStyleSheet = StyleSheetContext.useStyleSheet
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local Logger = require(Foundation.Utility.Logger)
local Radius = require(Foundation.Enums.Radius)
require(Foundation.Utility.Plugin.StudioUri)
local View = require(Foundation.Components.View)
local elevation = require(Foundation.Providers.Elevation.elevation)
local positioning = require(script.Parent.Parent.positioning)
local useArrowPosition = require(script.Parent.useArrowPosition)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
require(Foundation.Components.Popover.useFloating)
local usePluginAnchor = require(script.Parent.usePluginAnchor)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local isPointInGuiObjectBounds = require(Foundation.Utility.isPointInGuiObjectBounds)

local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope

require(Foundation.Providers.StudioPanels.Types)
local v

if Flags.FoundationPluginShadowSize then
	v = Constants.PLUGIN_SHADOW_SIZE
else
	v = Constants.SHADOW_SIZE
end

local v2 = {
	side = PopoverSide.Bottom,
	align = PopoverAlign.Center,
	hasArrow = true,
	radius = Radius.Medium
}

local v3 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium",
	[Radius.Circle] = "radius-circle"
}

local function PopoverContentPlugin(p, p2)
	local v4 = withDefaults(p, v2)

	local v5 = usePanelsContext()
	local v6 = React.useContext(PluginPopoverParentContext)
	local id = v6.id

	local v7 = React.useContext(PopoverContext)
	local styleSheet = useStyleSheet()
	local v8 = useTokens()

	local owner = useElevation(ElevationLayer.Popover, { stackAboveOwner = true })
	local relativeIndex = elevation.getRelativeIndex(owner)

	local state, setState = React.useState(nil)
	React.useImperativeHandle(p2, function()
		return state
	end, { state })

	local parent2 = useOverlay()

	local v9 = React.useMemo(function()
		local popoverPluginContainer = Instance.new("Frame")
		popoverPluginContainer.Name = "PopoverPluginContainer"
		popoverPluginContainer.BackgroundTransparency = 1
		popoverPluginContainer.BorderSizePixel = 0
		popoverPluginContainer.ClipsDescendants = false
		popoverPluginContainer.Position = UDim2.fromOffset(-10000, -10000)
		return popoverPluginContainer
	end, {})
	React.useEffect(function()
		return function()
			v9:Destroy()
		end
	end, { v9 })

	local size, v10 = React.useBinding(UDim2.new())
	local contentSize, v11 = React.useBinding(UDim2.new())
	local state2, setState2 = React.useState(nil)

	local size_200 = v8.Size.Size_200
	local v12 = size_200 * 1.4142135623730951 / 2
	local backgroundStyle = v4.backgroundStyle or v8.Color.Surface.Surface_100
	local v13

	if v4.side then
		v13 = v4.side
	else
		v13 = PopoverSide.Bottom
	end

	local v14 = if v4.align then v4.align else PopoverAlign.Center
	local v15 = type(v13) ~= "table" and 0 or v13.offset
	local v16 = type(v14) ~= "table" and 0 or v14.offset
	local v17

	if type(v13) == "table" then
		v17 = v13.position
	else
		v17 = v13
	end

	if type(v14) == "table" then
		v14 = v14.position
	end

	local v18 = v14 == PopoverAlign.Center and 0.5 or v14 == PopoverAlign.End and 1 or 0

	local anchorUri = v7.anchorUri
	local v19 = usePluginAnchor(v7.anchor, anchorUri)
	local v20

	if v19.isVirtual then
		v20 = false
	else
		v20 = v4.hasArrow
	end

	local ready = v7.isOpen and v19.isReady and v6.ready
	local v21 = ready and parent2 ~= nil
	local v22 = v21 and state2 == nil

	React.useEffect(function()
		if not ready then
			setState2(nil)
		end
	end, { ready })

	local useCallback = React.useCallback
	local function fn(p3)
		if not (Flags.FoundationPopoverRecomputeContentSize or v22) then
			return
		end

		local absoluteSize = p3.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			setState2(absoluteSize)
		end
	end

	local v23

	if not Flags.FoundationPopoverRecomputeContentSize then
		v23 = v22
	end

	local onAbsoluteSizeChanged = useCallback(fn, { v23 })

	local position = React.useMemo(function()
		return getPanelPosition(v13, v4.align or PopoverAlign.Start, nil, v, not v20 and 0 or v12)
	end, { v13, v4.align, v20, v12 })

	local registerPanelAsync = React.useCallback(
		function(p3, p4, callback, p5: number?, p6: string?, flag: boolean?, vector2: Vector2?)
			local registerPopoverAsync = v5.registerPopoverAsync

			if not Flags.FoundationPopoverPluginFocusable then
				flag = nil
			end

			if not Flags.FoundationPopoverPluginPoolReclaim then
				vector2 = nil
			end

			return registerPopoverAsync(p3, p4, callback, p5, p6, flag, vector2)
		end,
		{ v5.registerPopoverAsync }
	)

	local ref = React.useRef(false)
	React.useEffect(function()
		if not (v4.onPressedOutside or ref.current) then
			ref.current = true
			Logger:warning("PopoverContent rendered in a plugin context without onPressedOutside. In Studio, the QWidget popup will close on focus loss, but the parent's isOpen state will not update. Provide onPressedOutside to stay in sync.")
		end
	end, { v4.onPressedOutside })

	local onClose = React.useCallback(function()
		if v4.onPressedOutside then
			if
				Flags.FoundationPopoverClickOutsideInGuiShadow
				and typeof(v7.anchor) == "Instance"
				and v7.anchor.GuiState ~= Enum.GuiState.Idle
			then
				return
			end

			v4.onPressedOutside()
		end
	end, { v4.onPressedOutside, v7.anchor })

	local depth = relativeIndex == nil and 0 or relativeIndex
	local v24

	if Flags.FoundationPopoverPluginPoolReclaim and state2 then
		v24 = positioning.calculatePopoverBounds(v17, v15, v16, not v20 and 0 or v12, state2) + Vector2.new(v * 2, v * 2)
	else
		v24 = nil
	end

	local isOpen

	if Flags.FoundationPopoverPluginPoolReclaim then
		isOpen = ready and v24 ~= nil
	else
		isOpen = ready
	end

	local v25 = {
		isOpen = isOpen,
		onClose = onClose,
		anchorUri = v19.uri,
		registerPanelAsync = registerPanelAsync,
		position = position,
		depth = depth,
		parentPopoverId = id,
		isFocusable = 0,
		initialSize = 0
	}
	local isFocusable

	if Flags.FoundationPopoverPluginFocusable then
		isFocusable = v4.isFocusable
	end

	v25.isFocusable = isFocusable
	local initialSize

	if Flags.FoundationPopoverPluginPoolReclaim then
		initialSize = v24
	end

	v25.initialSize = initialSize
	local v26 = usePanel(v25)

	React.useEffect(function()
		if not Flags.FoundationPopoverClickOutsideInGuiShadow then
			return
		end

		if v26 and v26.container and v4.onPressedOutside then
			local inputBeganConnection = v26.container.InputBegan:Connect(function(input)
				if not (input.UserInputType == Enum.UserInputType.MouseButton1 and state) then
					return
				end

				if not isPointInGuiObjectBounds(state, (Vector2.new(input.Position.X, input.Position.Y))) then
					v4.onPressedOutside()
				end
			end)
			return function()
				inputBeganConnection:Disconnect()
			end
		end
	end, { v26, state, v4.onPressedOutside })
	React.useLayoutEffect(function()
		if not v22 or state == nil then
			return
		end

		local absoluteSize = state.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 then
			setState2(absoluteSize)
		end
	end, { v22, state })
	local v27

	if Flags.FoundationPopoverPluginPoolReclaim then
		v27 = nil
	else
		v27 = React.useMemo(function()
			if state2 then
				return positioning.calculatePopoverBounds(v17, v15, v16, not v20 and 0 or v12, state2) + Vector2.new(v * 2, v * 2)
			end

			return nil
		end, { state2, v17, v15, v16, v20, v12 })
	end

	local useLayoutEffect = React.useLayoutEffect
	local function fn2()
		local v28

		if Flags.FoundationPopoverPluginPoolReclaim then
			v28 = v24
		else
			v28 = v27
		end

		if state2 == nil or v28 == nil then
			v11(UDim2.new())
			v10(UDim2.new())
		else
			v11(UDim2.fromOffset(state2.X, state2.Y))
			v10(UDim2.fromOffset(v28.X, v28.Y))

			if v26 then
				v26.setSizeAsync(v28)
			end
		end
	end

	local v28

	if Flags.FoundationPopoverPluginPoolReclaim then
		v28 = v24
	else
		v28 = v27
	end

	useLayoutEffect(fn2, { state2, v28, v26 })

	local useLayoutEffect2 = React.useLayoutEffect
	local function fn3()
		if not v21 then
			v9.Parent = nil
			return
		end

		local v29

		if Flags.FoundationPopoverPluginPoolReclaim then
			v29 = v24
		else
			v29 = v27
		end

		if v26 and v29 then
			v9.AutomaticSize = Enum.AutomaticSize.None
			v9.Size = UDim2.fromOffset(v29.X, v29.Y)
			v9.Position = UDim2.new()
			v9.Parent = v26.container
		else
			v9.AutomaticSize = Enum.AutomaticSize.XY
			v9.Size = UDim2.new()
			v9.Position = UDim2.fromOffset(-10000, -10000)
			v9.Parent = parent2
		end
	end

	local v29

	if Flags.FoundationPopoverPluginPoolReclaim then
		v29 = v24
	else
		v29 = v27
	end

	useLayoutEffect2(fn3, { v21, parent2, v26, v29, v9 })
	local anchor

	if not (v19.isVirtual or typeof(v7.anchor) ~= "Instance") then
		anchor = v7.anchor
	end

	local position2 = useArrowPosition(contentSize, v17, v4.radius, v18, v12, anchor)
	local ready2

	if v26 == nil then
		ready2 = false
	else
		local v30

		if Flags.FoundationPopoverPluginPoolReclaim then
			v30 = v24
		else
			v30 = v27
		end

		ready2 = v30 ~= nil
	end

	local v30 = React.useMemo(function()
		local id2

		if v26 then
			id2 = v26.popoverId
		end

		return { id = id2, ready = ready2 }
	end, { v26, ready2 })
	local panel

	if v21 and v9 then
		local createPortal = ReactRoblox.createPortal
		local createElement = React.createElement
		local fragment = React.Fragment
		local v31 = {
			StyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet }),
			Container = 0
		}

		local createElement2 = React.createElement
		local v32

		if Flags.FoundationPopoverPluginPoolReclaim then
			v32 = v24
		else
			v32 = v27
		end

		local automaticSize

		if v32 == nil then
			automaticSize = Enum.AutomaticSize.XY
		end

		local v60

		if Flags.FoundationPopoverPluginPoolReclaim then
			v60 = v24
		else
			v60 = v27
		end

		if v60 == nil then
			size = nil
		end

		local v57 = {
			AutomaticSize = automaticSize,
			Size = size,
			testId = `{v7.testId}--container`
		}
		local v61 = {
			Shadow = React.createElement(PopoverShadow, {
				contentSize = contentSize,
				position = UDim2.fromOffset(v / 2, v / 2 + (Flags.FoundationPluginShadowSize and 0 or 2)),
				radiusTag = v3[v4.radius],
				ZIndex = 1,
				testId = `{v7.testId}--shadow`
			}),
			Arrow = 0,
			Content = 0
		}
		local arrow

		if v20 then
			arrow = React.createElement(PopoverArrow, {
				size = size_200,
				position = position2,
				ZIndex = 2,
				backgroundStyle = backgroundStyle,
				testId = `{v7.testId}--arrow`
			})
		end

		v61.Arrow = arrow

		v61.Content = React.createElement(View, {
			tag = `auto-xy {v3[v4.radius]}`,
			Position = UDim2.fromOffset(v, v),
			ref = setState,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			backgroundStyle = backgroundStyle,
			ZIndex = 3,
			testId = `{v7.testId}--content`
		}, React.createElement(PluginPopoverParentContext.Provider, { value = v30 }, {
			Nested = React.createElement(ElevationOwnerScope, { owner = owner }, v4.children)
		}))
		v31.Container = createElement2(View, v57, v61)
		panel = createPortal(createElement(fragment, nil, v31), v9)
	end

	return React.createElement(React.Fragment, nil, { Anchor = v19.element, Panel = panel })
end

return React.forwardRef(PopoverContentPlugin)
