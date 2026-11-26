local NotificationService = game:GetService("NotificationService")

local module = require("@luauforge/bundled/ick")
local module2 = require("@luauforge/bundled/ics")

local function useForceNotificationServiceThemeEffect()
	local v5 = module2(function(p2)
		return p2.getForceTheme()
	end)

	module.useLayoutEffect(function()
		if v5 then
			NotificationService.SelectedTheme = v5
		end
	end, { v5 })
end

return useForceNotificationServiceThemeEffect
