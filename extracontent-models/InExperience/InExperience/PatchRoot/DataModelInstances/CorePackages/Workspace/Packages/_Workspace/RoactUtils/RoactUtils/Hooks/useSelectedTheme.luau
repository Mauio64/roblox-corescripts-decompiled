local NotificationService = game:GetService("NotificationService")
local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

local function useSelectedTheme() -- line: 13
	-- upvalues: React (copy), NotificationService (copy)
	local v5, v6 = React.useState(string.lower(NotificationService.SelectedTheme))

	React.useEffect(function() -- line: 16
		-- upvalues: NotificationService (copy), v6 (copy)
		local connection = NotificationService:GetPropertyChangedSignal("SelectedTheme"):Connect(function() -- line: 17
			-- upvalues: v6 (copy), NotificationService (copy)
			v6(string.lower(NotificationService.SelectedTheme))
		end)

		return function() -- line: 21
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end)

	return v5
end

return useSelectedTheme
