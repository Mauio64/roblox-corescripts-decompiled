local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local FillBehavior = require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)
local OverflowScrollContainer = require(Foundation.Components.OverflowScrollContainer)
local TabItem = require(script.Parent.TabItem)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)

local OverflowScrollContainer2 = require(script.Parent.OverflowScrollContainer)

local v = {
	fillBehavior = FillBehavior.Fill,
	size = InputSize.Medium,
	testId = "--foundation-tabs",
	ZIndex = 1
}

local function Tabs(p, p2)
	local v2 = useTokens()
	local v3 = withDefaults(p, v)

	local state, setState = React.useState(v3.defaultActiveTabId or Dash.get(v3, { 1, "id" }))

	local onActivated = React.useCallback(function(p3)
		if v3.onActivated then
			v3.onActivated(p3)
		end

		setState(p3)
	end, Flags.FoundationTabsStableOnActivated and { v3.onActivated } or nil)

	local v4 = v3.fillBehavior == FillBehavior.Fill
	local activeTabId = v3.activeTabId or state
	local v5 = Dash.find(v3.tabs, function(p3): boolean
		return p3.id == activeTabId
	end)

	local ref = React.useRef(nil)

	local v6 = nil
	local v7 = nil
	local onAbsoluteSizeChanged

	if Flags.FoundationUnifiedScrimScrolling then
		local v8
		v6, v8 = React.useBinding(0)
		v7 = v8
		onAbsoluteSizeChanged = React.useCallback(function(p3)
			v7(p3.AbsoluteSize.X)
		end, {})
	end

	local ref2 = React.useRef({})
	local v8 = React.useMemo(function()
		local current = ref2.current

		for _, tab in v3.tabs do
			if tab.ref then
				current[tab.id] = tab.ref
			elseif not current[tab.id] then
				current[tab.id] = React.createRef()
			end
		end

		return current
	end, { v3.tabs })

	local v9 = useAnimatedHighlight(activeTabId, p2 or ref, v8, v3.size, v3.fillBehavior)

	local highlightPosition = v9.highlightPosition
	local highlightWidth = v9.highlightWidth
	local activeItemHeight = v9.activeItemHeight

	local size = v3.size
	local createElement = React.createElement

	local v10 = withCommonProps(v3, {
		tag = Flags.FoundationUnifiedScrimScrolling and "auto-y no-clip" or "auto-y clip",
		Size = UDim2.fromScale(1, 0),
		sizeConstraint = Flags.FoundationUnifiedScrimScrolling and not v4 and {
			MaxSize = v6:map(function(p3: number)
				return Vector2.new(p3, 1e999)
			end)
		} or nil
	})

	local createElement2 = React.createElement
	local v11 = {
		ref = p2 or ref,
		tag = "col auto-y",
		Size = UDim2.fromScale(1, 0)
	}

	local createElement3 = React.createElement
	local v12 = {
		LayoutOrder = 1,
		tag = "auto-y",
		Size = UDim2.fromScale(1, 0),
		testId = `{v3.testId}--wrapper`
	}

	local createElement4 = React.createElement
	local v13

	if Flags.FoundationUnifiedScrimScrolling then
		v13 = OverflowScrollContainer
	else
		v13 = OverflowScrollContainer2
	end

	local v15

	if Flags.FoundationUnifiedScrimScrolling then
		v15 = {
			LayoutOrder = 1,
			size = v3.size,
			scrimBottomInset = v2.Stroke.Thick,
			testId = `{v3.testId}--scroll-container`
		}
	else
		v15 = {
			LayoutOrder = 1,
			size = v3.size,
			testId = `{v3.testId}--scroll-container`
		}
	end

	local createElement5 = React.createElement

	if not Flags.FoundationUnifiedScrimScrolling then
		onAbsoluteSizeChanged = nil
	end

	local v16 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = Flags.FoundationFixTabsFitGap and "row flex-y-fill auto-xy" or {
			["row flex-y-fill auto-xy"] = true,
			["gap-large"] = not v4 and (size == InputSize.Small or size == InputSize.XSmall)
		},
		Size = 0,
		testId = 0
	}
	local size2

	if v4 then
		size2 = UDim2.fromScale(1, 0)
	end

	v16.Size = size2
	v16.testId = `{v3.testId}--list`
	local v14 = {
		Wrapper = createElement3(View, v12, {
			ScrollContainer = createElement4(v13, v15, {
				TabList = createElement5(View, v16, Dash.map(v3.tabs, function(props, layoutOrder)
					return React.createElement(TabItem, {
						id = props.id,
						text = props.text,
						indicator = props.indicator,
						key = tostring(props.id),
						icon = props.icon,
						leading = props.leading,
						trailing = props.trailing,
						isActive = props.id == activeTabId,
						onActivated = onActivated,
						LayoutOrder = layoutOrder,
						fillBehavior = v3.fillBehavior,
						size = v3.size,
						isDisabled = props.isDisabled,
						testId = `{v3.testId}--item-{props.id}`,
						ref = v8[props.id]
					})
				end))
			}),
			Border = React.createElement(View, {
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0, 1),
				Size = UDim2.new(1, 0, 0, v2.Stroke.Thick),
				Position = UDim2.fromScale(0, 1),
				backgroundStyle = v2.Color.Stroke.Default,
				testId = `{v3.testId}--border`
			})
		}),
		Content = 0
	}
	local content

	if v5 and v5.content then
		content = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "auto-y",
				Size = UDim2.fromScale(1, 0),
				testId = `{v3.testId}--content`
			},
			v5.content
		)
	end

	v14.Content = content
	return createElement(View, v10, {
		Tabs = createElement2(View, v11, v14),
		AnimatedBorder = React.createElement(View, {
			LayoutOrder = 0,
			ZIndex = v3.ZIndex + 1,
			Size = highlightWidth:map(function(p3)
				return UDim2.fromOffset(p3, v2.Stroke.Thick)
			end),
			AnchorPoint = Vector2.new(0, 1),
			Position = React.joinBindings({ highlightPosition, activeItemHeight }):map(function(list)
				local item = list[1]
				local item2 = list[2]
				return UDim2.fromOffset(item, item2)
			end),
			backgroundStyle = v2.Color.System.Contrast,
			testId = `{v3.testId}--animated-border`
		})
	})
end

return React.memo(React.forwardRef(Tabs))
