local module = require("@luauforge/bundled/dHS")
local module2 = require("@luauforge/bundled/dLc")
local module3 = require("@luauforge/bundled/dLz")
local setOutfitTryOns = require("@luauforge/bundled/dLy").Actions.SetOutfitTryOns

local function SetStaticFacialAnimation(p2, p3)
	return function(object)
		local outfitTryOn = object:getState().AvatarExperience.AvatarScene.OutfitTryOn
		local tryOnItems = outfitTryOn.TryOnItems or {}

		if module.isEmpty(tryOnItems) then
			object:dispatch(module2(p2))
			return
		end

		local v5 = module3(tryOnItems, function()
			return { staticFacialAnimation = p2 }
		end)

		object:dispatch(setOutfitTryOns((module.Dictionary.join(outfitTryOn, {
			TryOnItems = v5
		}))))
	end
end

return SetStaticFacialAnimation
