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
	-- upvalues: useTokens (copy), withDefaults (copy), t1 (copy), React (copy), Dash (copy), FillBehavior (copy), Flags (copy), useAnimatedHighlight (copy), View (copy), withCommonProps (copy), OverflowScrollContainer (copy), InputSize (copy), TabItem (copy)
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
	local v28 = nil
	local u29 = nil
	local v30 = nil

	if Flags.FoundationFixTabsFitBorderWidth then
		local v31

		v28, v31 = React.useBinding(0)
		u29 = v31
		v30 = React.useCallback(function(p5) -- line: 70
			-- upvalues: u29 (ref)
			u29(p5.AbsoluteSize.X)
		end, {})
	end

	local v32 = React.useRef({})
	local u33 = React.useMemo(function() -- line: 78
		-- upvalues: v32 (copy), v20 (copy), React (copy)
		local current = v32.current

		for _, v45 in v20.tabs do
			if v45.ref then
				current[v45.id] = v45.ref
			elseif not current[v45.id] then
				current[v45.id] = React.createRef()
			end
		end

		return current
	end, { v20.tabs })
	local v34 = useAnimatedHighlight(v25, p2 or v27, u33, v20.size, v20.fillBehavior)
	local highlightPosition = v34.highlightPosition
	local highlightWidth = v34.highlightWidth
	local activeItemHeight = v34.activeItemHeight
	local v38 = if not Flags.FoundationFixTabsFitBorderWidth then nil else React.useMemo(function() -- line: 102
		-- upvalues: v24 (copy)
		return {
			outer = {
				clip = true,
				["auto-xy"] = not v24,
				["auto-y"] = v24
			},
			tabs = {
				col = true,
				["auto-xy"] = not v24,
				["auto-y"] = v24
			},
			wrapper = {
				["auto-xy"] = not v24,
				["auto-y"] = v24
			}
		}
	end, { v24 })
	local v39 = if not Flags.FoundationFixTabsFitBorderWidth then nil else v20.size

	return React.createElement(View, withCommonProps(v20, if not Flags.FoundationTabsInlineSizeFull then {
		tag = "size-full-0 auto-y clip"
	} else {
		tag = not Flags.FoundationFixTabsFitBorderWidth and "auto-y clip" or v38.outer,
		Size = if not Flags.FoundationFixTabsFitBorderWidth then UDim2.fromScale(1, 0) else if not v24 then nil else UDim2.fromScale(1, 0)
	}), {
		Tabs = React.createElement(View, if not Flags.FoundationTabsInlineSizeFull then {
			tag = "col size-full-0 auto-y",
			ref = p2 or v27
		} else {
			ref = p2 or v27,
			tag = not Flags.FoundationFixTabsFitBorderWidth and "col auto-y" or v38.tabs,
			Size = if not Flags.FoundationFixTabsFitBorderWidth then UDim2.fromScale(1, 0) else if not v24 then nil else UDim2.fromScale(1, 0)
		}, {
			Wrapper = React.createElement(View, if not Flags.FoundationTabsInlineSizeFull then {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y",
				testId = `{ v20.testId }--wrapper`
			} else {
				LayoutOrder = 1,
				tag = not Flags.FoundationFixTabsFitBorderWidth and "auto-y" or v38.wrapper,
				Size = if not Flags.FoundationFixTabsFitBorderWidth then UDim2.fromScale(1, 0) else if not v24 then nil else UDim2.fromScale(1, 0),
				testId = `{ v20.testId }--wrapper`
			}, {
				ScrollContainer = React.createElement(OverflowScrollContainer, {
					LayoutOrder = 1,
					size = v20.size,
					fillBehavior = if not Flags.FoundationFixTabsFitBorderWidth then nil else if not v24 then v20.fillBehavior else nil,
					fitWidth = if not Flags.FoundationFixTabsFitBorderWidth then nil else if not v24 then v28 else nil,
					testId = `{ v20.testId }--scroll-container`
				}, {
					TabList = React.createElement(View, {
						onAbsoluteSizeChanged = if not Flags.FoundationFixTabsFitBorderWidth then nil else v30,
						tag = if not Flags.FoundationTabsInlineSizeFull then {
							["row flex-y-fill auto-xy"] = true,
							["gap-large"] = if not Flags.FoundationFixTabsFitBorderWidth then not v24 else not v24 and (v39 == InputSize.Small or v39 == InputSize.XSmall),
							["size-full-0"] = v24
						} else {
							["row flex-y-fill auto-xy"] = true,
							["gap-large"] = if not Flags.FoundationFixTabsFitBorderWidth then not v24 else not v24 and (v39 == InputSize.Small or v39 == InputSize.XSmall)
						},
						Size = if not Flags.FoundationTabsInlineSizeFull or not v24 then nil else UDim2.fromScale(1, 0),
						testId = `{ v20.testId }--list`
					}, Dash.map(v20.tabs, function(p6, p7) -- line: 211
						-- upvalues: React (copy), TabItem (copy), v25 (copy), v23 (copy), v20 (copy), u33 (ref)
						return React.createElement(TabItem, {
							id = p6.id,
							text = p6.text,
							indicator = p6.indicator,
							key = tostring(p6.id),
							icon = p6.icon,
							isActive = p6.id == v25,
							onActivated = v23,
							LayoutOrder = p7,
							fillBehavior = v20.fillBehavior,
							size = v20.size,
							isDisabled = p6.isDisabled,
							testId = `{ v20.testId }--item-{ p6.id }`,
							ref = u33[p6.id]
						})
					end))
				}),
				Border = React.createElement(View, {
					LayoutOrder = 2,
					AnchorPoint = Vector2.new(0, 1),
					Size = if not Flags.FoundationFixTabsFitBorderWidth then UDim2.new(1, 0, 0, v19.Stroke.Thick) else if not v24 then v28:map(function(p8) -- line: 236
						-- upvalues: v19 (copy)
						return UDim2.fromOffset(p8, v19.Stroke.Thick)
					end) else UDim2.new(1, 0, 0, v19.Stroke.Thick),
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
			Size = highlightWidth:map(function(p9) -- line: 269
				-- upvalues: v19 (copy)
				return UDim2.fromOffset(p9, v19.Stroke.Thick)
			end),
			Position = React.joinBindings({
				highlightPosition,
				activeItemHeight
			}):map(function(p10) -- line: 272
				-- upvalues: v19 (copy)
				local v51 = p10[1]
				local v52 = p10[2]

				return UDim2.fromOffset(v51, v52 - v19.Stroke.Thick)
			end),
			backgroundStyle = v19.Color.System.Contrast,
			testId = `{ v20.testId }--animated-border`
		})
	})
end

return React.memo(React.forwardRef(Tabs))
