local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local ReactUtils = require(parent.ReactUtils)
local usePrevious = ReactUtils.usePrevious

local Constants = require(Foundation.Constants)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)

require(Foundation.Enums.ElevationLayer)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useOverlayTransition = require(Foundation.Utility.useOverlayTransition)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useStableContainer = require(Foundation.Utility.useStableContainer)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

require(Foundation.Providers.ScreenRegion.ScreenRegion)
local ScreenRegionKind = require(Foundation.Providers.ScreenRegion.ScreenRegionKind)
local useRegionEntry = require(Foundation.Providers.ScreenRegion.useRegionEntry)

local v = { testId = "--foundation-floating-element" }

local function FloatingContent(p)
	local v2 = Dash.assign({ LayoutOrder = 1 }, p)
	local v3 = useTokens()
	local v4 = useOverlay()
	local owner = useElevation(v2.layer, { stackAboveOwner = false })
	local v5 = useScaledValue(Constants.FLOATING_MAX_WIDTH)

	local v6, ref = useStableContainer()
	local v7, v8 = React.useBinding(0)
	local large = v3.Padding.Large

	local size_800 = v3.Size.Size_800
	local v9 = size_800 - large

	local createElement = React.createElement
	local v10 = { ZIndex = owner.zIndex, tag = "size-full", testId = `{v2.testId}--container` }

	local createElement2 = React.createElement
	local v11 = {
		ZIndex = owner.zIndex,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = v2.progress:map(function(p2: number)
			return UDim2.new(0.5, 0, 1, v9 + (1 - p2) * v3.Size.Size_800)
		end),
		Size = v7:map(function(p2: number)
			return UDim2.new(1, v9 * 2, 0, p2 + size_800 * 2)
		end),
		sizeConstraint = {
			MaxSize = Vector2.new(v5 + size_800 * 2, 1e999)
		},
		GroupTransparency = 0,
		ref = 0,
		testId = 0
	}
	local groupTransparency

	if v2.isAnimating then
		groupTransparency = v2.progress:map(function(p2: number)
			return 1 - p2
		end)
	end

	v11.GroupTransparency = groupTransparency

	v11.ref = ref
	v11.testId = `{v2.testId}--transition`
	local element = createElement(View, v10, { Transition = createElement2(View, v11) })

	local element2 = React.createElement(
		View,
		{ padding = UDim.new(0, size_800), tag = "col align-x-center size-full" },
		{
			Content = React.createElement(
				View,
				Dash.assign(
					withCommonProps(v2, {
						tag = "col align-x-center size-full-0 auto-y",
						ref = v2.forwardRef
					}),
					{
						onAbsoluteSizeChanged = function(p2)
							v8(p2.AbsoluteSize.Y)

							if v2.onAbsoluteSizeChanged then
								v2.onAbsoluteSizeChanged(p2)
							end
						end
					}
				),
				React.createElement(ElevationOwnerScope, { owner = owner }, v2.children)
			)
		}
	)

	local createElement3 = React.createElement
	local fragment = React.Fragment

	if v4 ~= nil then
		element = ReactRoblox.createPortal(element, v4)
	end

	return createElement3(fragment, nil, {
		Overlay = element,
		StableContent = ReactRoblox.createPortal(element2, v6)
	})
end

local function InternalFloatingElement(p, forwardRef)
	local v2 = withDefaults(p, v)
	local state, setState = React.useState(false)
	local queue = v2.queue
	local region

	if queue then
		region = queue.region
	end

	local kind

	if queue then
		kind = queue.kind
	else
		kind = ScreenRegionKind.FloatingBanner
	end

	local v3 = useRegionEntry(region, { kind = kind, isOpen = v2.isOpen, isMounted = state })

	local onCloseComplete = v2.onCloseComplete

	local v4 = useOverlayTransition({
		isOpen = v2.isOpen and v3.isVisible,
		onExited = function()
			if not v2.isOpen and onCloseComplete then
				onCloseComplete()
			end
		end
	})

	local v5 = usePrevious(v2.isOpen)
	React.useEffect(function()
		if v5 and not v2.isOpen and not v4.isMounted and onCloseComplete then
			onCloseComplete()
		end
	end, { v5, v2.isOpen, v4.isMounted, onCloseComplete })

	React.useLayoutEffect(function()
		setState(v4.isMounted)
	end, { v4.isMounted })

	if v4.isMounted then
		return React.createElement(
			FloatingContent,
			Dash.assign({}, v2, {
				progress = v4.progress,
				isAnimating = v4.isAnimating,
				forwardRef = forwardRef
			})
		)
	end

	return nil
end

return React.memo(React.forwardRef(InternalFloatingElement))
