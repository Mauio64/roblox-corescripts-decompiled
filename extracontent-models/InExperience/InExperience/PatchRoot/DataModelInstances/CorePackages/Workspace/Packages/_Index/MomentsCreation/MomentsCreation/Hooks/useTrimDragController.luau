local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local validateRefs = require(MomentsCreation.Utils.validateRefs)
local DragHandle = require(MomentsCreation.Enums.DragHandle)

require(parent.MomentsTypes)

local function initialFraction(p: number?, p2: number, p3: number) -- 2 equivalent calls inferred from this helper
	if p == nil or not (p2 > 0) then
		return p3
	end

	return p / p2
end

local function useTrimDragController(flag: boolean, callback, callback2, callback3, callback4, p, p2: number, callback5)
	local dragContainerRef = useRef(nil)
	local leftHandleRef = useRef(nil)
	local rightHandleRef = useRef(nil)
	local segmentRef = useRef(nil)
	local scrubberDisplayRef = useRef(nil)
	local scrubberRef = useRef(nil)
	local v

	if p then
		v = p.startTime
	end

	local leftHandlePosition, v2 = useBinding(initialFraction(v, p2, 0)) -- inferred equivalent call
	local v3

	if p then
		v3 = p.endTime
	end

	local rightHandlePosition, v4 = useBinding(initialFraction(v3, p2, 1)) -- inferred equivalent call

	local v5 = useRef(nil)
	local v6 = useRef(nil)
	local v7 = useRef(nil)

	local v8 = useRef(nil)

	local v9 = not (p2 > 0) and 0 or 1 / p2

	local v10 = useCallback(function()
		if not validateRefs({ leftHandleRef }) or v8.current then
			return
		end

		v8.current = DragHandle.LeftHandle
		v5.current = leftHandlePosition:getValue()
		callback2(DragHandle.LeftHandle)
	end, { callback2 })

	local v11 = useCallback(function()
		if not validateRefs({ v5, leftHandleRef }) then
			return
		end

		local current = leftHandleRef.current

		local v11 = math.clamp(v5.current + current.DragUDim2.X.Scale, 0, rightHandlePosition:getValue() - v9)
		v2(v11)

		if callback5 then
			callback5(DragHandle.LeftHandle, v11, rightHandlePosition:getValue())
		end
	end, { v9, callback5 })

	local v12 = useCallback(function()
		if v8.current ~= DragHandle.LeftHandle then
			return
		end

		callback3(leftHandlePosition:getValue() * p2, nil)
		v8.current = nil
		v5.current = nil
		callback()
	end, { callback, callback3, p2 })

	local v13 = useCallback(function()
		if not validateRefs({ rightHandleRef }) or v8.current then
			return
		end

		v8.current = DragHandle.RightHandle
		v6.current = rightHandlePosition:getValue()
		callback2(DragHandle.RightHandle)
	end, { callback2 })

	local v14 = useCallback(function()
		if not validateRefs({ v6, rightHandleRef }) then
			return
		end

		local current = rightHandleRef.current
		local v14 = math.clamp(v6.current + current.DragUDim2.X.Scale, leftHandlePosition:getValue() + v9, 1)
		v4(v14)

		if callback5 then
			callback5(DragHandle.RightHandle, leftHandlePosition:getValue(), v14)
		end
	end, { v9, callback5 })

	local v15 = useCallback(function()
		if v8.current ~= DragHandle.RightHandle then
			return
		end

		callback3(nil, rightHandlePosition:getValue() * p2)
		v8.current = nil
		v6.current = nil
		callback()
	end, { callback, callback3, p2 })

	local v16 = useCallback(function()
		if not validateRefs({ scrubberRef, scrubberDisplayRef }) or v8.current then
			return
		end

		v8.current = DragHandle.Scrubber
		v7.current = scrubberDisplayRef.current.Position.X.Scale
		callback2(DragHandle.Scrubber)
	end, { callback2 })

	local v17 = useCallback(function()
		if not validateRefs({ v7, scrubberRef }) then
			return
		end

		local current = scrubberRef.current
		callback4((math.clamp(v7.current + current.DragUDim2.X.Scale, 0, 1)))
	end, { callback4 })

	local v18 = useCallback(function()
		if v8.current ~= DragHandle.Scrubber then
			return
		end

		v8.current = nil
		v7.current = nil
		callback()
	end, { callback })

	local v19 = useCallback(function()
		if not validateRefs({ segmentRef }) or v8.current then
			return
		end

		v8.current = DragHandle.Segment
		v5.current = leftHandlePosition:getValue()
		v6.current = rightHandlePosition:getValue()
		callback2(DragHandle.Segment)
	end, { callback2 })

	local v20 = useCallback(function()
		if not validateRefs({ segmentRef, v5, leftHandleRef, v6, rightHandleRef }) then
			return
		end

		local scale = segmentRef.current.DragUDim2.X.Scale
		local current = v5.current
		local current2 = v6.current

		if current <= 0 and current2 >= 1 then
			return
		end

		local v20 = math.clamp(scale, -current, 1 - current2)
		local v21 = current + v20
		local v22 = current2 + v20

		v2(v21)
		v4(v22)

		callback3(v21 * p2, v22 * p2)
	end, { callback3, p2 })

	local v21 = useCallback(function()
		if v8.current ~= DragHandle.Segment then
			return
		end

		v8.current = nil
		v5.current = nil
		v6.current = nil
		callback()
	end, { callback })

	useEffect(function()
		if not flag then
			return
		end

		local connections = {}

		if leftHandleRef.current then
			table.insert(connections, leftHandleRef.current.DragStart:Connect(v10))
			table.insert(connections, leftHandleRef.current.DragContinue:Connect(v11))
			table.insert(connections, leftHandleRef.current.DragEnd:Connect(v12))
		end

		if rightHandleRef.current then
			table.insert(connections, rightHandleRef.current.DragStart:Connect(v13))
			table.insert(connections, rightHandleRef.current.DragContinue:Connect(v14))
			table.insert(connections, rightHandleRef.current.DragEnd:Connect(v15))
		end

		if scrubberRef.current then
			table.insert(connections, scrubberRef.current.DragStart:Connect(v16))
			table.insert(connections, scrubberRef.current.DragContinue:Connect(v17))
			table.insert(connections, scrubberRef.current.DragEnd:Connect(v18))
		end

		if segmentRef.current then
			table.insert(connections, segmentRef.current.DragStart:Connect(v19))
			table.insert(connections, segmentRef.current.DragContinue:Connect(v20))
			table.insert(connections, segmentRef.current.DragEnd:Connect(v21))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		flag,
		v10,
		v11,
		v12,
		v13,
		v14,
		v15,
		v16,
		v17,
		v18,
		v19,
		v20,
		v21
	})

	return {
		dragContainerRef = dragContainerRef,
		leftHandleRef = leftHandleRef,
		rightHandleRef = rightHandleRef,
		scrubberDisplayRef = scrubberDisplayRef,
		scrubberRef = scrubberRef,
		segmentRef = segmentRef,
		leftHandlePosition = leftHandlePosition,
		rightHandlePosition = rightHandlePosition
	}
end

return useTrimDragController
