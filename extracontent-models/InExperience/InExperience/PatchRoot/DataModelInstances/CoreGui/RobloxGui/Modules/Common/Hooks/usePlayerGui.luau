local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useLocalPlayer = require(script.Parent.useLocalPlayer)

local function usePlayerGui()
	local v = useLocalPlayer()
	local state, setState = React.useState(nil)

	React.useEffect(function()
		local childAddedConnection

		if v then
			setState(v:FindFirstChildOfClass("PlayerGui"))

			childAddedConnection = v.ChildAdded:Connect(function(playerGui)
				if playerGui:IsA("PlayerGui") then
					setState(playerGui)
				end
			end)
		else
			childAddedConnection = nil
		end

		return function()
			if childAddedConnection then
				childAddedConnection:Disconnect()
			end
		end
	end, { v })

	return state
end

return usePlayerGui
