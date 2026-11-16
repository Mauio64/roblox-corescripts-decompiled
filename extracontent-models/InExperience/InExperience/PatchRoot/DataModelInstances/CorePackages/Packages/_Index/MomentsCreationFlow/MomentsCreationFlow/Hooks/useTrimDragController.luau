local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local validateRefs = require(MomentsCreationFlow.Utils.validateRefs)

local DragHandle = require(MomentsCreationFlow.Enums.DragHandle)

local function useTrimDragController(flag: boolean, callback, callback2, callback3, callback4, p, p2: number)
	local dragContainerRef = useRef(nil)
	local leftHandleRef = useRef(nil)
	local rightHandleRef = useRef(nil)
	local segmentRef = useRef(nil)
	local scrubberDisplayRef = useRef(nil)
	local scrubberRef = useRef(nil)

	local leftHandlePosition, v = useAnimatedBinding(p and p.startTime / p2 or 0)

	local rightHandlePosition, v2 = useAnimatedBinding(p and p.endTime / p2 or 1)

	local v3 = useRef(nil)
	local v4 = useRef(nil)
	local v5 = useRef(nil)

	local v6 = useRef(nil)

	local v7 = useCallback(function()
		if not validateRefs({ leftHandleRef }) or v6.current then
			return
		end

		assert(leftHandleRef.current ~= nil, "Left handle ref is nil")

		v6.current = DragHandle.LeftHandle
		v3.current = leftHandlePosition:getValue()
		callback2(DragHandle.LeftHandle)
	end, { callback2 })

	local v8 = useCallback(function()
		if not validateRefs({ v3, leftHandleRef }) then
			return
		end

		assert(v3.current ~= nil, "Left handle initial position ref is nil")
		assert(leftHandleRef.current ~= nil, "Left handle ref is nil")

		local current = leftHandleRef.current
		local v8 = math.clamp(
			v3.current + current.DragUDim2.X.Scale,
			0,
			rightHandlePosition:getValue() - MomentsCommon.Constants.MinimumVideoLength / p2
		)

		v(ReactOtter.instant(v8))
	end, { p2 })

	local v9 = useCallback(function()
		if v6.current ~= DragHandle.LeftHandle then
			return
		end

		callback3(leftHandlePosition:getValue() * p2, nil)
		v6.current = nil
		v3.current = nil
		callback()
	end, { callback, callback3, p2 })

	local v10 = useCallback(function()
		if not validateRefs({ rightHandleRef }) or v6.current then
			return
		end

		assert(rightHandleRef.current ~= nil, "Right handle ref is nil")

		v6.current = DragHandle.RightHandle
		v4.current = rightHandlePosition:getValue()
		callback2(DragHandle.RightHandle)
	end, { callback2 })

	local v11 = useCallback(function()
		if not validateRefs({ v4, rightHandleRef }) then
			return
		end

		assert(rightHandleRef.current ~= nil, "Right handle ref is nil")

		local current = rightHandleRef.current
		local v11 = math.clamp(
			v4.current + current.DragUDim2.X.Scale,
			leftHandlePosition:getValue() + MomentsCommon.Constants.MinimumVideoLength / p2,
			1
		)

		v2(ReactOtter.instant(v11))
	end, { p2 })

	local v12 = useCallback(function()
		if v6.current ~= DragHandle.RightHandle then
			return
		end

		callback3(nil, rightHandlePosition:getValue() * p2)
		v6.current = nil
		v4.current = nil
		callback()
	end, { callback, callback3, p2 })

	local v13 = useCallback(function()
		if not validateRefs({ scrubberRef, scrubberDisplayRef }) or v6.current then
			return
		end

		assert(scrubberRef.current ~= nil, "Scrubber ref is nil")
		assert(scrubberDisplayRef.current ~= nil, "Scrubber display ref is nil")

		v6.current = DragHandle.Scrubber
		v5.current = scrubberDisplayRef.current.Position.X.Scale
		callback2(DragHandle.Scrubber)
	end, { callback2 })

	local v14 = useCallback(function()
		if not validateRefs({ v5, scrubberRef }) then
			return
		end

		assert(v5.current ~= nil, "Scrubber initial position ref is nil")
		assert(scrubberRef.current ~= nil, "Scrubber ref is nil")

		local current = scrubberRef.current
		callback4((math.clamp(v5.current + current.DragUDim2.X.Scale, 0, 1)))
	end, { callback4 })

	local v15 = useCallback(function()
		if v6.current ~= DragHandle.Scrubber then
			return
		end

		v6.current = nil
		v5.current = nil
		callback()
	end, { callback })

	local v16 = useCallback(function()
		if not validateRefs({ segmentRef }) or v6.current then
			return
		end

		assert(segmentRef.current ~= nil, "Selected outline ref is nil")

		v6.current = DragHandle.Segment
		v3.current = leftHandlePosition:getValue()
		v4.current = rightHandlePosition:getValue()
		callback2(DragHandle.Segment)
	end, { callback2 })

	local v17 = useCallback(function()
		if not validateRefs({ segmentRef, v3, leftHandleRef, v4, rightHandleRef }) then
			return
		end

		assert(segmentRef.current ~= nil, "Selected outline ref is nil")
		assert(v3.current ~= nil, "Left handle initial position ref is nil")
		assert(leftHandleRef.current ~= nil, "Left handle ref is nil")
		assert(v4.current ~= nil, "Right handle initial position ref is nil")
		assert(rightHandleRef.current ~= nil, "Right handle ref is nil")

		local scale = segmentRef.current.DragUDim2.X.Scale

		local current = v3.current
		local current2 = v4.current

		if current <= 0 and current2 >= 1 then
			return
		end

		local v17 = math.clamp(scale, -current, 1 - current2)
		local v18 = current + v17
		local v19 = current2 + v17

		v(ReactOtter.instant(v18))
		v2(ReactOtter.instant(v19))

		callback3(v18 * p2, v19 * p2)
	end, { callback3, p2 })

	local v18 = useCallback(function()
		if v6.current ~= DragHandle.Segment then
			return
		end

		v6.current = nil
		v3.current = nil
		v4.current = nil
		callback()
	end, { callback })

	useEffect(function()
		if not flag then
			return
		end

		local connections = {}

		if leftHandleRef.current then
			table.insert(connections, leftHandleRef.current.DragStart:Connect(v7))
			table.insert(connections, leftHandleRef.current.DragContinue:Connect(v8))
			table.insert(connections, leftHandleRef.current.DragEnd:Connect(v9))
		end

		if rightHandleRef.current then
			table.insert(connections, rightHandleRef.current.DragStart:Connect(v10))
			table.insert(connections, rightHandleRef.current.DragContinue:Connect(v11))
			table.insert(connections, rightHandleRef.current.DragEnd:Connect(v12))
		end

		if scrubberRef.current then
			table.insert(connections, scrubberRef.current.DragStart:Connect(v13))
			table.insert(connections, scrubberRef.current.DragContinue:Connect(v14))
			table.insert(connections, scrubberRef.current.DragEnd:Connect(v15))
		end

		if segmentRef.current then
			table.insert(connections, segmentRef.current.DragStart:Connect(v16))
			table.insert(connections, segmentRef.current.DragContinue:Connect(v17))
			table.insert(connections, segmentRef.current.DragEnd:Connect(v18))
		end

		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		flag,
		v7,
		v8,
		v9,
		v10,
		v11,
		v12,
		v13,
		v14,
		v15,
		v16,
		v17,
		v18
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
