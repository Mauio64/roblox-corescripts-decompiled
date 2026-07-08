local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local ReactOtter = require(Parent.ReactOtter)
local t1 = {
	dampingRatio = 0.9,
	frequency = 6
}

local function useAiOverviewExpansion(t2: {[any]: any}) -- line: 32
	-- upvalues: React (copy), ReactOtter (copy), t1 (copy)
	local v7 = (not t2.hasHeader or not t2.hasExpandableBody) and 0 or t2.sectionGap
	local v8, v9 = React.useState(false)
	local v10, v11 = React.useState(false)
	local v12 = React.useRef(false)
	local v13, v14 = React.useState(nil)
	local v15, v16 = React.useState(nil)
	local v17 = React.useCallback(function(p1) -- line: 40
		-- upvalues: v16 (copy)
		v16(p1.AbsoluteSize.Y)
	end, {})
	local v18 = React.useCallback(function(p2) -- line: 43
		-- upvalues: v14 (copy)
		v14(p2.AbsoluteSize.Y)
	end, {})
	local compactHeight = t2.compactHeight
	local buttonHeight = t2.buttonHeight
	local v21 = compactHeight ~= nil and compactHeight > 0
	local v22 = not v21 and 0 or compactHeight
	local v23 = v13 or 0
	local v24 = not t2.hasHeader and 0 or (v15 or 0) + v7
	local v25 = buttonHeight + t2.sectionGap
	local v26 = not v21 or (not t2.hasHeader or v15 ~= nil)
	local v27 = not v21 or (not t2.hasExpandableBody or v13 ~= nil)
	local v28 = not v21 and 0 or math.max(0, v22 - v24 - v25)
	local v29 = v21 and (v26 and (v27 and (v28 > 0 and v23 > v28 + 1)))
	local v30 = v21 and (t2.hasExpandableBody and (not v8 and not (v26 and v27)))
	local v31 = v29 and not v8
	local v32 = v29 and (v8 and not v10)
	local v33 = v30 or (v31 or v32)
	local v34 = v30 or v31
	local reducedMotion = t2.reducedMotion
	local v36 = if not v8 then not v33 and 0 or v28 else v23
	local v37 = React.useCallback(function() -- line: 78
		-- upvalues: v12 (copy), v11 (copy)
		if v12.current then
			v12.current = false
			v11(true)
		end
	end, {})
	local v38, v39 = ReactOtter.useAnimatedBinding(v36, v37)
	local v40 = React.useCallback(function() -- line: 88
		-- upvalues: v9 (copy), v29 (copy), reducedMotion (copy), v12 (copy), v11 (copy), v39 (copy), ReactOtter (copy), v23 (copy), t1 (copy)
		v9(true)

		if not v29 then
			return
		end

		if reducedMotion then
			v12.current = false
			v11(true)
			v39((ReactOtter.instant(v23)))

			return
		end

		v12.current = true
		v11(false)
		v39((ReactOtter.spring(v23, t1)))
	end, {
		v23,
		v29,
		reducedMotion,
		v39
	})

	React.useLayoutEffect(function() -- line: 110
		-- upvalues: v32 (copy), v12 (copy), v39 (copy), ReactOtter (copy), v36 (copy)
		if v32 then
			return
		end

		v12.current = false
		v39((ReactOtter.instant(v36)))
	end, {
		v36,
		v32,
		v39
	})

	return {
		isCompact = v31,
		shouldReserveCompactHeight = v34,
		useCompactViewport = v33,
		animatedViewportHeight = v38,
		onExpand = v40,
		onHeaderAbsoluteSizeChanged = v17,
		onContentAbsoluteSizeChanged = v18
	}
end

return useAiOverviewExpansion
