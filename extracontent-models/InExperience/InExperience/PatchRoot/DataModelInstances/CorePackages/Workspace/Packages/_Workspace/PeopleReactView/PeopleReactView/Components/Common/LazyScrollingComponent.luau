local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)
local View = require(Parent.Foundation).View
local FFlagEnablePeopleListLazyRender = require(Parent.PeopleService).getService("Flags").FFlagEnablePeopleListLazyRender
local v6 = game:DefineFastInt("PeoplePageLazyRenderThreshold", 100)

function LazyScrollingComponent(t1: {[any]: any}) -- line: 29
	-- upvalues: React (copy), v6 (copy), Signals (copy), View (copy), FFlagEnablePeopleListLazyRender (copy)
	local v8, v9 = React.useState(false)
	local v10 = React.useCallback(function(n1: number, n2: number, n3: number) -- line: 33
		-- upvalues: v6 (copy)
		return n1 < n2 + n3 + v6
	end, {})
	local v11 = React.useRef(nil)

	React.useEffect(function() -- line: 41
		-- upvalues: v8 (copy), v11 (copy), v9 (copy), v10 (copy), t1 (copy), Signals (copy)
		if v8 or not v11.current then
			return
		end

		v9(v10(v11.current.AbsolutePosition.Y, t1.scrollingFrameAbsolutePositionY(false), t1.scrollingFrameAbsoluteSizeY(false)))

		local connection = v11.current:GetPropertyChangedSignal("AbsolutePosition"):Connect(function() -- line: 59
			-- upvalues: v11 (copy), v9 (copy), v10 (copy), t1 (copy)
			if not v11.current then
				return
			end

			v9(v10(v11.current.AbsolutePosition.Y, t1.scrollingFrameAbsolutePositionY(false), t1.scrollingFrameAbsoluteSizeY(false)))
		end)
		local v16 = Signals.createEffect(function(p1) -- line: 74
			-- upvalues: t1 (copy), v11 (copy), v9 (copy), v10 (copy)
			t1.scrollingFrameCanvasPositionY(p1)

			local v18 = t1.scrollingFrameAbsolutePositionY(p1)
			local v19 = t1.scrollingFrameAbsoluteSizeY(p1)

			if not v11.current then
				return
			end

			v9(v10(v11.current.AbsolutePosition.Y, v18, v19))
		end)

		return function() -- line: 89
			-- upvalues: connection (copy), v16 (copy)
			if connection then
				connection:Disconnect()
			end

			v16()
		end
	end, { v8 })

	if not v8 then
		return React.createElement(View, {
			tag = not FFlagEnablePeopleListLazyRender and "auto-xy" or "size-full-0 auto-xy",
			ref = v11,
			LayoutOrder = t1.placeholderLayoutOrder
		}, {
			Placeholder = t1.placeholder
		})
	end

	return t1.children
end

return React.memo(LazyScrollingComponent)
