local AppSplitView = script:FindFirstAncestor("AppSplitView")
local AppSplitViewParent = AppSplitView.Parent
local React = require(AppSplitViewParent.React)
local Enums = require(AppSplitView.Common.Enums)

local function toSupportSize(n1: number) -- line: 10
	return UDim2.new(0, n1, 1, 0)
end
local function useSplitViewResize(t1: {[any]: any}) -- line: 21
	-- upvalues: Enums (copy), React (copy), toSupportSize (copy)
	local navWidth = t1.navWidth
	local supportWidth = t1.supportWidth
	local v11 = (t1.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight
	local v12, v13 = React.useBinding(supportWidth)
	local v14, v15 = React.useBinding(supportWidth)
	local v16 = React.useRef(supportWidth)
	local v17 = React.useRef(t1)

	v17.current = t1
	React.useEffect(function() -- line: 32
		-- upvalues: v13 (copy), supportWidth (copy), v16 (copy), v15 (copy)
		v13(supportWidth)

		if supportWidth == 0 then
			v16.current = 0
			v15(0)
		end
	end, { supportWidth })

	local v18 = React.useCallback(function(p1) -- line: 40
		-- upvalues: v16 (copy), v15 (copy)
		local AbsoluteSizeX = p1.AbsoluteSize.X

		v16.current = AbsoluteSizeX
		v15(AbsoluteSizeX)
	end, {})
	local v19 = React.useCallback(function(vector2: Vector2) -- line: 46
		-- upvalues: v17 (copy), Enums (copy), v13 (copy), v16 (copy)
		local v33 = (v17.current.variant or Enums.SplitVariant.SplitRight) ~= Enums.SplitVariant.SplitRight and 1 or -1

		v13(v16.current + v33 * vector2.X)
	end, {})
	local v20 = React.useCallback(function() -- line: 53
		-- upvalues: v17 (copy), v16 (copy)
		local current = v17.current

		if current.onSupportPaneWidthChanged then
			current.onSupportPaneWidthChanged(v16.current)
		end
	end, {})
	local v21 = React.useCallback(function(n2: number) -- line: 60
		-- upvalues: navWidth (copy)
		return UDim2.new(0, navWidth + n2, 0, 0)
	end, { navWidth })
	local v22 = React.useCallback(function(n3: number) -- line: 64
		-- upvalues: navWidth (copy)
		return UDim2.new(1, -(navWidth + n3), 1, 0)
	end, { navWidth })
	local v23 = React.useCallback(function(n4: number) -- line: 68
		-- upvalues: v11 (copy), navWidth (copy)
		local v38 = if not v11 then navWidth + n4 - 12 else -n4 - 12

		if v11 then
			return (UDim2.new(1, v38, 0, 0))
		end

		return (UDim2.new(0, v38, 0, 0))
	end, {
		navWidth,
		v11
	})
	local v24 = React.useCallback(function(n5: number) -- line: 73
		return UDim2.new(1, -n5, 0, 0)
	end, {})
	local v25 = React.useMemo(function() -- line: 77
		-- upvalues: v11 (copy), navWidth (copy), v14 (copy), v21 (copy)
		if v11 then
			return (UDim2.new(0, navWidth, 0, 0))
		end

		return (v14:map(v21))
	end, {
		v11,
		navWidth,
		v21
	})
	local v26 = React.useMemo(function() -- line: 81
		-- upvalues: v14 (copy), v22 (copy)
		return v14:map(v22)
	end, { v22 })
	local v27 = React.useMemo(function() -- line: 85
		-- upvalues: v11 (copy), v14 (copy), v24 (copy), navWidth (copy)
		if v11 then
			return (v14:map(v24))
		end

		return (UDim2.new(0, navWidth, 0, 0))
	end, {
		v11,
		navWidth,
		v24
	})
	local v28 = React.useMemo(function() -- line: 89
		-- upvalues: v12 (copy), toSupportSize (copy)
		return v12:map(toSupportSize)
	end, {})
	local v29 = React.useMemo(function() -- line: 93
		-- upvalues: v14 (copy), v23 (copy)
		return v14:map(v23)
	end, { v23 })

	return {
		resizerHitWidth = 24,
		contentPosition = v25,
		contentSize = v26,
		supportPosition = v27,
		supportSize = v28,
		resizerPosition = v29,
		onSupportAbsoluteSizeChanged = v18,
		onResizerDrag = v19,
		onResizerDragEnd = v20
	}
end

return useSplitViewResize
