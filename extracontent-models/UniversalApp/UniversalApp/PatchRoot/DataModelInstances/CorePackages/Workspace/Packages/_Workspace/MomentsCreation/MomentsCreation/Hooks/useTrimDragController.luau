local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local React = require(MomentsCreationParent.React)
local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local validateRefs = require(MomentsCreation.Utils.validateRefs)
local DragHandle = require(MomentsCreation.Enums.DragHandle)

require(MomentsCreationParent.MomentsTypes)

local function initialFraction(n1: number?, n2: number, n3: number) -- line: 38
	if n1 ~= nil and n2 > 0 then
		return n1 / n2
	end

	return n3
end
local function useTrimDragController(b1: boolean, p1: ((...any) -> ...any), p2: ((...any) -> ...any), p3: ((...any) -> ...any), p4: ((...any) -> ...any), p5, n4: number, p6: ((...any) -> ...any)?) -- line: 45
	-- upvalues: useRef (copy), useBinding (copy), useCallback (copy), validateRefs (copy), DragHandle (copy), useEffect (copy)
	local v23 = useRef(nil)
	local v24 = useRef(nil)
	local v25 = useRef(nil)
	local v26 = useRef(nil)
	local v27 = useRef(nil)
	local v28 = useRef(nil)
	local v29 = useBinding
	local v30 = if not p5 then nil else p5.startTime
	local v31, v32 = v29((v30 == nil or not (n4 > 0)) and 0 or v30 / n4)
	local v33 = useBinding
	local v34 = if not p5 then nil else p5.endTime
	local v35, v36 = v33((v34 == nil or not (n4 > 0)) and 1 or v34 / n4)
	local v37 = useRef(nil)
	local v38 = useRef(nil)
	local v39 = useRef(nil)
	local v40 = useRef(nil)
	local v41 = not (n4 > 0) and 0 or 1 / n4
	local v42 = useCallback(function() -- line: 78
		-- upvalues: validateRefs (copy), v24 (copy), v40 (copy), DragHandle (copy), v37 (copy), v31 (copy), p2 (copy)
		if not validateRefs({ v24 }) or v40.current then
			return
		end

		v40.current = DragHandle.LeftHandle
		v37.current = v31:getValue()
		p2(DragHandle.LeftHandle)
	end, { p2 })
	local v43 = useCallback(function() -- line: 87
		-- upvalues: validateRefs (copy), v37 (copy), v24 (copy), v35 (copy), v41 (copy), v32 (copy), p6 (copy), DragHandle (copy)
		if not validateRefs({
			v37,
			v24
		}) then
			return
		end

		local current = v24.current
		local v55 = math.clamp(v37.current + current.DragUDim2.X.Scale, 0, v35:getValue() - v41)

		v32(v55)

		if p6 then
			p6(DragHandle.LeftHandle, v55, v35:getValue())
		end
	end, {
		v41,
		p6
	})
	local v44 = useCallback(function() -- line: 102
		-- upvalues: v40 (copy), DragHandle (copy), p3 (copy), v31 (copy), n4 (copy), v37 (copy), p1 (copy)
		if v40.current ~= DragHandle.LeftHandle then
			return
		end

		p3(v31:getValue() * n4, nil)
		v40.current = nil
		v37.current = nil
		p1()
	end, {
		p1,
		p3,
		n4
	})
	local v45 = useCallback(function() -- line: 112
		-- upvalues: validateRefs (copy), v25 (copy), v40 (copy), DragHandle (copy), v38 (copy), v35 (copy), p2 (copy)
		if not validateRefs({ v25 }) or v40.current then
			return
		end

		v40.current = DragHandle.RightHandle
		v38.current = v35:getValue()
		p2(DragHandle.RightHandle)
	end, { p2 })
	local v46 = useCallback(function() -- line: 121
		-- upvalues: validateRefs (copy), v38 (copy), v25 (copy), v31 (copy), v41 (copy), v36 (copy), p6 (copy), DragHandle (copy)
		if not validateRefs({
			v38,
			v25
		}) then
			return
		end

		local current = v25.current
		local v57 = math.clamp(v38.current + current.DragUDim2.X.Scale, v31:getValue() + v41, 1)

		v36(v57)

		if p6 then
			p6(DragHandle.RightHandle, v31:getValue(), v57)
		end
	end, {
		v41,
		p6
	})
	local v47 = useCallback(function() -- line: 135
		-- upvalues: v40 (copy), DragHandle (copy), p3 (copy), v35 (copy), n4 (copy), v38 (copy), p1 (copy)
		if v40.current ~= DragHandle.RightHandle then
			return
		end

		p3(nil, v35:getValue() * n4)
		v40.current = nil
		v38.current = nil
		p1()
	end, {
		p1,
		p3,
		n4
	})
	local v48 = useCallback(function() -- line: 145
		-- upvalues: validateRefs (copy), v28 (copy), v27 (copy), v40 (copy), DragHandle (copy), v39 (copy), p2 (copy)
		if not validateRefs({
			v28,
			v27
		}) or v40.current then
			return
		end

		v40.current = DragHandle.Scrubber
		v39.current = v27.current.Position.X.Scale
		p2(DragHandle.Scrubber)
	end, { p2 })
	local v49 = useCallback(function() -- line: 154
		-- upvalues: validateRefs (copy), v39 (copy), v28 (copy), p4 (copy)
		if not validateRefs({
			v39,
			v28
		}) then
			return
		end

		local current = v28.current
		local v59 = math.clamp(v39.current + current.DragUDim2.X.Scale, 0, 1)

		p4(v59)
	end, { p4 })
	local v50 = useCallback(function() -- line: 164
		-- upvalues: v40 (copy), DragHandle (copy), v39 (copy), p1 (copy)
		if v40.current ~= DragHandle.Scrubber then
			return
		end

		v40.current = nil
		v39.current = nil
		p1()
	end, { p1 })
	local v51 = useCallback(function() -- line: 173
		-- upvalues: validateRefs (copy), v26 (copy), v40 (copy), DragHandle (copy), v37 (copy), v31 (copy), v38 (copy), v35 (copy), p2 (copy)
		if not validateRefs({ v26 }) or v40.current then
			return
		end

		v40.current = DragHandle.Segment
		v37.current = v31:getValue()
		v38.current = v35:getValue()
		p2(DragHandle.Segment)
	end, { p2 })
	local v52 = useCallback(function() -- line: 183
		-- upvalues: validateRefs (copy), v26 (copy), v37 (copy), v24 (copy), v38 (copy), v25 (copy), v32 (copy), v36 (copy), p3 (copy), n4 (copy)
		if not validateRefs({
			v26,
			v37,
			v24,
			v38,
			v25
		}) then
			return
		end

		local XScale = v26.current.DragUDim2.X.Scale
		local current = v37.current
		local current2 = v38.current

		if current <= 0 and current2 >= 1 then
			return
		end

		local v63 = math.clamp(XScale, -current, 1 - current2)
		local v64 = current + v63
		local v65 = current2 + v63

		v32(v64)
		v36(v65)
		p3(v64 * n4, v65 * n4)
	end, {
		p3,
		n4
	})
	local v53 = useCallback(function() -- line: 214
		-- upvalues: v40 (copy), DragHandle (copy), v37 (copy), v38 (copy), p1 (copy)
		if v40.current ~= DragHandle.Segment then
			return
		end

		v40.current = nil
		v37.current = nil
		v38.current = nil
		p1()
	end, { p1 })

	useEffect(function() -- line: 225
		-- upvalues: b1 (copy), v24 (copy), v42 (copy), v43 (copy), v44 (copy), v25 (copy), v45 (copy), v46 (copy), v47 (copy), v28 (copy), v48 (copy), v49 (copy), v50 (copy), v26 (copy), v51 (copy), v52 (copy), v53 (copy)
		if not b1 then
			return
		end

		local t1 = {}

		if v24.current then
			table.insert(t1, v24.current.DragStart:Connect(v42))
			table.insert(t1, v24.current.DragContinue:Connect(v43))
			table.insert(t1, v24.current.DragEnd:Connect(v44))
		end

		if v25.current then
			table.insert(t1, v25.current.DragStart:Connect(v45))
			table.insert(t1, v25.current.DragContinue:Connect(v46))
			table.insert(t1, v25.current.DragEnd:Connect(v47))
		end

		if v28.current then
			table.insert(t1, v28.current.DragStart:Connect(v48))
			table.insert(t1, v28.current.DragContinue:Connect(v49))
			table.insert(t1, v28.current.DragEnd:Connect(v50))
		end

		if v26.current then
			table.insert(t1, v26.current.DragStart:Connect(v51))
			table.insert(t1, v26.current.DragContinue:Connect(v52))
			table.insert(t1, v26.current.DragEnd:Connect(v53))
		end

		return function() -- line: 256
			-- upvalues: t1 (copy)
			for _, v68 in t1 do
				v68:Disconnect()
			end
		end
	end, {
		b1,
		v42,
		v43,
		v44,
		v45,
		v46,
		v47,
		v48,
		v49,
		v50,
		v51,
		v52,
		v53
	})

	return {
		dragContainerRef = v23,
		leftHandleRef = v24,
		rightHandleRef = v25,
		scrubberDisplayRef = v27,
		scrubberRef = v28,
		segmentRef = v26,
		leftHandlePosition = v31,
		rightHandlePosition = v35
	}
end

return useTrimDragController
