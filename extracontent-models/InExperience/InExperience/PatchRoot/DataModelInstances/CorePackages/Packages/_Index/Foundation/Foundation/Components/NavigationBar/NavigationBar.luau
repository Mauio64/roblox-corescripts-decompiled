local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local React = require(parent.React)

local Breakpoint = require(Foundation.Enums.Breakpoint)
local BreakpointConfig = require(Foundation.Utility.Responsive.BreakpointConfig)
local Divider = require(Foundation.Components.Divider)
local NavigationBarTab = require(script.Parent.NavigationBarTab)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local width = BreakpointConfig.widths[Breakpoint.Small]

local v = { testId = "--foundation-navigation-bar" }

local function NavigationBar(p, p2)
	local v2 = withDefaults(p, v)

	local state, setState = React.useState(v2.defaultActiveItemId or Dash.get(v2.items, { 1, "id" }))

	if v2.activeItemId ~= nil then
		state = v2.activeItemId
	end

	local onActivated = React.useCallback(function(p3)
		setState(p3)

		if v2.onActivated then
			v2.onActivated(p3)
		end
	end, { v2.onActivated })

	local v3 = useTokens()
	local ref = React.useRef(nil)
	local ref2 = React.useRef({})
	local v4 = React.useMemo(function()
		local current = ref2.current

		for _, item in v2.items do
			if not current[item.id] then
				current[item.id] = React.createRef()
			end
		end

		return current
	end, { v2.items })

	local some = Dash.some(v2.items, function(p3): boolean
		return p3.id == state
	end)

	local v5 = useAnimatedHighlight(state, p2 or ref, v4, v2.items)

	return React.createElement(View, withCommonProps(v2, {
		tag = "size-full-0 auto-y",
		backgroundStyle = v3.Color.Common.NavigationBar,
		onActivated = Dash.noop,
		stateLayer = { affordance = StateLayerAffordance.None },
		selection = { Selectable = false },
		ref = p2 or ref
	}), {
		ActiveIndicator = React.createElement(View, {
			tag = "radius-circle bg-system-contrast",
			Size = v5.highlightWidth:map(function(p3: number)
				return UDim2.fromOffset(p3, v3.Size.Size_50)
			end),
			Position = v5.highlightPosition:map(function(p3: number)
				return UDim2.fromOffset(p3, 0)
			end),
			Visible = some,
			ZIndex = 3,
			testId = `{v2.testId}--active-indicator`
		}),
		Divider = React.createElement(Divider, { testId = `{v2.testId}--divider` }),
		Tabs = React.createElement(View, {
			tag = "row gap-small size-full-0 auto-y margin-x-small",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			sizeConstraint = { MaxSize = Vector2.new(width, 1e999) },
			ZIndex = 2,
			testId = `{v2.testId}--tabs`
		}, Dash.map(v2.items, function(p3, layoutOrder)
			return React.createElement(NavigationBarTab, {
				key = tostring(p3.id),
				item = p3,
				isActive = p3.id == state,
				onActivated = onActivated,
				LayoutOrder = layoutOrder,
				ref = v4[p3.id],
				testId = `{v2.testId}--item-{p3.id}`
			})
		end))
	})
end

return React.memo(React.forwardRef(NavigationBar))
