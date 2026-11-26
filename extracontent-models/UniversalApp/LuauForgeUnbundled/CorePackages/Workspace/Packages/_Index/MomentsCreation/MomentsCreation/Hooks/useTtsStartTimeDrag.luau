local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local clampTtsStartTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/clampTtsStartTime")

local function useTtsStartTimeDrag(p2, p3, current, callback, callback2, callback3)
	local v5 = useRef(nil)
	local v6 = useRef(false)
	local state, setState = useState(false)

	local v7 = useRef(current)
	local v8 = useRef(0)

	useEffect(function()
		v7.current = current
	end, { current })

	local v9 = useCallback(function()
		if v6.current then
			return
		end

		v6.current = true
		v8.current = v7.current
		setState(true)

		if callback2 ~= nil then
			callback2()
		end
	end, { callback2 })

	local v10 = useCallback(function()
		if not v6.current then
			return
		end

		local current2 = v5.current

		if current2 == nil or p3 <= 0 then
			return
		end

		local v11 = current2.DragUDim2.X.Scale * p3
		callback(clampTtsStartTime(v8.current + v11, p3))
	end, { p3, callback })

	local v11 = useCallback(function()
		if not v6.current then
			return
		end

		v6.current = false
		setState(false)

		if callback3 ~= nil then
			callback3(false)
		end
	end, { callback3 })

	useEffect(function()
		if not p2 then
			return
		end

		local current2 = v5.current

		if current2 == nil then
			return
		end

		local v12 = {
			current2.DragStart:Connect(v9),
			current2.DragContinue:Connect(v10),
			current2.DragEnd:Connect(v11)
		}

		return function()
			for k, connection in v12 do
				connection:Disconnect()
			end

			if v6.current then
				v6.current = false
				setState(false)

				if callback3 ~= nil then
					callback3(true)
				end
			end
		end
	end, { p2, v9, v10, v11, callback3 })

	return { dragDetectorRef = v5, isSelected = state }
end

return useTtsStartTimeDrag
