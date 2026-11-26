local clearTryOns = require("@luauforge/bundled/dKU").Actions.ClearTryOns
local module = require("@luauforge/bundled/dPy")

return function()
	return function(object)
		object:dispatch(module(object:getState().AvatarExperience.AvatarScene.OutfitTryOn))

		object:dispatch(clearTryOns())
	end
end
