local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local module = require("@luauforge/bundled/fHC")
local module2 = require("@luauforge/bundled/fHF")

local function useSyncAppIconWithActiveUser(p2, p3, p4)
	React.useEffect(function()
		if not p4 or p2 <= 0 then
			return nil
		end

		local thread = task.defer(function()
			module2(false).syncActiveUser(p2, p3, function(p5)
				return module.canUseAppIcon(p5, p3)
			end)
		end)
		return function()
			task.cancel(thread)
		end
	end, { p2, p3, p4 })
end

return useSyncAppIconWithActiveUser
