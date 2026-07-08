local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local ReactOtter = require(MomentsCreationFlowParent.ReactOtter)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local validateRefs = require(MomentsCreationFlow.Utils.validateRefs)
local DragHandle = require(MomentsCreationFlow.Enums.DragHandle)

local function useTrimDragController(b1: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any), p5, n1: number) -- line: 20
	-- upvalues: useRef (copy), useAnimatedBinding (copy), useCallback (copy), validateRefs (copy), DragHandle (copy), MomentsCommon (copy), ReactOtter (copy), useEffect (copy)
	local v20 = useRef(nil)
	local v21 = useRef(nil)
	local v22 = useRef(nil)
	local v23 = useRef(nil)
	local v24 = useRef(nil)
	local v25 = useRef(nil)
	local v26, v27 = useAnimatedBinding(p5 and p5.startTime / n1 or 0)
	local v28, v29 = useAnimatedBinding(p5 and p5.endTime / n1 or 1)
	local v30 = useRef(nil)
	local v31 = useRef(nil)
	local v32 = useRef(nil)
	local v33 = useRef(nil)
	local v34 = useCallback(function() -- line: 47
		-- upvalues: validateRefs (copy), v21 (copy), v33 (copy), DragHandle (copy), v30 (copy), v26 (copy), p2 (copy)
		if not validateRefs({ v21 }) or v33.current then
			return
		end

		assert(v21.current ~= nil, "Left handle ref is nil")
		v33.current = DragHandle.LeftHandle
		v30.current = v26:getValue()
		p2(DragHandle.LeftHandle)
	end, { p2 })
	local v35 = useCallback(function() -- line: 58
		-- upvalues: validateRefs (copy), v30 (copy), v21 (copy), v28 (copy), MomentsCommon (copy), n1 (copy), v27 (copy), ReactOtter (copy)
		if not validateRefs({
			v30,
			v21
		}) then
			return
		end

		assert(v30.current ~= nil, "Left handle initial position ref is nil")
		assert(v21.current ~= nil, "Left handle ref is nil")

		local current = v21.current
		local v47 = math.clamp(v30.current + current.DragUDim2.X.Scale, 0, v28:getValue() - MomentsCommon.Constants.MinimumVideoLength / n1)

		v27(ReactOtter.instant(v47))
	end, { n1 })
	local v36 = useCallback(function() -- line: 75
		-- upvalues: v33 (copy), DragHandle (copy), p3 (copy), v26 (copy), n1 (copy), v30 (copy), p1 (copy)
		if v33.current ~= DragHandle.LeftHandle then
			return
		end

		p3(v26:getValue() * n1, nil)
		v33.current = nil
		v30.current = nil
		p1()
	end, {
		p1,
		p3,
		n1
	})
	local v37 = useCallback(function() -- line: 86
		-- upvalues: validateRefs (copy), v22 (copy), v33 (copy), DragHandle (copy), v31 (copy), v28 (copy), p2 (copy)
		if not validateRefs({ v22 }) or v33.current then
			return
		end

		assert(v22.current ~= nil, "Right handle ref is nil")
		v33.current = DragHandle.RightHandle
		v31.current = v28:getValue()
		p2(DragHandle.RightHandle)
	end, { p2 })
	local v38 = useCallback(function() -- line: 97
		-- upvalues: validateRefs (copy), v31 (copy), v22 (copy), v26 (copy), MomentsCommon (copy), n1 (copy), v29 (copy), ReactOtter (copy)
		if not validateRefs({
			v31,
			v22
		}) then
			return
		end

		assert(v22.current ~= nil, "Right handle ref is nil")

		local current = v22.current
		local v49 = math.clamp(v31.current + current.DragUDim2.X.Scale, v26:getValue() + MomentsCommon.Constants.MinimumVideoLength / n1, 1)

		v29(ReactOtter.instant(v49))
	end, { n1 })
	local v39 = useCallback(function() -- line: 113
		-- upvalues: v33 (copy), DragHandle (copy), p3 (copy), v28 (copy), n1 (copy), v31 (copy), p1 (copy)
		if v33.current ~= DragHandle.RightHandle then
			return
		end

		p3(nil, v28:getValue() * n1)
		v33.current = nil
		v31.current = nil
		p1()
	end, {
		p1,
		p3,
		n1
	})
	local v40 = useCallback(function() -- line: 124
		-- upvalues: validateRefs (copy), v25 (copy), v24 (copy), v33 (copy), DragHandle (copy), v32 (copy), p2 (copy)
		if not validateRefs({
			v25,
			v24
		}) or v33.current then
			return
		end

		assert(v25.current ~= nil, "Scrubber ref is nil")
		assert(v24.current ~= nil, "Scrubber display ref is nil")
		v33.current = DragHandle.Scrubber
		v32.current = v24.current.Position.X.Scale
		p2(DragHandle.Scrubber)
	end, { p2 })
	local v41 = useCallback(function() -- line: 136
		-- upvalues: validateRefs (copy), v32 (copy), v25 (copy), p4 (copy)
		if not validateRefs({
			v32,
			v25
		}) then
			return
		end

		assert(v32.current ~= nil, "Scrubber initial position ref is nil")
		assert(v25.current ~= nil, "Scrubber ref is nil")

		local current = v25.current
		local v51 = math.clamp(v32.current + current.DragUDim2.X.Scale, 0, 1)

		p4(v51)
	end, { p4 })
	local v42 = useCallback(function() -- line: 149
		-- upvalues: v33 (copy), DragHandle (copy), v32 (copy), p1 (copy)
		if v33.current ~= DragHandle.Scrubber then
			return
		end

		v33.current = nil
		v32.current = nil
		p1()
	end, { p1 })
	local v43 = useCallback(function() -- line: 159
		-- upvalues: validateRefs (copy), v23 (copy), v33 (copy), DragHandle (copy), v30 (copy), v26 (copy), v31 (copy), v28 (copy), p2 (copy)
		if not validateRefs({ v23 }) or v33.current then
			return
		end

		assert(v23.current ~= nil, "Selected outline ref is nil")
		v33.current = DragHandle.Segment
		v30.current = v26:getValue()
		v31.current = v28:getValue()
		p2(DragHandle.Segment)
	end, { p2 })
	local v44 = useCallback(function() -- line: 171
		-- upvalues: validateRefs (copy), v23 (copy), v30 (copy), v21 (copy), v31 (copy), v22 (copy), v27 (copy), ReactOtter (copy), v29 (copy), p3 (copy), n1 (copy)
		if not validateRefs({
			v23,
			v30,
			v21,
			v31,
			v22
		}) then
			return
		end

		assert(v23.current ~= nil, "Selected outline ref is nil")
		assert(v30.current ~= nil, "Left handle initial position ref is nil")
		assert(v21.current ~= nil, "Left handle ref is nil")
		assert(v31.current ~= nil, "Right handle initial position ref is nil")
		assert(v22.current ~= nil, "Right handle ref is nil")

		local XScale = v23.current.DragUDim2.X.Scale
		local current = v30.current
		local current2 = v31.current

		if current <= 0 and current2 >= 1 then
			return
		end

		local v55 = math.clamp(XScale, -current, 1 - current2)
		local v56 = current + v55
		local v57 = current2 + v55

		v27(ReactOtter.instant(v56))
		v29(ReactOtter.instant(v57))
		p3(v56 * n1, v57 * n1)
	end, {
		p3,
		n1
	})
	local v45 = useCallback(function() -- line: 209
		-- upvalues: v33 (copy), DragHandle (copy), v30 (copy), v31 (copy), p1 (copy)
		if v33.current ~= DragHandle.Segment then
			return
		end

		v33.current = nil
		v30.current = nil
		v31.current = nil
		p1()
	end, { p1 })

	useEffect(function() -- line: 220
		-- upvalues: b1 (copy), v21 (copy), v34 (copy), v35 (copy), v36 (copy), v22 (copy), v37 (copy), v38 (copy), v39 (copy), v25 (copy), v40 (copy), v41 (copy), v42 (copy), v23 (copy), v43 (copy), v44 (copy), v45 (copy)
		if not b1 then
			return
		end

		local t1 = {}

		if v21.current then
			table.insert(t1, v21.current.DragStart:Connect(v34))
			table.insert(t1, v21.current.DragContinue:Connect(v35))
			table.insert(t1, v21.current.DragEnd:Connect(v36))
		end

		if v22.current then
			table.insert(t1, v22.current.DragStart:Connect(v37))
			table.insert(t1, v22.current.DragContinue:Connect(v38))
			table.insert(t1, v22.current.DragEnd:Connect(v39))
		end

		if v25.current then
			table.insert(t1, v25.current.DragStart:Connect(v40))
			table.insert(t1, v25.current.DragContinue:Connect(v41))
			table.insert(t1, v25.current.DragEnd:Connect(v42))
		end

		if v23.current then
			table.insert(t1, v23.current.DragStart:Connect(v43))
			table.insert(t1, v23.current.DragContinue:Connect(v44))
			table.insert(t1, v23.current.DragEnd:Connect(v45))
		end

		return function() -- line: 251
			-- upvalues: t1 (copy)
			for _, v60 in t1 do
				v60:Disconnect()
			end
		end
	end, {
		b1,
		v34,
		v35,
		v36,
		v37,
		v38,
		v39,
		v40,
		v41,
		v42,
		v43,
		v44,
		v45
	})

	return {
		dragContainerRef = v20,
		leftHandleRef = v21,
		rightHandleRef = v22,
		scrubberDisplayRef = v24,
		scrubberRef = v25,
		segmentRef = v23,
		leftHandlePosition = v26,
		rightHandlePosition = v28
	}
end

return useTrimDragController
