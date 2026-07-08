local Parent = script:FindFirstAncestor("Moments").Parent
local UserInputService = game:GetService("UserInputService")
local React = require(Parent.React)

return function() -- line: 18
	-- upvalues: React (copy), UserInputService (copy)
	local v4, v5 = React.useState(UserInputService.PreferredInput)

	React.useEffect(function() -- line: 21
		-- upvalues: UserInputService (copy), v5 (copy)
		local connection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- line: 24
			-- upvalues: v5 (copy), UserInputService (copy)
			v5(UserInputService.PreferredInput)
		end)

		return function() -- line: 28
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	return v4
end
