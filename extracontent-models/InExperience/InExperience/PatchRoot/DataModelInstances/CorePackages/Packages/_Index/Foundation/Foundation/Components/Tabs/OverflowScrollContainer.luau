local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)

require(Foundation.Enums.FillBehavior)

local Flags = require(Foundation.Utility.Flags)
local IconButton = require(Foundation.Components.IconButton)
local InputSize = require(Foundation.Enums.InputSize)
local ScrollView = require(Foundation.Components.ScrollView)

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

local function OverflowButton(p1) -- line: 34
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
local function OverflowScrollContainer(p2) -- line: 73
	-- upvalues: React (copy), ReactOtter (copy), Dash (copy), Otter (copy), Flags (copy), View (copy), withCommonProps (copy), ScrollView (copy), Visibility (copy), OverflowButton (copy), numberSequence (copy), numberSequence2 (copy)
	local v20, v21 = React.useBinding(false)
	local v22, v23 = React.useBinding(false)
	local v24 = React.useRef(nil)
	local v25 = ReactOtter.useMotor(0, function(p3) -- line: 77
		-- upvalues: v24 (copy)
		local current = v24.current

		if not current then
			return
		end

		current.CanvasPosition = Vector2.new(p3, 0)
	end)
	local v26 = React.useCallback(Dash.throttle(function(p4) -- line: 86
		-- upvalues: v21 (copy), v23 (copy)
		if p4.AbsoluteWindowSize.X == 0 then
			return
		end

		v21(p4.AbsoluteWindowSize.X + p4.CanvasPosition.X < p4.AbsoluteCanvasSize.X - 1)
		v23(p4.CanvasPosition.X ~= 0)
	end, 0.2), {})
	local v27 = React.useCallback(function(n1: number) -- line: 99
		-- upvalues: v24 (copy), v25 (copy), Otter (copy)
		local current = v24.current

		if not current then
			return
		end

		v25(Otter.ease(current.CanvasPosition.X + n1, {
			duration = 0.2,
			easingStyle = Enum.EasingStyle.Quad
		}))
	end, {})

	React.useEffect(function() -- line: 113
		-- upvalues: v24 (copy), v26 (copy)
		if v24.current then
			v26(v24.current)
		end
	end, {})

	local v28 = React.useCallback(function() -- line: 119
		-- upvalues: v27 (copy)
		v27(-90)
	end, { v27 })
	local v29 = React.useCallback(function() -- line: 123
		-- upvalues: v27 (copy)
		v27(90)
	end, { v27 })
	local v30 = if not Flags.FoundationFixTabsFitBorderWidth or not p2.fitWidth then nil else p2.fitWidth:map(function(p5) -- line: 128
		return UDim2.fromOffset(p5, 0)
	end)

	return React.createElement(View, withCommonProps(p2, if not Flags.FoundationTabsInlineSizeFull then {
		tag = "size-full-0 auto-y"
	} else {
		tag = "auto-y",
		Size = Flags.FoundationFixTabsFitBorderWidth and v30 or UDim2.fromScale(1, 0)
	}), {
		Scroll = React.createElement(ScrollView, {
			LayoutOrder = 1,
			tag = not Flags.FoundationTabsInlineSizeFull and "size-full" or if not Flags.FoundationFixTabsFitBorderWidth then nil else "auto-y",
			Size = if not Flags.FoundationTabsInlineSizeFull then nil else Flags.FoundationFixTabsFitBorderWidth and v30 or UDim2.fromScale(1, 1),
			onCanvasPositionChanged = v26,
			onAbsoluteWindowSizeChanged = v26,
			scrollingFrameRef = v24,
			selection = {
				Selectable = false
			},
			scroll = {
				AutomaticSize = Enum.AutomaticSize.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = Visibility.None
			}
		}, p2.children),
		OverflowStart = React.createElement(OverflowButton, {
			LayoutOrder = 3,
			isStart = true,
			ZIndex = 2,
			tag = "padding-right-small",
			icon = "chevron-large-left",
			Position = UDim2.fromScale(0, 0),
			size = p2.size,
			Visible = v22,
			onActivated = v28,
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
			Visible = v20,
			onActivated = v29,
			gradient = numberSequence2,
			testId = `{ p2.testId }--overflow-end`
		})
	})
end

return OverflowScrollContainer
