local module = require("@luauforge/bundled/dLb")

local setOutfitTryOns = require("@luauforge/bundled/dOO").Actions.SetOutfitTryOns
local module2 = require("@luauforge/bundled/dOr")
local module3 = require("@luauforge/bundled/dOP")

return function(p2, p3)
	return function(object)
		local outfitTryOn = object:getState().AvatarExperience.AvatarScene.OutfitTryOn
		local tryOnItems = outfitTryOn.TryOnItems or {}

		if module.isEmpty(tryOnItems) then
			object:dispatch(module2(p2))
			return
		end

		local v5 = module3(tryOnItems, function()
			return { headShape = p2 }
		end)

		object:dispatch(setOutfitTryOns((module.Dictionary.join(outfitTryOn, {
			TryOnItems = v5
		}))))
	end
end
