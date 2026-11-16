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
local usePanelSizing = require(script.Parent.usePanelSizing)
local usePluginAnchor = require(script.Parent.usePluginAnchor)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local isPointInGuiObjectBounds = require(Foundation.Utility.isPointInGuiObjectBounds)

local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope

require(Foundation.Providers.StudioPanels.Types)
local v

if Flags.FoundationPopoverPluginOverlayMeasurement and Flags.FoundationPluginShadowSize then
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
	local v6

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v6 = React.useContext(PluginPopoverParentContext)
	end

	local parentPopoverId

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		parentPopoverId = v6.id
	else
		parentPopoverId = React.useContext(PluginPopoverParentContext)
	end

	local v7 = React.useContext(PopoverContext)
	local styleSheet = useStyleSheet()
	local v8 = useTokens()

	local owner = useElevation(ElevationLayer.Popover, { stackAboveOwner = true })
	local relativeIndex = elevation.getRelativeIndex(owner)

	local state, setState = React.useState(nil)
	React.useImperativeHandle(p2, function()
		return state
	end, { state })
	local parent2

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		parent2 = useOverlay()
	else
		parent2 = nil
	end

	local v9

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v9 = React.useMemo(function()
			local popoverPluginContainer = Instance.new("Frame")
			popoverPluginContainer.Name = "PopoverPluginContainer"
			popoverPluginContainer.BackgroundTransparency = 1
			popoverPluginContainer.BorderSizePixel = 0
			popoverPluginContainer.ClipsDescendants = false
			popoverPluginContainer.Position = UDim2.fromOffset(-10000, -10000)
			return popoverPluginContainer
		end, {})
	else
		v9 = nil
	end

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useEffect(function()
			return function()
				v9:Destroy()
			end
		end, { v9 })
	end

	local size, v10, contentSize, v11, state2, setState2

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		size, v10 = React.useBinding(UDim2.new())
		contentSize, v11 = React.useBinding(UDim2.new())
		state2, setState2 = React.useState(nil)
	else
		setState2 = nil
		state2 = nil
		v11 = nil
		v10 = nil
	end

	local size_200 = v8.Size.Size_200
	local v12 = size_200 * 1.4142135623730951 / 2
	local backgroundStyle = v4.backgroundStyle or v8.Color.Surface.Surface_100
	local v13, v14, v15, v16

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v13 = if v4.side then v4.side else PopoverSide.Bottom
		v14 = if v4.align then v4.align else PopoverAlign.Center
		v15 = type(v13) ~= "table" and 0 or v13.offset
		v16 = if type(v14) == "table" then v14.offset else 0
	else
		v13 = nil
		v15 = nil
		v16 = nil
	end

	local v17

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v17 = if type(v13) == "table" then v13.position else v13

		if type(v14) == "table" then
			v14 = v14.position
		end
	else
		if type(v4.side) == "table" then
			v17 = v4.side.position
		else
			v17 = v4.side or PopoverSide.Bottom
		end

		if type(v4.align) == "table" then
			v14 = v4.align.position
		else
			v14 = v4.align or PopoverAlign.Center
		end
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

	local ready, v21, v22

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		ready = v7.isOpen and v19.isReady and v6.ready
		v21 = ready and parent2 ~= nil
		v22 = v21 and state2 == nil
		React.useEffect(function()
			if not ready then
				setState2(nil)
			end
		end, { ready })
	else
		v22 = nil
		ready = nil
		v21 = nil
	end

	local onAbsoluteSizeChanged

	if Flags.FoundationPopoverPluginOverlayMeasurement then
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

		onAbsoluteSizeChanged = useCallback(fn, { v23 })
	end

	local useMemo = React.useMemo
	local function fn()
		local v23

		if Flags.FoundationPopoverPluginOverlayMeasurement then
			v23 = v13
		else
			v23 = v4.side or PopoverSide.Bottom
		end

		return getPanelPosition(v23, v4.align or PopoverAlign.Start, nil, v, not v20 and 0 or v12)
	end

	local v23

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v23 = v13
	else
		v23 = v4.side
	end

	local position = useMemo(fn, { v23, v4.align, v20, v12 })

	local registerPanelAsync = React.useCallback(function(p3, p4, callback, p5: number?, p6: string?, flag: boolean?)
		local registerPopoverAsync = v5.registerPopoverAsync

		if not Flags.FoundationPopoverPluginFocusable then
			flag = nil
		end

		return registerPopoverAsync(p3, p4, callback, p5, p6, flag)
	end, { v5.registerPopoverAsync })

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
	local isOpen

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		isOpen = ready
	else
		isOpen = v7.isOpen and v19.isReady
	end

	local v24 = {
		isOpen = isOpen,
		onClose = onClose,
		anchorUri = v19.uri,
		registerPanelAsync = registerPanelAsync,
		position = position,
		depth = depth,
		parentPopoverId = parentPopoverId,
		isFocusable = 0
	}
	local isFocusable

	if Flags.FoundationPopoverPluginFocusable then
		isFocusable = v4.isFocusable
	end

	v24.isFocusable = isFocusable
	local v25 = usePanel(v24)

	if not Flags.FoundationPopoverPluginOverlayMeasurement then
		size, contentSize = usePanelSizing(v4.side, v4.align, state, not v20 and 0 or v12, v25)
	end

	React.useEffect(function()
		if not Flags.FoundationPopoverClickOutsideInGuiShadow then
			return
		end

		if v25 and v25.container and v4.onPressedOutside then
			local inputBeganConnection = v25.container.InputBegan:Connect(function(input)
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
	end, { v25, state, v4.onPressedOutside })

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useLayoutEffect(function()
			if not v22 or state == nil then
				return
			end

			local absoluteSize = state.AbsoluteSize

			if absoluteSize.X > 0 and absoluteSize.Y > 0 then
				setState2(absoluteSize)
			end
		end, { v22, state })
	end

	local v26

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v26 = React.useMemo(function()
			if state2 then
				return positioning.calculatePopoverBounds(v17, v15, v16, not v20 and 0 or v12, state2) + Vector2.new(v * 2, v * 2)
			end

			return nil
		end, { state2, v17, v15, v16, v20, v12 })
	else
		v26 = nil
	end

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useLayoutEffect(function()
			if state2 == nil or v26 == nil then
				v11(UDim2.new())
				v10(UDim2.new())
			else
				v11(UDim2.fromOffset(state2.X, state2.Y))
				v10(UDim2.fromOffset(v26.X, v26.Y))

				if v25 then
					v25.setSizeAsync(v26)
				end
			end
		end, { state2, v26, v25 })

		React.useLayoutEffect(function()
			if not v21 then
				v9.Parent = nil
			elseif v25 and v26 then
				v9.AutomaticSize = Enum.AutomaticSize.None
				v9.Size = UDim2.fromOffset(v26.X, v26.Y)
				v9.Position = UDim2.new()
				v9.Parent = v25.container
			else
				v9.AutomaticSize = Enum.AutomaticSize.XY
				v9.Size = UDim2.new()
				v9.Position = UDim2.fromOffset(-10000, -10000)
				v9.Parent = parent2
			end
		end, { v21, parent2, v25, v26, v9 })
	end

	local v27

	if not (v19.isVirtual or typeof(v7.anchor) ~= "Instance") then
		v27 = v7.anchor
	end

	local position2 = useArrowPosition(contentSize, v17, v4.radius, v18, v12, v27)
	local ready2

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		if v25 == nil then
			ready2 = false
		else
			ready2 = v26 ~= nil
		end
	else
		ready2 = true
	end

	local v28

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v28 = v21
	else
		v28 = v25 ~= nil
	end

	local v29

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v29 = v9
	elseif v25 then
		v29 = v25.container
	end

	local v30

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		v30 = React.useMemo(function()
			local id

			if v25 then
				id = v25.popoverId
			end

			return { id = id, ready = ready2 }
		end, { v25, ready2 })
	end

	local panel

	if v28 and v29 then
		local createPortal = ReactRoblox.createPortal
		local createElement = React.createElement
		local fragment = React.Fragment
		local v31 = {
			StyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet }),
			Container = 0
		}

		local createElement2 = React.createElement
		local automaticSize

		if Flags.FoundationPopoverPluginOverlayMeasurement and v26 == nil then
			automaticSize = Enum.AutomaticSize.XY
		end

		if Flags.FoundationPopoverPluginOverlayMeasurement and v26 == nil then
			size = nil
		end

		local v32 = {
			AutomaticSize = automaticSize,
			Size = size,
			testId = `{v7.testId}--container`
		}
		local v52 = {
			Shadow = React.createElement(PopoverShadow, {
				contentSize = contentSize,
				position = UDim2.fromOffset(
					v / 2,
					v / 2 + (Flags.FoundationPopoverPluginOverlayMeasurement and Flags.FoundationPluginShadowSize and 0 or 2)
				),
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

		v52.Arrow = arrow

		local createElement3 = React.createElement

		local v54 = {
			tag = `auto-xy {v3[v4.radius]}`,
			Position = UDim2.fromOffset(v, v),
			ref = setState,
			onAbsoluteSizeChanged = 0,
			backgroundStyle = 0,
			ZIndex = 3,
			testId = 0
		}

		if not Flags.FoundationPopoverPluginOverlayMeasurement then
			onAbsoluteSizeChanged = nil
		end

		v54.onAbsoluteSizeChanged = onAbsoluteSizeChanged

		v54.backgroundStyle = backgroundStyle

		v54.testId = `{v7.testId}--content`

		local createElement4 = React.createElement
		local provider = PluginPopoverParentContext.Provider

		if not Flags.FoundationPopoverPluginOverlayMeasurement then
			v30 = v25.popoverId
		end

		v52.Content = createElement3(View, v54, createElement4(provider, { value = v30 }, {
			Nested = React.createElement(ElevationOwnerScope, { owner = owner }, v4.children)
		}))
		v31.Container = createElement2(View, v32, v52)
		local element = createElement(fragment, nil, v31)

		if not Flags.FoundationPopoverPluginOverlayMeasurement then
			v29 = v25.container
		end

		panel = createPortal(element, v29)
	end

	return React.createElement(React.Fragment, nil, { Anchor = v19.element, Panel = panel })
end

return React.forwardRef(PopoverContentPlugin)
