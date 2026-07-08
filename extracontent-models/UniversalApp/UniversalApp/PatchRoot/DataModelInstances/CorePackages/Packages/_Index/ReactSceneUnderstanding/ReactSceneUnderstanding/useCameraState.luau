local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local UserInputService = game:GetService("UserInputService")
local ReactUtils = require(ReactSceneUnderstanding.Parent.ReactUtils)
local React = require(ReactSceneUnderstanding.Parent.React)
local enums = require(ReactSceneUnderstanding.enums)
local useCurrentCamera = require(ReactSceneUnderstanding.useCurrentCamera)
local useCallback = React.useCallback
local useEffect = React.useEffect
local useRef = React.useRef
local useState = React.useState
local useEventConnection = ReactUtils.useEventConnection

local function useCameraState(p1) -- line: 20
	-- upvalues: useCurrentCamera (copy), useState (copy), enums (copy), useRef (copy), useCallback (copy), useEventConnection (copy), UserInputService (copy), useEffect (copy)
	local v14 = useCurrentCamera()
	local v15, v16 = useState(enums.CameraState.Idle)
	local v17 = useRef(nil)
	local v18 = p1 or v14
	local v19 = useCallback(function() -- line: 27
		-- upvalues: v16 (copy), enums (copy), v17 (copy)
		v16(function(p2) -- line: 28
			-- upvalues: enums (copy)
			if p2 ~= enums.CameraState.Moving then
				return enums.CameraState.Moving
			end

			return p2
		end)

		if v17.current then
			task.cancel(v17.current)
		end

		v17.current = task.delay(0.2, function() -- line: 36
			-- upvalues: v16 (copy), enums (copy)
			v16(enums.CameraState.Idle)
		end)
	end, {})

	useEventConnection(UserInputService.InputChanged, function(p3) -- line: 41
		-- upvalues: v19 (copy)
		if p3.UserInputType == Enum.UserInputType.MouseWheel then
			v19()
		end
	end, { v19 })
	useEffect(function() -- line: 47
		-- upvalues: v18 (copy), v19 (copy)
		local connection = v18:GetPropertyChangedSignal("CFrame"):Connect(v19)

		return function() -- line: 50
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {
		v18,
		v19
	})

	return v15
end

return useCameraState
