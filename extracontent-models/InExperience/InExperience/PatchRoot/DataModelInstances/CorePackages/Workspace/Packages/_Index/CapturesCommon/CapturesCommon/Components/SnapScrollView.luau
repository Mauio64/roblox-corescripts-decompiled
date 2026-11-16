local parent = script.Parent.Parent
local parent2 = parent.Parent

local Cryo = require(parent2.Cryo)
local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

require(parent.Enums.NavigationType)
require(parent.Signal)
local View = Foundation.View

local useCallback = React.useCallback
local useEffect = React.useEffect
local useSnapScrollController = require(parent.Hooks.useSnapScrollController)
local useState = React.useState

return function(props)
	local state, setState = useState(Vector2.new(0, 0))

	local v = props.active == nil or props.active
	local initialIndex = props.initialIndex or 1
	local itemAbsoluteSize = props.itemAbsoluteSize or state
	local windowSize = props.windowSize or 3

	local v2, ref, ref2, v3, v4 = useSnapScrollController(v, initialIndex, itemAbsoluteSize, #props.contents)

	local onAbsoluteSizeChanged = useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	useEffect(function()
		if props.onIndexChanged then
			props.onIndexChanged(v2)
		end
	end, { v2, props.onIndexChanged })

	local v5 = React.useMemo(function()
		return Cryo.List.map(props.contents, function(p, layoutOrder)
			if layoutOrder < v2 - windowSize or v2 + windowSize < layoutOrder then
				return React.createElement(View, {
					key = `PLACEHOLDER-{layoutOrder}`,
					LayoutOrder = layoutOrder,
					Size = UDim2.fromOffset(itemAbsoluteSize.X, itemAbsoluteSize.Y),
					tag = "anchor-top-center bg-action-subtle position-top-center"
				})
			end

			return props.renderContent(p, layoutOrder)
		end)
	end, { v2, itemAbsoluteSize, props.contents, props.renderContent, windowSize })

	useEffect(function()
		if not props.scrollToIndexSignal then
			return
		end

		local scrollToIndexSignalConnection = props.scrollToIndexSignal:connect(v3)
		return function()
			scrollToIndexSignalConnection:disconnect()
		end
	end, { props.scrollToIndexSignal, v3 })

	useEffect(function()
		if not props.triggerNavigationSignal then
			return
		end

		local triggerNavigationSignalConnection = props.triggerNavigationSignal:connect(v4)
		return function()
			triggerNavigationSignalConnection:disconnect()
		end
	end, { props.triggerNavigationSignal, v4 })

	return React.createElement(
		View,
		{
			onAbsoluteSizeChanged = onAbsoluteSizeChanged,
			ref = ref,
			tag = "anchor-top-center bg-action-subtle position-top-center size-full"
		},
		{
			MotionView = React.createElement(View, {
				LayoutOrder = 1,
				ref = ref2,
				Size = UDim2.fromScale(1, #props.contents),
				tag = "align-x-center anchor-top-center bg-action-subtle col no-clip position-top-center"
			}, v5)
		}
	)
end
