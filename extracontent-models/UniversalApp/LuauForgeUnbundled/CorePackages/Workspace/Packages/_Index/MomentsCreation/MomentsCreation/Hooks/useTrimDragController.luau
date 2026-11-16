local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef

local validateRefs = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/validateRefs")
local DragHandle = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DragHandle")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function initialFraction(p2, p3, p4)
	if p2 == nil or not (p3 > 0) then
		return p4
	end

	return p2 / p3
end

local function useTrimDragController(p2, callback, callback2, callback3, callback4, p3, p4, callback5)
	local v5 = useRef(nil)
	local v6 = useRef(nil)
	local v7 = useRef(nil)
	local v8 = useRef(nil)
	local v9 = useRef(nil)
	local v10 = useRef(nil)

	local startTime = if p3 then p3.startTime else nil
	local v12, v13 = useBinding((startTime == nil or not (p4 > 0)) and 0 or startTime / p4)

	local endTime = if p3 then p3.endTime else nil
	local v15, v16 = useBinding((endTime == nil or not (p4 > 0)) and 1 or endTime / p4)

	local v17 = useRef(nil)
	local v18 = useRef(nil)
	local v19 = useRef(nil)

	local v20 = useRef(nil)

	local v21 = not (p4 > 0) and 0 or 1 / p4

	local v22 = useCallback(function()
		if not validateRefs({ v6 }) or v20.current then
			return
		end

		v20.current = DragHandle.LeftHandle
		v17.current = v12:getValue()
		callback2(DragHandle.LeftHandle)
	end, { callback2 })

	local v23 = useCallback(function()
		if not validateRefs({ v17, v6 }) then
			return
		end

		local current = v6.current

		local v24 = math.clamp(v17.current + current.DragUDim2.X.Scale, 0, v15:getValue() - v21)
		v13(v24)

		if callback5 then
			callback5(DragHandle.LeftHandle, v24, v15:getValue())
		end
	end, { v21, callback5 })

	local v24 = useCallback(function()
		if v20.current ~= DragHandle.LeftHandle then
			return
		end

		callback3(v12:getValue() * p4, nil)
		v20.current = nil
		v17.current = nil
		callback()
	end, { callback, callback3, p4 })

	local v25 = useCallback(function()
		if not validateRefs({ v7 }) or v20.current then
			return
		end

		v20.current = DragHandle.RightHandle
		v18.current = v15:getValue()
		callback2(DragHandle.RightHandle)
	end, { callback2 })

	local v26 = useCallback(function()
		if not validateRefs({ v18, v7 }) then
			return
		end

		local current = v7.current
		local v27 = math.clamp(v18.current + current.DragUDim2.X.Scale, v12:getValue() + v21, 1)
		v16(v27)

		if callback5 then
			callback5(DragHandle.RightHandle, v12:getValue(), v27)
		end
	end, { v21, callback5 })

	local v27 = useCallback(function()
		if v20.current ~= DragHandle.RightHandle then
			return
		end

		callback3(nil, v15:getValue() * p4)
		v20.current = nil
		v18.current = nil
		callback()
	end, { callback, callback3, p4 })

	local v28 = useCallback(function()
		if not validateRefs({ v10, v9 }) or v20.current then
			return
		end

		v20.current = DragHandle.Scrubber
		v19.current = v9.current.Position.X.Scale
		callback2(DragHandle.Scrubber)
	end, { callback2 })

	local v29 = useCallback(function()
		if not validateRefs({ v19, v10 }) then
			return
		end

		local current = v10.current
		callback4((math.clamp(v19.current + current.DragUDim2.X.Scale, 0, 1)))
	end, { callback4 })

	local v30 = useCallback(function()
		if v20.current ~= DragHandle.Scrubber then
			return
		end

		v20.current = nil
		v19.current = nil
		callback()
	end, { callback })

	local v31 = useCallback(function()
		if not validateRefs({ v8 }) or v20.current then
			return
		end

		v20.current = DragHandle.Segment
		v17.current = v12:getValue()
		v18.current = v15:getValue()
		callback2(DragHandle.Segment)
	end, { callback2 })

	local v32 = useCallback(function()
		if not validateRefs({ v8, v17, v6, v18, v7 }) then
			return
		end

		local scale = v8.current.DragUDim2.X.Scale
		local current = v17.current
		local current2 = v18.current

		if current <= 0 and current2 >= 1 then
			return
		end

		local v33 = math.clamp(scale, -current, 1 - current2)
		local v34 = current + v33
		local v35 = current2 + v33

		v13(v34)
		v16(v35)

		callback3(v34 * p4, v35 * p4)
	end, { callback3, p4 })

	local v33 = useCallback(function()
		if v20.current ~= DragHandle.Segment then
			return
		end

		v20.current = nil
		v17.current = nil
		v18.current = nil
		callback()
	end, { callback })

	useEffect(function()
		if not p2 then
			return
		end

		local connections = {}

		if v6.current then
			table.insert(connections, v6.current.DragStart:Connect(v22))
			table.insert(connections, v6.current.DragContinue:Connect(v23))
			table.insert(connections, v6.current.DragEnd:Connect(v24))
		end

		if v7.current then
			table.insert(connections, v7.current.DragStart:Connect(v25))
			table.insert(connections, v7.current.DragContinue:Connect(v26))
			table.insert(connections, v7.current.DragEnd:Connect(v27))
		end

		if v10.current then
			table.insert(connections, v10.current.DragStart:Connect(v28))
			table.insert(connections, v10.current.DragContinue:Connect(v29))
			table.insert(connections, v10.current.DragEnd:Connect(v30))
		end

		if v8.current then
			table.insert(connections, v8.current.DragStart:Connect(v31))
			table.insert(connections, v8.current.DragContinue:Connect(v32))
			table.insert(connections, v8.current.DragEnd:Connect(v33))
		end

		return function()
			for k, connection in connections do
				connection:Disconnect()
			end
		end
	end, {
		p2,
		v22,
		v23,
		v24,
		v25,
		v26,
		v27,
		v28,
		v29,
		v30,
		v31,
		v32,
		v33
	})

	return {
		dragContainerRef = v5,
		leftHandleRef = v6,
		rightHandleRef = v7,
		scrubberDisplayRef = v9,
		scrubberRef = v10,
		segmentRef = v8,
		leftHandlePosition = v12,
		rightHandlePosition = v15
	}
end

return useTrimDragController
