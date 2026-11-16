local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local usePlayerGui = require(script.Parent.usePlayerGui)

local function usePlayerCurrentScreenOrientation()
	local v = usePlayerGui()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local currentScreenOrientationChangedConnection

		if v then
			setState(v.CurrentScreenOrientation)

			currentScreenOrientationChangedConnection = v:GetPropertyChangedSignal("CurrentScreenOrientation"):Connect(function()
				setState(v.CurrentScreenOrientation)
			end)
		else
			currentScreenOrientationChangedConnection = nil
		end

		return function()
			if currentScreenOrientationChangedConnection then
				currentScreenOrientationChangedConnection:Disconnect()
			end
		end
	end, { v })

	return state
end

return usePlayerCurrentScreenOrientation
