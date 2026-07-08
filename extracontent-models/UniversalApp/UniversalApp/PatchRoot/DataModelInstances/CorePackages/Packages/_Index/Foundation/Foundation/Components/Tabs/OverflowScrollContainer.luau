local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ControlState = require(Foundation.Enums.ControlState)
local Flags = require(Foundation.Utility.Flags)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local ScrollView = require(Foundation.Components.ScrollView)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local Visibility = require(Foundation.Enums.Visibility)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.8, 0),
	NumberSequenceKeypoint.new(1, 1)
})
local numberSequence2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.2, 0),
	NumberSequenceKeypoint.new(1, 0)
})

local function OverflowButton(p1) -- line: 35
	-- upvalues: React (copy), View (copy), withCommonProps (copy), IconButton (copy), InputSize (copy)
	return React.createElement(View, withCommonProps(p1, {
		tag = `col align-y-center size-0-full auto-x bg-surface-0 { p1.tag }`
	}), {
		UIGradient = React.createElement("UIGradient", {
			Transparency = p1.gradient
		}),
		Button = React.createElement(IconButton, {
			onActivated = p1.onActivated,
			size = if p1.size ~= InputSize.Large and p1.size ~= InputSize.Medium then InputSize.XSmall else InputSize.Small,
			icon = {
				name = p1.icon
			}
		})
	})
end
local function OverflowScrollContainer(p2) -- line: 72
	-- upvalues: React (copy), Flags (copy), ReactOtter (copy), Dash (copy), Otter (copy), ControlState (copy), View (copy), withCommonProps (copy), ScrollView (copy), StateLayerAffordance (copy), Visibility (copy), OverflowButton (copy), numberSequence (copy), numberSequence2 (copy)
	local v22, v23 = React.useBinding(false)
	local v24, v25 = React.useBinding(false)
	local u26 = nil
	local u27 = nil

	if Flags.FoundationTabsNavArrowsOnlyOnHover then
		local v28, v29 = React.useState(false)

		u26 = v28
		u27 = v29
	end

	local v30 = React.useRef(nil)
	local v31 = ReactOtter.useMotor(0, function(p3) -- line: 80
		-- upvalues: v30 (copy)
		local current = v30.current

		if not current then
			return
		end

		current.CanvasPosition = Vector2.new(p3, 0)
	end)
	local v32 = React.useCallback(Dash.throttle(function(p4) -- line: 89
		-- upvalues: v23 (copy), v25 (copy)
		if p4.AbsoluteWindowSize.X == 0 then
			return
		end

		v23(p4.AbsoluteWindowSize.X + p4.CanvasPosition.X < p4.AbsoluteCanvasSize.X - 1)
		v25(p4.CanvasPosition.X ~= 0)
	end, 0.2), {})
	local v33 = React.useCallback(function(n1: number) -- line: 102
		-- upvalues: v30 (copy), v31 (copy), Otter (copy)
		local current = v30.current

		if not current then
			return
		end

		v31(Otter.ease(current.CanvasPosition.X + n1, {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, {})

	React.useEffect(function() -- line: 116
		-- upvalues: v30 (copy), v32 (copy)
		if v30.current then
			v32(v30.current)
		end
	end, {})

	local v34 = React.useCallback(function() -- line: 122
		-- upvalues: v33 (copy)
		v33(-90)
	end, { v33 })
	local v35 = React.useCallback(function() -- line: 126
		-- upvalues: v33 (copy)
		v33(90)
	end, { v33 })
	local v36 = if not Flags.FoundationTabsNavArrowsOnlyOnHover then nil else React.useCallback(function(p5) -- line: 131
		-- upvalues: u27 (ref), ControlState (copy)
		u27(p5 == ControlState.Hover)
	end, {})

	return React.createElement(View, withCommonProps(p2, if not Flags.FoundationTabsInlineSizeFull then {
		tag = "size-full-0 auto-y"
	} else {
		tag = "auto-y",
		Size = UDim2.fromScale(1, 0)
	}), {
		Scroll = React.createElement(ScrollView, {
			LayoutOrder = 1,
			tag = if not Flags.FoundationTabsInlineSizeFull then {
				["size-full-0 auto-y"] = Flags.FoundationTabsNavArrowsOnlyOnHover,
				["size-full"] = not Flags.FoundationTabsNavArrowsOnlyOnHover
			} else if not Flags.FoundationTabsNavArrowsOnlyOnHover then nil else "auto-y",
			Size = if not Flags.FoundationTabsInlineSizeFull then nil else if not Flags.FoundationTabsNavArrowsOnlyOnHover then UDim2.fromScale(1, 1) else UDim2.fromScale(1, 0),
			onStateChanged = if not Flags.FoundationTabsNavArrowsOnlyOnHover then nil else v36,
			stateLayer = if not Flags.FoundationTabsNavArrowsOnlyOnHover then nil else {
				affordance = StateLayerAffordance.None
			},
			onCanvasPositionChanged = v32,
			onAbsoluteWindowSizeChanged = v32,
			scrollingFrameRef = v30,
			selection = {
				Selectable = false
			},
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Visibility.None
			},
			testId = if not Flags.FoundationTabsNavArrowsOnlyOnHover then nil else `{ p2.testId }--scroll`
		}, p2.children),
		OverflowStart = React.createElement(OverflowButton, {
			LayoutOrder = 3,
			isStart = true,
			ZIndex = 2,
			tag = "padding-right-small",
			icon = "chevron-large-left",
			Position = UDim2.fromScale(0, 0),
			size = p2.size,
			Visible = if not Flags.FoundationTabsNavArrowsOnlyOnHover then v24 else v24:map(function(p6) -- line: 185
				-- upvalues: u26 (ref)
				return u26 and p6
			end),
			onActivated = v34,
			gradient = numberSequence,
			testId = `{ p2.testId }--overflow-start`
		}),
		OverflowEnd = React.createElement(OverflowButton, {
			LayoutOrder = 4,
			ZIndex = 2,
			tag = "anchor-top-right padding-left-small",
			icon = "chevron-large-right",
			Position = UDim2.fromScale(1, 0),
			size = p2.size,
			Visible = if not Flags.FoundationTabsNavArrowsOnlyOnHover then v22 else v22:map(function(p7) -- line: 201
				-- upvalues: u26 (ref)
				return u26 and p7
			end),
			onActivated = v35,
			gradient = numberSequence2,
			testId = `{ p2.testId }--overflow-end`
		})
	})
end

return OverflowScrollContainer
