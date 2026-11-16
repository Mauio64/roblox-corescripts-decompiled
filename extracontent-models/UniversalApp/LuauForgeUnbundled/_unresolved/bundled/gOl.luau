local clearTryOns = require("@luauforge/bundled/dHL").Actions.ClearTryOns
local module = require("@luauforge/bundled/dMi")

return function()
	return function(object)
		object:dispatch(module(object:getState().AvatarExperience.AvatarScene.OutfitTryOn))

		object:dispatch(clearTryOns())
	end
end
