local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)

require(ParentParent.Enums.NavigationType)
require(ParentParent.Signal)

local View = Foundation.View
local useCallback = React.useCallback
local useEffect = React.useEffect
local useSnapScrollController = require(ParentParent.Hooks.useSnapScrollController)
local useState = React.useState

return function(t1: {[any]: any}) -- line: 33
	-- upvalues: useState (copy), useSnapScrollController (copy), useCallback (copy), useEffect (copy), React (copy), Cryo (copy), View (copy)
	local v12, v13 = useState(Vector2.new(0, 0))
	local v14 = t1.active == nil or t1.active
	local v15 = t1.initialIndex or 1
	local v16 = t1.itemAbsoluteSize or v12
	local v17 = t1.windowSize or 3
	local v18, v19, v20, v21, v22 = useSnapScrollController(v14, v15, v16, #t1.contents)
	local v23 = useCallback(function(p1) -- line: 44
		-- upvalues: v13 (copy)
		v13(p1.AbsoluteSize)
	end, {})

	useEffect(function() -- line: 48
		-- upvalues: t1 (copy), v18 (copy)
		if t1.onIndexChanged then
			t1.onIndexChanged(v18)
		end
	end, {
		v18,
		t1.onIndexChanged
	})

	local v24 = React.useMemo(function() -- line: 54
		-- upvalues: Cryo (copy), t1 (copy), v18 (copy), v17 (copy), React (copy), View (copy), v16 (copy)
		return Cryo.List.map(t1.contents, function(p2, p3) -- line: 55
			-- upvalues: v18 (copy), v17 (copy), React (copy), View (copy), v16 (copy), t1 (copy)
			if p3 < v18 - v17 or p3 > v18 + v17 then
				return React.createElement(View, {
					tag = "anchor-top-center bg-action-subtle position-top-center",
					key = `PLACEHOLDER-{ p3 }`,
					LayoutOrder = p3,
					Size = UDim2.fromOffset(v16.X, v16.Y)
				})
			end

			return t1.renderContent(p2, p3)
		end)
	end, {
		v18,
		v16,
		t1.contents,
		t1.renderContent,
		v17
	})

	useEffect(function() -- line: 68
		-- upvalues: t1 (copy), v21 (copy)
		if not t1.scrollToIndexSignal then
			return
		end

		local v26 = t1.scrollToIndexSignal:connect(v21)

		return function() -- line: 74
			-- upvalues: v26 (copy)
			v26:disconnect()
		end
	end, {
		t1.scrollToIndexSignal,
		v21
	})
	useEffect(function() -- line: 79
		-- upvalues: t1 (copy), v22 (copy)
		if not t1.triggerNavigationSignal then
			return
		end

		local v27 = t1.triggerNavigationSignal:connect(v22)

		return function() -- line: 85
			-- upvalues: v27 (copy)
			v27:disconnect()
		end
	end, {
		t1.triggerNavigationSignal,
		v22
	})

	return React.createElement(View, {
		tag = "anchor-top-center bg-action-subtle position-top-center size-full",
		onAbsoluteSizeChanged = v23,
		ref = v19
	}, {
		MotionView = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center anchor-top-center bg-action-subtle col no-clip position-top-center",
			ref = v20,
			Size = UDim2.fromScale(1, #t1.contents)
		}, v24)
	})
end
