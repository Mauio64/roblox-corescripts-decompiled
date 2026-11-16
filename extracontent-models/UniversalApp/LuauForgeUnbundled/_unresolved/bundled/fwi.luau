local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dHL")
local module3 = require("@luauforge/bundled/dMx")

local module4 = require("@luauforge/bundled/dwM")
local module5 = require("@luauforge/bundled/dCh")
local module6 = require("@luauforge/bundled/dwB")
local removeFromTryOn = module2.Actions.RemoveFromTryOn
local getTryOnItemReducerKey = AvatarExperienceCommon.Utils.getTryOnItemReducerKey

local v5 = {
	toastMessage = "Feature.Avatar.Label.TryOnFail",
	isLocalized = false,
	toastType = module6.InformationMessage
}

return function(p2)
	module4.isType(p2, "string", "HandleTryOnFailure request expects bundleId")
	return function(object)
		local state = object:getState()

		local tryOnItemReducerKey = getTryOnItemReducerKey(p2, module3.ItemType.Bundle)

		if state.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems[tryOnItemReducerKey] then
			object:dispatch(removeFromTryOn(p2))
			object:dispatch(module5(v5))
		end
	end
end
