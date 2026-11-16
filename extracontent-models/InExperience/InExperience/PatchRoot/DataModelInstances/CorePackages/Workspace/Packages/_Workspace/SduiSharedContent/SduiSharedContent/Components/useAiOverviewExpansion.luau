local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local v = { dampingRatio = 0.9, frequency = 6 }

local function useAiOverviewExpansion(data)
	local v2 = not (data.hasHeader and data.hasExpandableBody) and 0 or data.sectionGap
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local onHeaderAbsoluteSizeChanged = React.useCallback(function(p)
		setState4(p.AbsoluteSize.Y)
	end, {})
	local onContentAbsoluteSizeChanged = React.useCallback(function(p)
		setState3(p.AbsoluteSize.Y)
	end, {})

	local compactHeight = data.compactHeight
	local buttonHeight = data.buttonHeight
	local v3

	if compactHeight == nil then
		v3 = false
	else
		v3 = compactHeight > 0
	end

	local v4 = state3 or 0
	local v5 = not data.hasHeader and 0 or (state4 or 0) + v2
	local v6 = buttonHeight + data.sectionGap
	local v7 = not v3 or not data.hasHeader or state4 ~= nil
	local v8 = not v3 or not data.hasExpandableBody or state3 ~= nil

	local v9 = not v3 and 0 or math.max(0, (not v3 and 0 or compactHeight) - v5 - v6)
	local v10

	if v3 then
		if v7 then
			if v8 then
				if v9 > 0 then
					v10 = v9 + 1 < v4
				else
					v10 = false
				end
			else
				v10 = v8
			end
		else
			v10 = v7
		end
	else
		v10 = v3
	end

	local v11 = v3 and data.hasExpandableBody and not (state or v7 and v8)
	local isCompact = v10 and not state
	local v12 = v10 and state and not state2
	local useCompactViewport = v11 or isCompact or v12
	local reducedMotion = data.reducedMotion
	local v13

	if state then
		v13 = v4
	else
		v13 = not useCompactViewport and 0 or v9
	end

	local v14 = React.useCallback(function()
		if ref.current then
			ref.current = false
			setState2(true)
		end
	end, {})

	local animatedViewportHeight, v15 = ReactOtter.useAnimatedBinding(v13, v14)

	local onExpand = React.useCallback(function()
		setState(true)

		if not v10 then
			return
		end

		if reducedMotion then
			ref.current = false
			setState2(true)
			v15((ReactOtter.instant(v4)))
		else
			ref.current = true
			setState2(false)
			v15((ReactOtter.spring(v4, v)))
		end
	end, { v4, v10, reducedMotion, v15 })

	React.useLayoutEffect(function()
		if v12 then
			return
		end

		ref.current = false
		v15((ReactOtter.instant(v13)))
	end, { v13, v12, v15 })

	return {
		isCompact = isCompact,
		shouldReserveCompactHeight = v11 or isCompact,
		useCompactViewport = useCompactViewport,
		animatedViewportHeight = animatedViewportHeight,
		onExpand = onExpand,
		onHeaderAbsoluteSizeChanged = onHeaderAbsoluteSizeChanged,
		onContentAbsoluteSizeChanged = onContentAbsoluteSizeChanged
	}
end

return useAiOverviewExpansion
