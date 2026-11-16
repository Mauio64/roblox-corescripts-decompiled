local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local PeopleService = require(parent.PeopleService)

local fFlagEnablePeopleListLazyRender = PeopleService.getService("Flags").FFlagEnablePeopleListLazyRender

local defineFastInt = game:DefineFastInt("PeoplePageLazyRenderThreshold", 100)

function LazyScrollingComponent(props)
	local state, setState = React.useState(false)

	local v = React.useCallback(function(p: number, p2: number, p3: number): boolean
		return p < p2 + p3 + defineFastInt
	end, {})

	local ref = React.useRef(nil)

	React.useEffect(function()
		if state or not ref.current then
			return
		end

		setState(v(
			ref.current.AbsolutePosition.Y,
			props.scrollingFrameAbsolutePositionY(false),
			props.scrollingFrameAbsoluteSizeY(false)
		))

		local absolutePositionChangedConnection = ref.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if not ref.current then
				return
			end

			setState(v(
				ref.current.AbsolutePosition.Y,
				props.scrollingFrameAbsolutePositionY(false),
				props.scrollingFrameAbsoluteSizeY(false)
			))
		end)

		local effect = Signals.createEffect(function(p)
			props.scrollingFrameCanvasPositionY(p)

			local scrollingFrameAbsolutePositionY = props.scrollingFrameAbsolutePositionY(p)
			local scrollingFrameAbsoluteSizeY = props.scrollingFrameAbsoluteSizeY(p)

			if not ref.current then
				return
			end

			setState(v(ref.current.AbsolutePosition.Y, scrollingFrameAbsolutePositionY, scrollingFrameAbsoluteSizeY))
		end)

		return function()
			if absolutePositionChangedConnection then
				absolutePositionChangedConnection:Disconnect()
			end

			effect()
		end
	end, { state })

	if state then
		return props.children
	end

	return React.createElement(View, {
		tag = fFlagEnablePeopleListLazyRender and "size-full-0 auto-xy" or "auto-xy",
		ref = ref,
		LayoutOrder = props.placeholderLayoutOrder
	}, { Placeholder = props.placeholder })
end

return React.memo(LazyScrollingComponent)
