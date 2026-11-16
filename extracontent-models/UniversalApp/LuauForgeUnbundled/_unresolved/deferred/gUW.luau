local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local clearTryOns = require("@luauforge/bundled/dHL").Actions.ClearTryOns
local module = require("@luauforge/bundled/dTb")
local module2 = require("@luauforge/bundled/dwM")
local module3 = require("@luauforge/bundled/fvd")

return function(p2, p3)
	module2.isTypeOrNil(p2, "string", "SetEmoteAssetId thunk expects emoteAssetId to be a string or nil")
	return function(object)
		local tryOnItems = object:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

		if not Cryo.isEmpty(tryOnItems) then
			object:dispatch(clearTryOns())
			object:dispatch(module3(p3))
		end

		object:dispatch(module(p2))
	end
end
