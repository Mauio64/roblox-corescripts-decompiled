local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")

local React = require(ReactSceneUnderstanding.Parent.React)

local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect

local camera = Instance.new("Camera")

local function useCurrentCamera()
	local state, setState = useState(nil)

	local v = useCallback(function()
		local currentCamera = workspace.CurrentCamera

		if currentCamera and currentCamera ~= state then
			setState(currentCamera)
		end
	end, { state })

	useEffect(function()
		local currentCameraChangedConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v)

		return function()
			currentCameraChangedConnection:Disconnect()
		end
	end, { v })

	useEffect(v, {})
	return state or camera
end

return useCurrentCamera
