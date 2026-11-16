local AppSplitView = script:FindFirstAncestor("AppSplitView")
local parent = AppSplitView.Parent

local React = require(parent.React)

local Enums = require(AppSplitView.Common.Enums)

local function toSupportSize(p: number)
	return UDim2.new(0, p, 1, 0)
end

local function useSplitViewResize(current)
	local navWidth = current.navWidth
	local supportWidth = current.supportWidth
	local v = (current.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight

	local state, setState = React.useState(current.hasWidthOverride == true)

	local v2, v3 = React.useBinding(supportWidth)
	local v4, v5 = React.useBinding(supportWidth)
	local ref = React.useRef(supportWidth)
	local ref2 = React.useRef(current)
	ref2.current = current

	React.useEffect(function()
		if current.hasWidthOverride then
			setState(true)
		end
	end, { current.hasWidthOverride })

	React.useEffect(function()
		v3(supportWidth)

		if supportWidth == 0 then
			ref.current = 0
			v5(0)
		end
	end, { supportWidth })

	local onSupportAbsoluteSizeChanged = React.useCallback(function(p)
		local x = p.AbsoluteSize.X
		ref.current = x
		v5(x)
	end, {})

	local onResizerDrag = React.useCallback(function(vector2: Vector2)
		setState(true)
		local v6 = (ref2.current.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight and -1 or 1

		v3(ref.current + v6 * vector2.X)
	end, {})

	local onResizerDragEnd = React.useCallback(function()
		local current2 = ref2.current

		if current2.onSupportPaneWidthChanged then
			current2.onSupportPaneWidthChanged(ref.current)
		end
	end, {})

	local v6 = React.useCallback(function(p: number)
		return UDim2.new(0, navWidth + p, 0, 0)
	end, { navWidth })

	local v7 = React.useCallback(function(p: number)
		return UDim2.new(1, -(navWidth + p), 1, 0)
	end, { navWidth })

	local v8 = React.useCallback(function(p: number)
		local v8

		if v then
			v8 = -p - 12
		else
			v8 = navWidth + p - 12
		end

		if v then
			return (UDim2.new(1, v8, 0, 0))
		end

		return (UDim2.new(0, v8, 0, 0))
	end, { navWidth, v })

	local v9 = React.useCallback(function(p: number)
		return UDim2.new(1, -p, 0, 0)
	end, {})

	local contentPosition = React.useMemo(function()
		if v then
			return (UDim2.new(0, navWidth, 0, 0))
		end

		return (v4:map(v6))
	end, { v, navWidth, v6 })

	local contentSize = React.useMemo(function()
		return v4:map(v7)
	end, { v7 })

	local supportPosition = React.useMemo(function()
		if v then
			return (v4:map(v9))
		end

		return (UDim2.new(0, navWidth, 0, 0))
	end, { v, navWidth, v9 })

	local supportSize = React.useMemo(function()
		return v2:map(toSupportSize)
	end, {})

	if not state then
		supportSize = nil
	end

	return {
		contentPosition = contentPosition,
		contentSize = contentSize,
		supportPosition = supportPosition,
		supportSize = supportSize,
		resizerPosition = React.useMemo(function()
			return v4:map(v8)
		end, { v8 }),
		resizerHitWidth = 24,
		onSupportAbsoluteSizeChanged = onSupportAbsoluteSizeChanged,
		onResizerDrag = onResizerDrag,
		onResizerDragEnd = onResizerDragEnd
	}
end

return useSplitViewResize
