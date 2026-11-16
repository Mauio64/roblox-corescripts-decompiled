local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module = require("@luauforge/bundled/dHo")
local setTabBarVisibleFromChat = require("@luauforge/bundled/dwN").Thunks.SetTabBarVisibleFromChat

return function(p2, p3)
	return function(object)
		object:dispatch(module(p2, {
			onClose = function()
				if object:getState().FormFactor == formFactor.WIDE then
					object:dispatch(setTabBarVisibleFromChat(true))
				end
			end,
			referralSource = p3
		}))
	end
end
