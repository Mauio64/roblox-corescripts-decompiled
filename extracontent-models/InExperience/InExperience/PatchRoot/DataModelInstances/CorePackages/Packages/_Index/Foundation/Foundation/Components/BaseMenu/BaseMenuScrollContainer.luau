local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ScrollView = require(Foundation.Components.ScrollView)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local function computeAutomaticSize(p)
	if p.autoSize then
		if p.isOverMaxHeight then
			return Enum.AutomaticSize.X
		end

		return Enum.AutomaticSize.XY
	elseif p.isOverMaxHeight then
		return Enum.AutomaticSize.None
	else
		return Enum.AutomaticSize.Y
	end
end

local function computeSize(data)
	local udim

	if data.isOverMaxHeight and data.maxHeight then
		udim = UDim.new(0, data.maxHeight)
	else
		udim = UDim.new()
	end

	if data.autoSize then
		return (UDim2.new(UDim.new(), udim))
	end

	return (UDim2.new(data.width or UDim.new(), udim))
end

local function BaseMenuScrollContainer(props)
	local v = React.useBinding(true)
	local v2 = React.useBinding(nil)
	local autoSize = props.autoSize or v
	local width = props.width or v2
	local maxHeight = props.maxHeight

	local canvasSize, v3 = React.useBinding(UDim2.fromScale(0, 1))

	local isOverMaxHeight = React.useMemo(function()
		return React.joinBindings({ canvasSize = canvasSize, maxHeight = maxHeight }):map(function(p): boolean
			return p.maxHeight ~= nil and p.canvasSize.Y.Offset > p.maxHeight
		end)
	end, { maxHeight })

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		return v3(UDim2.fromOffset(p.AbsoluteSize.X, p.AbsoluteSize.Y))
	end, { v3 })

	local mapped = React.joinBindings({ autoSize = autoSize, isOverMaxHeight = isOverMaxHeight }):map(computeAutomaticSize)

	return React.createElement(ScrollView, withCommonProps(props.scrollViewProps, {
		ref = props.scrollViewProps.ref,
		sizeConstraint = props.scrollViewProps.sizeConstraint,
		tag = props.scrollViewProps.tag,
		InputSink = props.scrollViewProps.InputSink,
		scrollingFrameRef = props.scrollViewProps.scrollingFrameRef,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			AutomaticSize = mapped,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			CanvasSize = canvasSize
		},
		AutomaticSize = mapped,
		Size = React.joinBindings({
			autoSize = autoSize,
			width = width,
			isOverMaxHeight = isOverMaxHeight,
			maxHeight = maxHeight
		}):map(computeSize)
	}), React.createElement(
		View,
		{ tag = "col size-full-0 auto-y", onAbsoluteSizeChanged = onAbsoluteSizeChanged },
		props.children
	))
end

return BaseMenuScrollContainer
