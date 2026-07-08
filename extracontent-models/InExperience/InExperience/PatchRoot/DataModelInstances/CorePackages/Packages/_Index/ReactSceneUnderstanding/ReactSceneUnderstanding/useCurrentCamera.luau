local ReactSceneUnderstanding = script:FindFirstAncestor("ReactSceneUnderstanding")
local React = require(ReactSceneUnderstanding.Parent.React)
local useState = React.useState
local useCallback = React.useCallback
local useEffect = React.useEffect
local Camera = Instance.new("Camera")

local function useCurrentCamera() -- line: 11
	-- upvalues: useState (copy), useCallback (copy), useEffect (copy), Camera (copy)
	local v8, v9 = useState(nil)
	local v10 = useCallback(function() -- line: 14
		-- upvalues: v8 (copy), v9 (copy)
		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera and CurrentCamera ~= v8 then
			v9(CurrentCamera)
		end
	end, { v8 })

	useEffect(function() -- line: 21
		-- upvalues: v10 (copy)
		local connection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(v10)

		return function() -- line: 24
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v10 })
	useEffect(v10, {})

	if v8 then
		return v8
	end

	return Camera
end

return useCurrentCamera
