local module = require("@luauforge/bundled/edO")

local module2 = require("@luauforge/bundled/edP")

return function()
	return function(object)
		if object:getState().CentralOverlay.OverlayType == module.ReminderOfNormsPopup then
			object:dispatch(module2())
		end
	end
end
