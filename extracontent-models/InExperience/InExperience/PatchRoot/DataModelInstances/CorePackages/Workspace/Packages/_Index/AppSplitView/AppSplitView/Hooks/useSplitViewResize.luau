local AppSplitView = script:FindFirstAncestor("AppSplitView")
local AppSplitViewParent = AppSplitView.Parent
local React = require(AppSplitViewParent.React)
local Enums = require(AppSplitView.Common.Enums)

local function toSupportSize(n1: number) -- line: 10
	return UDim2.new(0, n1, 1, 0)
end
local function useSplitViewResize(t1: {[any]: any}) -- line: 22
	-- upvalues: Enums (copy), React (copy), toSupportSize (copy)
	local navWidth = t1.navWidth
	local supportWidth = t1.supportWidth
	local v11 = (t1.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight
	local v12, v13 = React.useState(t1.hasWidthOverride == true)
	local v14, v15 = React.useBinding(supportWidth)
	local v16, v17 = React.useBinding(supportWidth)
	local v18 = React.useRef(supportWidth)
	local v19 = React.useRef(t1)

	v19.current = t1
	React.useEffect(function() -- line: 35
		-- upvalues: t1 (copy), v13 (copy)
		if t1.hasWidthOverride then
			v13(true)
		end
	end, { t1.hasWidthOverride })
	React.useEffect(function() -- line: 41
		-- upvalues: v15 (copy), supportWidth (copy), v18 (copy), v17 (copy)
		v15(supportWidth)

		if supportWidth == 0 then
			v18.current = 0
			v17(0)
		end
	end, { supportWidth })

	local v20 = React.useCallback(function(p1) -- line: 49
		-- upvalues: v18 (copy), v17 (copy)
		local AbsoluteSizeX = p1.AbsoluteSize.X

		v18.current = AbsoluteSizeX
		v17(AbsoluteSizeX)
	end, {})
	local v21 = React.useCallback(function(vector2: Vector2) -- line: 55
		-- upvalues: v13 (copy), v19 (copy), Enums (copy), v15 (copy), v18 (copy)
		v13(true)

		local v35 = (v19.current.variant or Enums.SplitVariant.SplitRight) ~= Enums.SplitVariant.SplitRight and 1 or -1

		v15(v18.current + v35 * vector2.X)
	end, {})
	local v22 = React.useCallback(function() -- line: 63
		-- upvalues: v19 (copy), v18 (copy)
		local current = v19.current

		if current.onSupportPaneWidthChanged then
			current.onSupportPaneWidthChanged(v18.current)
		end
	end, {})
	local v23 = React.useCallback(function(n2: number) -- line: 70
		-- upvalues: navWidth (copy)
		return UDim2.new(0, navWidth + n2, 0, 0)
	end, { navWidth })
	local v24 = React.useCallback(function(n3: number) -- line: 74
		-- upvalues: navWidth (copy)
		return UDim2.new(1, -(navWidth + n3), 1, 0)
	end, { navWidth })
	local v25 = React.useCallback(function(n4: number) -- line: 78
		-- upvalues: v11 (copy), navWidth (copy)
		local v40 = if not v11 then navWidth + n4 - 12 else -n4 - 12

		if v11 then
			return (UDim2.new(1, v40, 0, 0))
		end

		return (UDim2.new(0, v40, 0, 0))
	end, {
		navWidth,
		v11
	})
	local v26 = React.useCallback(function(n5: number) -- line: 83
		return UDim2.new(1, -n5, 0, 0)
	end, {})
	local v27 = React.useMemo(function() -- line: 87
		-- upvalues: v11 (copy), navWidth (copy), v16 (copy), v23 (copy)
		if v11 then
			return (UDim2.new(0, navWidth, 0, 0))
		end

		return (v16:map(v23))
	end, {
		v11,
		navWidth,
		v23
	})
	local v28 = React.useMemo(function() -- line: 91
		-- upvalues: v16 (copy), v24 (copy)
		return v16:map(v24)
	end, { v24 })
	local v29 = React.useMemo(function() -- line: 95
		-- upvalues: v11 (copy), v16 (copy), v26 (copy), navWidth (copy)
		if v11 then
			return (v16:map(v26))
		end

		return (UDim2.new(0, navWidth, 0, 0))
	end, {
		v11,
		navWidth,
		v26
	})
	local v30 = React.useMemo(function() -- line: 99
		-- upvalues: v14 (copy), toSupportSize (copy)
		return v14:map(toSupportSize)
	end, {})
	local v31 = React.useMemo(function() -- line: 104
		-- upvalues: v16 (copy), v25 (copy)
		return v16:map(v25)
	end, { v25 })

	return {
		resizerHitWidth = 24,
		contentPosition = v27,
		contentSize = v28,
		supportPosition = v29,
		supportSize = if not v12 then nil else v30,
		resizerPosition = v31,
		onSupportAbsoluteSizeChanged = v20,
		onResizerDrag = v21,
		onResizerDragEnd = v22
	}
end

return useSplitViewResize
