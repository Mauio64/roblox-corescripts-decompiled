local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local OpenGameDetails = require(Modules.LuaApp.Thunks.OpenGameDetails)
local SetTabBarVisibleFromChat = require(CorePackages.Workspace.Packages.AppTabBarRodux).Thunks.SetTabBarVisibleFromChat

return function(p1, p2) -- line: 9
	-- upvalues: OpenGameDetails (copy), FormFactor (copy), SetTabBarVisibleFromChat (copy)
	return function(p3) -- line: 10
		-- upvalues: OpenGameDetails (copy), p1 (copy), FormFactor (copy), SetTabBarVisibleFromChat (copy), p2 (copy)
		p3:dispatch(OpenGameDetails(p1, {
			onClose = function() -- line: 12
				-- upvalues: p3 (copy), FormFactor (copy), SetTabBarVisibleFromChat (copy)
				if p3:getState().FormFactor == FormFactor.WIDE then
					p3:dispatch(SetTabBarVisibleFromChat(true))
				end
			end,
			referralSource = p2
		}))
	end
end
