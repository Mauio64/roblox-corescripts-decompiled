local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppSplitView/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Common/Enums")

local function toSupportSize(p2)
	return UDim2.new(0, p2, 1, 0)
end

local function useSplitViewResize(current)
	local navWidth = current.navWidth
	local supportWidth = current.supportWidth
	local v5 = (current.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight

	local state, setState = React.useState(current.hasWidthOverride == true)

	local v6, v7 = React.useBinding(supportWidth)
	local v8, v9 = React.useBinding(supportWidth)
	local ref = React.useRef(supportWidth)
	local ref2 = React.useRef(current)
	ref2.current = current

	React.useEffect(function()
		if current.hasWidthOverride then
			setState(true)
		end
	end, { current.hasWidthOverride })

	React.useEffect(function()
		v7(supportWidth)

		if supportWidth == 0 then
			ref.current = 0
			v9(0)
		end
	end, { supportWidth })

	local v10 = React.useCallback(function(p2)
		local x = p2.AbsoluteSize.X
		ref.current = x
		v9(x)
	end, {})

	local v11 = React.useCallback(function(p2)
		setState(true)
		local v12 = (ref2.current.variant or Enums.SplitVariant.SplitRight) == Enums.SplitVariant.SplitRight
			and -1
			or 1

		v7(ref.current + v12 * p2.X)
	end, {})

	local v12 = React.useCallback(function()
		local current2 = ref2.current

		if current2.onSupportPaneWidthChanged then
			current2.onSupportPaneWidthChanged(ref.current)
		end
	end, {})

	local v13 = React.useCallback(function(p2)
		return UDim2.new(0, navWidth + p2, 0, 0)
	end, { navWidth })

	local v14 = React.useCallback(function(p2)
		return UDim2.new(1, -(navWidth + p2), 1, 0)
	end, { navWidth })

	local v15 = React.useCallback(function(p2)
		local v16 = if v5 then -p2 - 12 else navWidth + p2 - 12

		if v5 then
			return (UDim2.new(1, v16, 0, 0))
		end

		return (UDim2.new(0, v16, 0, 0))
	end, { navWidth, v5 })

	local v16 = React.useCallback(function(p2)
		return UDim2.new(1, -p2, 0, 0)
	end, {})

	local v17 = React.useMemo(function()
		if v5 then
			return (UDim2.new(0, navWidth, 0, 0))
		end

		return (v8:map(v13))
	end, { v5, navWidth, v13 })

	local v18 = React.useMemo(function()
		return v8:map(v14)
	end, { v14 })

	local v19 = React.useMemo(function()
		if v5 then
			return (v8:map(v16))
		end

		return (UDim2.new(0, navWidth, 0, 0))
	end, { v5, navWidth, v16 })

	local v20 = React.useMemo(function()
		return v6:map(toSupportSize)
	end, {})

	if not state then
		v20 = nil
	end

	return {
		contentPosition = v17,
		contentSize = v18,
		supportPosition = v19,
		supportSize = v20,
		resizerPosition = React.useMemo(function()
			return v8:map(v15)
		end, { v15 }),
		resizerHitWidth = 24,
		onSupportAbsoluteSizeChanged = v10,
		onResizerDrag = v11,
		onResizerDragEnd = v12
	}
end

return useSplitViewResize
