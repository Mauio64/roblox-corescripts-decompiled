local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/React")

local getInputMethod = require("@game/CorePackages/Workspace/Packages/_Workspace/FocusNavigationUtils/FocusNavigationUtils/getInputMethod")

local function useLastInputMethod()
	local v5 = getInputMethod(UserInputService:GetLastInputType()) or "None"
	local state, setState = React.useState(v5)
	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p2)
			local v6 = getInputMethod(p2)

			if v6 then
				setState(v6)
			end
		end)

		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useLastInputMethod
