local module = require("@luauforge/bundled/ehl")

local module2 = require("@luauforge/bundled/ehm")

return function()
	return function(object)
		if object:getState().CentralOverlay.OverlayType == module.ReminderOfNormsPopup then
			object:dispatch(module2())
		end
	end
end
