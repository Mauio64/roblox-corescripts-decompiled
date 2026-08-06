local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Flags = require(Foundation.Utility.Flags)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local function computeAutomaticSize(t1: {[any]: any}) -- line: 39
	if t1.autoSize then
		if t1.isOverMaxHeight then
			return Enum.AutomaticSize.X
		end

		return Enum.AutomaticSize.XY
	end

	if t1.isOverMaxHeight then
		return Enum.AutomaticSize.None
	end

	return Enum.AutomaticSize.Y
end
local function computeSize(t2: {[any]: any}) -- line: 45
	local v13 = if not t2.isOverMaxHeight or not t2.maxHeight then UDim.new() else UDim.new(0, t2.maxHeight)

	if t2.autoSize then
		return (UDim2.new(UDim.new(), v13))
	end

	return (UDim2.new(t2.width or UDim.new(), v13))
end
local function BaseMenuScrollContainer(t3: {[any]: any}) -- line: 63
	-- upvalues: React (copy), computeAutomaticSize (copy), ScrollView (copy), withCommonProps (copy), Flags (copy), computeSize (copy), View (copy)
	local v15 = React.useBinding(true)
	local v16 = React.useBinding(nil)
	local v17 = t3.autoSize or v15
	local v18 = t3.width or v16
	local maxHeight = t3.maxHeight
	local v20, v21 = React.useBinding(UDim2.fromScale(0, 1))
	local v22 = React.useMemo(function() -- line: 72
		-- upvalues: React (copy), v20 (copy), maxHeight (copy)
		return React.joinBindings({
			canvasSize = v20,
			maxHeight = maxHeight
		}):map(function(t4: {[any]: any}) -- line: 74
			return t4.maxHeight ~= nil and t4.canvasSize.Y.Offset > t4.maxHeight
		end)
	end, { maxHeight })
	local v23 = React.useCallback(function(p1) -- line: 79
		-- upvalues: v21 (copy)
		return v21(UDim2.fromOffset(p1.AbsoluteSize.X, p1.AbsoluteSize.Y))
	end, { v21 })
	local v24 = React.joinBindings({
		autoSize = v17,
		isOverMaxHeight = v22
	}):map(computeAutomaticSize)

	return React.createElement(ScrollView, withCommonProps(t3.scrollViewProps, {
		ref = t3.scrollViewProps.ref,
		sizeConstraint = t3.scrollViewProps.sizeConstraint,
		tag = t3.scrollViewProps.tag,
		InputSink = t3.scrollViewProps.InputSink,
		scrollingFrameRef = t3.scrollViewProps.scrollingFrameRef,
		scroll = {
			AutomaticCanvasSize = if not Flags.FoundationBaseMenuAutoYCanvasSizing then nil else Enum.AutomaticSize.Y,
			AutomaticSize = v24,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = v20
		},
		AutomaticSize = v24,
		Size = React.joinBindings({
			autoSize = v17,
			width = v18,
			isOverMaxHeight = v22,
			maxHeight = maxHeight
		}):map(computeSize)
	}), React.createElement(View, {
		tag = not Flags.FoundationBaseMenuAutoYCanvasSizing and "col size-full" or "col size-full-0 auto-y",
		onAbsoluteSizeChanged = v23
	}, t3.children))
end

return BaseMenuScrollContainer
