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

local function useCameraState(p)
	local v = useCurrentCamera()
	local state, setState = useState(enums.CameraState.Idle)
	local v2 = useRef(nil)

	local v3 = p or v

	local v4 = useCallback(function()
		setState(function(p2)
			if p2 == enums.CameraState.Moving then
				return p2
			end

			return enums.CameraState.Moving
		end)

		if v2.current then
			task.cancel(v2.current)
		end

		v2.current = task.delay(0.2, function()
			setState(enums.CameraState.Idle)
		end)
	end, {})

	useEventConnection(UserInputService.InputChanged, function(p2)
		if p2.UserInputType == Enum.UserInputType.MouseWheel then
			v4()
		end
	end, { v4 })

	useEffect(function()
		local cFrameChangedConnection = v3:GetPropertyChangedSignal("CFrame"):Connect(v4)

		return function()
			cFrameChangedConnection:Disconnect()
		end
	end, { v3, v4 })

	return state
end

return useCameraState
