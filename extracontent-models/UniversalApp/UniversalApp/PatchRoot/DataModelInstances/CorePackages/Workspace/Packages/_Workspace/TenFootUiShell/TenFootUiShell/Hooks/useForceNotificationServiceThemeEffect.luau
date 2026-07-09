local NotificationService = game:GetService("NotificationService")
local Parent = script:FindFirstAncestor("TenFootUiShell").Parent
local React = require(Parent.React)
local useAppPolicy = require(script.Parent.useAppPolicy)

local function useForceNotificationServiceThemeEffect() -- line: 11
	-- upvalues: useAppPolicy (copy), React (copy), NotificationService (copy)
	local v6 = useAppPolicy(function(p1) -- line: 12
		return p1.getForceTheme()
	end)

	React.useLayoutEffect(function() -- line: 15
		-- upvalues: v6 (copy), NotificationService (copy)
		if v6 then
			NotificationService.SelectedTheme = v6
		end
	end, { v6 })
end

return useForceNotificationServiceThemeEffect
