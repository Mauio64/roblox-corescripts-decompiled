local UserInputService = game:GetService("UserInputService")

local parent = script.Parent.Parent
local React = require(parent.React)

local getInputMethod = require(script.Parent.getInputMethod)

local function useLastInputMethod()
	local v = getInputMethod(UserInputService:GetLastInputType()) or "None"
	local state, setState = React.useState(v)
	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
			local inputMethod = getInputMethod(p)

			if inputMethod then
				setState(inputMethod)
			end
		end)

		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

return useLastInputMethod
