local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ReactRoblox = require(FoundationParent.ReactRoblox)
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
local useStyleSheet = require(Foundation.Providers.Style.StyleSheetContext).useStyleSheet
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
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope

require(Foundation.Providers.StudioPanels.Types)

local SHADOW_SIZE = Constants.SHADOW_SIZE
local t1 = {
	hasArrow = true,
	side = PopoverSide.Bottom,
	align = PopoverAlign.Center,
	radius = Radius.Medium
}
local t2 = {
	[Radius.Small] = "radius-small",
	[Radius.Medium] = "radius-medium",
	[Radius.Circle] = "radius-circle"
}

local function PopoverContentPlugin(p1, p2) -- line: 66
	-- upvalues: withDefaults (copy), t1 (copy), usePanelsContext (copy), Flags (copy), React (copy), PluginPopoverParentContext (copy), PopoverContext (copy), useStyleSheet (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), elevation (copy), useOverlay (copy), PopoverSide (copy), PopoverAlign (copy), usePluginAnchor (copy), getPanelPosition (copy), SHADOW_SIZE (copy), Logger (copy), usePanel (copy), usePanelSizing (copy), positioning (copy), useArrowPosition (copy), ReactRoblox (copy), View (copy), PopoverShadow (copy), PopoverArrow (copy), t2 (copy), ElevationOwnerScope (copy)
	local v37 = withDefaults(p1, t1)
	local v38 = usePanelsContext()
	local v39 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else React.useContext(PluginPopoverParentContext)
	local v40 = if not Flags.FoundationPopoverPluginOverlayMeasurement then React.useContext(PluginPopoverParentContext) else v39.id
	local v41 = React.useContext(PopoverContext)
	local v42 = useStyleSheet()
	local v43 = useTokens()
	local v44 = nil
	local v45 = nil

	if Flags.FoundationPopoverPluginDepthPool then
		v45 = useElevation(ElevationLayer.Popover, {
			stackAboveOwner = true
		})
		v44 = elevation.getRelativeIndex(v45)
	end

	local v46, v47 = React.useState(nil)

	React.useImperativeHandle(p2, function() -- line: 91
		-- upvalues: v46 (copy)
		return v46
	end, { v46 })

	local v48 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else useOverlay()
	local v49 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else React.useMemo(function() -- line: 101
		local Frame = Instance.new("Frame")

		Frame.Name = "PopoverPluginContainer"
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.ClipsDescendants = false
		Frame.Position = UDim2.fromOffset(-10000, -10000)

		return Frame
	end, {})

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useEffect(function() -- line: 113
			-- upvalues: v49 (copy)
			return function() -- line: 114
				-- upvalues: v49 (copy)
				v49:Destroy()
			end
		end, { v49 })
	end

	local v50 = nil
	local u51 = nil
	local v52 = nil
	local u53 = nil
	local u54 = nil
	local u55 = nil

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		local v56

		v50, v56 = React.useBinding(UDim2.new())
		u51 = v56

		local v57

		v52, v57 = React.useBinding(UDim2.new())
		u53 = v57

		local v58, v59 = React.useState(nil)

		u54 = v58
		u55 = v59
	end

	local Size_200 = v43.Size.Size_200
	local v61 = Size_200 * 1.4142135623730951 / 2
	local v62 = v37.backgroundStyle or v43.Color.Surface.Surface_100
	local u63 = nil
	local v64 = nil
	local u65 = nil
	local u66 = nil

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		u63 = if not v37.side then PopoverSide.Bottom else v37.side
		v64 = if not v37.align then PopoverAlign.Center else v37.align
		u65 = type(u63) ~= "table" and 0 or u63.offset
		u66 = type(v64) ~= "table" and 0 or v64.offset
	end

	local u67, v68

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		u67 = if type(u63) ~= "table" then u63 else u63.position
		v68 = if type(v64) ~= "table" then v64 else v64.position
	else
		u67 = if type(v37.side) ~= "table" then v37.side or PopoverSide.Bottom else v37.side.position
		v68 = if type(v37.align) ~= "table" then v37.align or PopoverAlign.Center else v37.align.position
	end

	local n1 = 0

	if v68 == PopoverAlign.Center then
		n1 = 0.5
	elseif v68 == PopoverAlign.End then
		n1 = 1
	end

	local v70 = if not Flags.FoundationPopoverPluginUriAnchor then nil else v41.anchorUri
	local v71 = usePluginAnchor(v41.anchor, v70)
	local v72 = not v71.isVirtual and v37.hasArrow
	local u73 = nil
	local u74 = nil
	local u75 = nil

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		u73 = v41.isOpen and (v71.isReady and v39.ready)
		u74 = u73 and v48 ~= nil
		u75 = u74 and u54 == nil
		React.useEffect(function() -- line: 175
			-- upvalues: u73 (ref), u55 (ref)
			if not u73 then
				u55(nil)
			end
		end, { u73 })
	end

	local v76 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else React.useCallback(function(p3) -- line: 183
		-- upvalues: u75 (ref), u55 (ref)
		if not u75 then
			return
		end

		local AbsoluteSize = p3.AbsoluteSize

		if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
			u55(AbsoluteSize)
		end
	end, { u75 })
	local v77 = React.useMemo(function() -- line: 195
		-- upvalues: getPanelPosition (copy), Flags (copy), u63 (ref), v37 (copy), PopoverSide (copy), PopoverAlign (copy), SHADOW_SIZE (copy), v72 (copy), v61 (copy)
		return getPanelPosition(if not Flags.FoundationPopoverPluginOverlayMeasurement then v37.side or PopoverSide.Bottom else u63, v37.align or PopoverAlign.Start, nil, SHADOW_SIZE, not v72 and 0 or v61)
	end, {
		if not Flags.FoundationPopoverPluginOverlayMeasurement then v37.side else u63,
		v37.align,
		v72,
		v61
	})
	local v78 = React.useCallback(function(p4, p5, p6: ((...any) -> ...any), n2: number?) -- line: 213
		-- upvalues: Flags (copy), v40 (copy), v38 (copy)
		local v98 = if not Flags.FoundationPopoverPluginDepthPool then nil else v40

		return v38.registerPopoverAsync(p4, p5, p6, n2, v98)
	end, {
		v38.registerPopoverAsync,
		v40
	})
	local v79 = React.useRef(false)

	React.useEffect(function() -- line: 221
		-- upvalues: v37 (copy), v79 (copy), Logger (copy)
		if not v37.onPressedOutside and not v79.current then
			v79.current = true
			Logger:warning("PopoverContent rendered in a plugin context without onPressedOutside. In Studio, the QWidget popup will close on focus loss, but the parent's isOpen state will not update. Provide onPressedOutside to stay in sync.")
		end
	end, { v37.onPressedOutside })

	local v80 = React.useCallback(function() -- line: 232
		-- upvalues: v37 (copy)
		if v37.onPressedOutside then
			v37.onPressedOutside()
		end
	end, { v37.onPressedOutside })
	local v81 = if not Flags.FoundationPopoverPluginDepthPool then v44 else v44 == nil and 0 or v44
	local v82 = usePanel({
		isOpen = if not Flags.FoundationPopoverPluginOverlayMeasurement then v41.isOpen and v71.isReady else u73,
		onClose = v80,
		anchorUri = v71.uri,
		registerPanelAsync = v78,
		position = v77,
		depth = v81,
		parentPopoverId = if not Flags.FoundationPopoverPluginDepthPool then nil else v40
	})

	if Flags.FoundationPopoverPluginOverlayMeasurement then
	else
		v50, v52 = usePanelSizing(v37.side, v37.align, v46, not v72 and 0 or v61, v82)
	end

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useLayoutEffect(function() -- line: 262
			-- upvalues: u75 (ref), v46 (copy), u55 (ref)
			if not u75 or v46 == nil then
				return
			end

			local AbsoluteSize = v46.AbsoluteSize

			if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
				u55(AbsoluteSize)
			end
		end, {
			u75,
			v46
		})
	end

	local v83 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else React.useMemo(function() -- line: 275
		-- upvalues: u54 (ref), positioning (copy), u67 (ref), u65 (ref), u66 (ref), v72 (copy), v61 (copy), SHADOW_SIZE (copy)
		if not u54 then
			return nil
		end

		return positioning.calculatePopoverBounds(u67, u65, u66, not v72 and 0 or v61, u54) + Vector2.new(SHADOW_SIZE * 2, SHADOW_SIZE * 2)
	end, {
		u54,
		u67,
		u65,
		u66,
		v72,
		v61
	})

	if Flags.FoundationPopoverPluginOverlayMeasurement then
		React.useLayoutEffect(function() -- line: 293
			-- upvalues: u54 (ref), v83 (copy), u53 (ref), u51 (ref), v82 (copy)
			if u54 == nil or v83 == nil then
				u53(UDim2.new())
				u51(UDim2.new())

				return
			end

			u53(UDim2.fromOffset(u54.X, u54.Y))
			u51(UDim2.fromOffset(v83.X, v83.Y))

			if v82 then
				v82.setSizeAsync(v83)
			end
		end, {
			u54,
			v83,
			v82
		})
		React.useLayoutEffect(function() -- line: 309
			-- upvalues: u74 (ref), v49 (copy), v82 (copy), v83 (copy), v48 (copy)
			if not u74 then
				v49.Parent = nil

				return
			end

			if v82 and v83 then
				v49.AutomaticSize = Enum.AutomaticSize.None
				v49.Size = UDim2.fromOffset(v83.X, v83.Y)
				v49.Position = UDim2.new()
				v49.Parent = v82.container

				return
			end

			v49.AutomaticSize = Enum.AutomaticSize.XY
			v49.Size = UDim2.new()
			v49.Position = UDim2.fromOffset(-10000, -10000)
			v49.Parent = v48
		end, {
			u74,
			v48,
			v82,
			v83,
			v49
		})
	end

	local v84 = if not v71.isVirtual and typeof(v41.anchor) == "Instance" then v41.anchor else nil
	local v85 = useArrowPosition(v52, u67, v37.radius, n1, v61, v84)
	local v86 = not Flags.FoundationPopoverPluginOverlayMeasurement or v82 ~= nil and v83 ~= nil
	local v87 = if not Flags.FoundationPopoverPluginOverlayMeasurement then v82 ~= nil else u74
	local v88 = if not Flags.FoundationPopoverPluginOverlayMeasurement then if not v82 then nil else v82.container else v49
	local v89 = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else React.useMemo(function() -- line: 347
		-- upvalues: v82 (copy), v86 (copy)
		return {
			id = if not v82 then nil else v82.popoverId,
			ready = v86
		}
	end, {
		v82,
		v86
	})
	local v90 = if not v87 or not v88 then nil else ReactRoblox.createPortal(React.createElement(React.Fragment, nil, {
		StyleLink = React.createElement("StyleLink", {
			StyleSheet = v42
		}),
		Container = React.createElement(View, {
			AutomaticSize = if not Flags.FoundationPopoverPluginOverlayMeasurement or v83 ~= nil then nil else Enum.AutomaticSize.XY,
			Size = if not Flags.FoundationPopoverPluginOverlayMeasurement or v83 ~= nil then v50 else nil,
			testId = `{ v41.testId }--container`
		}, {
			Shadow = React.createElement(PopoverShadow, {
				ZIndex = 1,
				contentSize = v52,
				position = UDim2.fromOffset(SHADOW_SIZE / 2, SHADOW_SIZE / 2 + 2),
				testId = `{ v41.testId }--shadow`
			}),
			Arrow = if not v72 then nil else React.createElement(PopoverArrow, {
				ZIndex = 2,
				size = Size_200,
				position = v85,
				backgroundStyle = v62,
				testId = `{ v41.testId }--arrow`
			}),
			Content = React.createElement(View, {
				ZIndex = 3,
				tag = `auto-xy { t2[v37.radius] }`,
				Position = UDim2.fromOffset(SHADOW_SIZE, SHADOW_SIZE),
				ref = v47,
				onAbsoluteSizeChanged = if not Flags.FoundationPopoverPluginOverlayMeasurement then nil else v76,
				backgroundStyle = v62,
				testId = `{ v41.testId }--content`
			}, if not Flags.FoundationPopoverPluginDepthPool then v37.children else React.createElement(PluginPopoverParentContext.Provider, {
				value = if not Flags.FoundationPopoverPluginOverlayMeasurement then v82.popoverId else v89
			}, {
				Nested = React.createElement(ElevationOwnerScope, {
					owner = v45
				}, v37.children)
			}))
		})
	}), if not Flags.FoundationPopoverPluginOverlayMeasurement then v82.container else v88)

	return React.createElement(React.Fragment, nil, {
		Anchor = v71.element,
		Panel = v90
	})
end

return React.forwardRef(PopoverContentPlugin)
