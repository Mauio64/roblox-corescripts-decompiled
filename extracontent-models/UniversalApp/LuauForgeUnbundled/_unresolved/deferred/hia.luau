local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local fFlagAXUseSignalsForLayeredClothingEntryPage = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForLayeredClothingEntryPage
local getLayeredClothingEntryPageStore

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	getLayeredClothingEntryPageStore = require("@luauforge/bundled/dPt").Stores.getLayeredClothingEntryPageStore
else
	getLayeredClothingEntryPageStore = nil
end

local module = require("@luauforge/bundled/dPU")
local module2 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dKT")
local module3 = require("@luauforge/bundled/dSW")

return function(callback)
	return function(object)
		local v5

		if fFlagAXUseSignalsForLayeredClothingEntryPage then
			v5 = getLayeredClothingEntryPageStore(false).getEntryPage(false)
		else
			v5 = object:getState().AvatarExperience.LayeredClothingSort.EntryPage
		end

		local v6, v7

		if v5 == avatarScreen.AvatarEditor then
			v6 = object:getState().AvatarExperience.AvatarEditor.Categories.category
			v7 = "avatarEditor"
		else
			if v5 ~= avatarScreen.Catalog and v5 ~= avatarScreen.CatalogSearch then
				return
			end

			v6 = module3.getCatalogSelectionStore().selectedCategoryId(false)

			v7 = module.AnalyticsContext.AvatarShop
		end

		callback(
			v7,
			module2.getUserId(object:getState()),
			v6,
			object:getState().AvatarExperience.AccessoryAdjustment.SelectedAccessory
		)
	end
end
