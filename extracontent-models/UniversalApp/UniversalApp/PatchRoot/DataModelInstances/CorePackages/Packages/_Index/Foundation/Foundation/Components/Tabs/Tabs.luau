local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local FillBehavior = require(Foundation.Enums.FillBehavior)
local Flags = require(Foundation.Utility.Flags)
local InputSize = require(Foundation.Enums.InputSize)
local TabItem = require(script.Parent.TabItem)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local useAnimatedHighlight = require(Foundation.Utility.useAnimatedHighlight)
local OverflowScrollContainer = require(script.Parent.OverflowScrollContainer)
local t1 = {
	testId = "--foundation-tabs",
	ZIndex = 1,
	fillBehavior = FillBehavior.Fill,
	size = InputSize.Medium
}

local function Tabs(p1, p2) -- line: 45
	-- upvalues: useTokens (copy), withDefaults (copy), t1 (copy), React (copy), Dash (copy), FillBehavior (copy), Flags (copy), useAnimatedHighlight (copy), View (copy), withCommonProps (copy), OverflowScrollContainer (copy), TabItem (copy)
	local v19 = useTokens()
	local v20 = withDefaults(p1, t1)
	local v21, v22 = React.useState(v20.defaultActiveTabId or Dash.get(v20, {
		1,
		"id"
	}))
	local v23 = React.useCallback(function(p3) -- line: 51
		-- upvalues: v20 (copy), v22 (copy)
		if v20.onActivated then
			v20.onActivated(p3)
		end

		v22(p3)
	end)
	local v24 = v20.fillBehavior == FillBehavior.Fill
	local v25 = v20.activeTabId or v21
	local v26 = Dash.find(v20.tabs, function(p4) -- line: 60
		-- upvalues: v25 (copy)
		return p4.id == v25
	end)
	local v27 = React.useRef(nil)
	local u29

	if Flags.FoundationFixStaleAnimatedHighlightRefs then
		local v28 = React.useRef({})

		u29 = React.useMemo(function() -- line: 70
			-- upvalues: v28 (copy), v20 (copy), React (copy)
			local current = v28.current

			for _, v38 in v20.tabs do
				if v38.ref then
					current[v38.id] = v38.ref
				elseif not current[v38.id] then
					current[v38.id] = React.createRef()
				end
			end

			return current
		end, { v20.tabs })
	else
		u29 = React.useMemo(function() -- line: 82
			-- upvalues: v20 (copy), React (copy)
			local t2 = {}

			for _, v41 in v20.tabs do
				t2[v41.id] = v41.ref or React.createRef()
			end

			return t2
		end, { v20.tabs })
	end

	local v30 = useAnimatedHighlight(v25, p2 or v27, u29, v20.size, v20.fillBehavior)
	local highlightPosition = v30.highlightPosition
	local highlightWidth = v30.highlightWidth
	local activeItemHeight = v30.activeItemHeight

	return React.createElement(View, withCommonProps(v20, if not Flags.FoundationTabsInlineSizeFull then {
		tag = "size-full-0 auto-y clip"
	} else {
		tag = "auto-y clip",
		Size = UDim2.fromScale(1, 0)
	}), {
		Tabs = React.createElement(View, if not Flags.FoundationTabsInlineSizeFull then {
			tag = "col size-full-0 auto-y",
			ref = p2 or v27
		} else {
			tag = "col auto-y",
			ref = p2 or v27,
			Size = UDim2.fromScale(1, 0)
		}, {
			Wrapper = React.createElement(View, if not Flags.FoundationTabsInlineSizeFull then {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y",
				testId = `{ v20.testId }--wrapper`
			} else {
				LayoutOrder = 1,
				tag = "auto-y",
				Size = UDim2.fromScale(1, 0),
				testId = `{ v20.testId }--wrapper`
			}, {
				ScrollContainer = React.createElement(OverflowScrollContainer, {
					LayoutOrder = 1,
					size = v20.size,
					testId = `{ v20.testId }--scroll-container`
				}, {
					TabList = React.createElement(View, {
						tag = if not Flags.FoundationTabsInlineSizeFull then {
							["row flex-y-fill auto-xy"] = true,
							["gap-large"] = not v24,
							["size-full-0"] = v24
						} else {
							["row flex-y-fill auto-xy"] = true,
							["gap-large"] = not v24
						},
						Size = if not Flags.FoundationTabsInlineSizeFull or not v24 then nil else UDim2.fromScale(1, 0),
						testId = `{ v20.testId }--list`
					}, Dash.map(v20.tabs, function(p5, p6) -- line: 155
						-- upvalues: React (copy), TabItem (copy), v25 (copy), v23 (copy), v20 (copy), u29 (ref)
						return React.createElement(TabItem, {
							id = p5.id,
							text = p5.text,
							key = tostring(p5.id),
							icon = p5.icon,
							isActive = p5.id == v25,
							onActivated = v23,
							LayoutOrder = p6,
							fillBehavior = v20.fillBehavior,
							size = v20.size,
							isDisabled = p5.isDisabled,
							testId = `{ v20.testId }--item-{ p5.id }`,
							ref = u29[p5.id]
						})
					end))
				}),
				Border = React.createElement(View, {
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(0, 1),
					Size = UDim2.new(1, 0, 0, v19.Stroke.Thick),
					Position = UDim2.fromScale(0, 1),
					backgroundStyle = v19.Color.Stroke.Default,
					testId = `{ v20.testId }--border`
				})
			}),
			Content = if not v26 or not v26.content then nil else React.createElement(View, if not Flags.FoundationTabsInlineSizeFull then {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y",
				testId = `{ v20.testId }--content`
			} else {
				LayoutOrder = 2,
				tag = "auto-y",
				Size = UDim2.fromScale(1, 0),
				testId = `{ v20.testId }--content`
			}, v26.content)
		}),
		AnimatedBorder = React.createElement(View, {
			LayoutOrder = 0,
			ZIndex = v20.ZIndex + 1,
			Size = highlightWidth:map(function(p7) -- line: 206
				-- upvalues: v19 (copy)
				return UDim2.fromOffset(p7, v19.Stroke.Thick)
			end),
			Position = React.joinBindings({
				highlightPosition,
				activeItemHeight
			}):map(function(p8) -- line: 209
				-- upvalues: v19 (copy)
				local v46 = p8[1]
				local v47 = p8[2]

				return UDim2.fromOffset(v46, v47 - v19.Stroke.Thick)
			end),
			backgroundStyle = v19.Color.System.Contrast,
			testId = `{ v20.testId }--animated-border`
		})
	})
end

return React.memo(React.forwardRef(Tabs))
