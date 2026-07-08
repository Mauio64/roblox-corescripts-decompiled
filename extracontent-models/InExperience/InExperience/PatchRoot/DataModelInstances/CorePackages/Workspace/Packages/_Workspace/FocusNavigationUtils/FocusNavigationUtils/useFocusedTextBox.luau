local UserInputService = game:GetService("UserInputService")
local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local React = require(Parent.React)

return function(p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 9
	-- upvalues: React (copy), UserInputService (copy)
	local v6, v7 = React.useState(nil)

	React.useEffect(function() -- line: 11
		-- upvalues: UserInputService (copy), v7 (copy), p1 (copy), p2 (copy)
		local connection = UserInputService.TextBoxFocused:Connect(function(p3) -- line: 12
			-- upvalues: v7 (copy), p1 (copy)
			v7(p3)

			if p1 then
				p1(p3)
			end
		end)
		local connection2 = UserInputService.TextBoxFocusReleased:Connect(function(p4) -- line: 20
			-- upvalues: v7 (copy), p2 (copy)
			v7(nil)

			if p2 then
				p2(p4)
			end
		end)

		return function() -- line: 28
			-- upvalues: connection (copy), connection2 (copy)
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, { v7 })

	return v6
end
