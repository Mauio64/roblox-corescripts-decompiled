local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)

local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState

local clampTtsStartTime = require(MomentsCreation.Utils.clampTtsStartTime)

local function useTtsStartTimeDrag(flag: boolean, p: number, current: number, callback, callback2, callback3)
	local dragDetectorRef = useRef(nil)
	local v = useRef(false)
	local state, setState = useState(false)

	local v2 = useRef(current)
	local v3 = useRef(0)

	useEffect(function()
		v2.current = current
	end, { current })

	local v4 = useCallback(function()
		if v.current then
			return
		end

		v.current = true
		v3.current = v2.current
		setState(true)

		if callback2 ~= nil then
			callback2()
		end
	end, { callback2 })

	local v5 = useCallback(function()
		if not v.current then
			return
		end

		local current2 = dragDetectorRef.current

		if current2 == nil or p <= 0 then
			return
		end

		local v5 = current2.DragUDim2.X.Scale * p
		callback(clampTtsStartTime(v3.current + v5, p))
	end, { p, callback })

	local v6 = useCallback(function()
		if not v.current then
			return
		end

		v.current = false
		setState(false)

		if callback3 ~= nil then
			callback3(false)
		end
	end, { callback3 })

	useEffect(function()
		if not flag then
			return
		end

		local current2 = dragDetectorRef.current

		if current2 == nil then
			return
		end

		local v7 = { current2.DragStart:Connect(v4), current2.DragContinue:Connect(v5), current2.DragEnd:Connect(v6) }

		return function()
			for _, connection in v7 do
				connection:Disconnect()
			end

			if v.current then
				v.current = false
				setState(false)

				if callback3 ~= nil then
					callback3(true)
				end
			end
		end
	end, { flag, v4, v5, v6, callback3 })

	return { dragDetectorRef = dragDetectorRef, isSelected = state }
end

return useTtsStartTimeDrag
