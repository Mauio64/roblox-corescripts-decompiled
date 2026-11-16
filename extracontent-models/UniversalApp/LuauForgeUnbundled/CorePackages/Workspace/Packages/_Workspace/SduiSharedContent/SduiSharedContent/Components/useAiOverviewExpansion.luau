local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/ReactOtter")

local v5 = { dampingRatio = 0.9, frequency = 6 }

local function useAiOverviewExpansion(data)
	local v6 = not (data.hasHeader and data.hasExpandableBody) and 0 or data.sectionGap
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local ref = React.useRef(false)

	local state3, setState3 = React.useState(nil)
	local state4, setState4 = React.useState(nil)
	local v7 = React.useCallback(function(p2)
		setState4(p2.AbsoluteSize.Y)
	end, {})
	local v8 = React.useCallback(function(p2)
		setState3(p2.AbsoluteSize.Y)
	end, {})

	local compactHeight = data.compactHeight
	local buttonHeight = data.buttonHeight
	local v9 = not (compactHeight == nil) and compactHeight > 0

	local v10 = state3 or 0
	local v11 = not data.hasHeader and 0 or (state4 or 0) + v6
	local v12 = buttonHeight + data.sectionGap
	local v13 = not v9 or not data.hasHeader or state4 ~= nil
	local v14 = not v9 or not data.hasExpandableBody or state3 ~= nil

	local v15 = not v9 and 0 or math.max(0, (not v9 and 0 or compactHeight) - v11 - v12)

	local v16 = if v9 then (if v13 then (if v14 then v15 > 0 and v15 + 1 < v10 else v14) else v13) else v9

	local v17 = v9 and data.hasExpandableBody and not (state or v13 and v14)
	local v18 = v16 and not state
	local v19 = v16 and state and not state2
	local v20 = v17 or v18 or v19
	local reducedMotion = data.reducedMotion
	local v22 = if state then v10 else not v20 and 0 or v15
	local v23 = React.useCallback(function()
		if ref.current then
			ref.current = false
			setState2(true)
		end
	end, {})

	local v24, v25 = ReactOtter.useAnimatedBinding(v22, v23)

	local v26 = React.useCallback(function()
		setState(true)

		if not v16 then
			return
		end

		if reducedMotion then
			ref.current = false
			setState2(true)
			v25(ReactOtter.instant(v10))
		else
			ref.current = true
			setState2(false)
			v25(ReactOtter.spring(v10, v5))
		end
	end, { v10, v16, reducedMotion, v25 })

	React.useLayoutEffect(function()
		if v19 then
			return
		end

		ref.current = false
		v25(ReactOtter.instant(v22))
	end, { v22, v19, v25 })

	return {
		isCompact = v18,
		shouldReserveCompactHeight = v17 or v18,
		useCompactViewport = v20,
		animatedViewportHeight = v24,
		onExpand = v26,
		onHeaderAbsoluteSizeChanged = v7,
		onContentAbsoluteSizeChanged = v8
	}
end

return useAiOverviewExpansion
