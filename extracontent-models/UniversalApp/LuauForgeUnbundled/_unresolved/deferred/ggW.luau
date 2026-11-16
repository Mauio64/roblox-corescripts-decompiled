local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dNY")
local module2 = require("@luauforge/bundled/dPa")
local module3 = require("@luauforge/bundled/dMx")
local module4 = require("@luauforge/bundled/dNQ")
local module5 = require("@luauforge/bundled/fvh")

local module6 = require("@luauforge/bundled/ggX")

return function()
	return function(object)
		local state = object:getState()

		if state.AvatarExperience.AvatarEditor.PageFinished[module4.CharacterKey] then
			local outfitInfos = state.AvatarExperience.AvatarEditor.OutfitInfos
			local ownedItemId = state.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[module4.CharacterKey]

			local flag = true

			local filtered = Cryo.List.filter(ownedItemId, function(p2): boolean
				local outfitInfo = outfitInfos[tostring(p2)]

				if outfitInfo then
					return not module5.isPresetOutfit(outfitInfo)
				end

				flag = false

				return false
			end)

			if flag then
				object:dispatch(module(module4.EditableCharacterKey, filtered))

				object:dispatch(module2(module4.EditableCharacterKey, true))

				return Promise.resolve()
			end
		end

		return object:dispatch(module6(module4.EditableCharacterKey, true, nil, module3.OutfitTypes.Avatar))
	end
end
