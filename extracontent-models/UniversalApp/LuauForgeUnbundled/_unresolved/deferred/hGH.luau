local formFactor = require("@luauforge/bundled/dGN").Enums.FormFactor
local module = require("@luauforge/bundled/dKt")
local setTabBarVisibleFromChat = require("@luauforge/bundled/dzQ").Thunks.SetTabBarVisibleFromChat

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
