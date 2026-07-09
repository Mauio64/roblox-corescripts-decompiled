local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AddSelectedBundleInfo = require(Modules.AvatarExperience.Common.Actions.AddSelectedBundleInfo)
local SelectOrderedToggledOnItemsList = require(Modules.AvatarExperience.Common.Selectors.SelectOrderedToggledOnItemsList)
local SelectUpdatedSortOrderForToggledOnItems = require(Modules.AvatarExperience.Common.Selectors.SelectUpdatedSortOrderForToggledOnItems)
local SetOrderForTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.SetOrderForTryOns
local SetOrder = require(Modules.AvatarExperience.LayeredClothingSort.Actions.SetOrder)

return function(p1) -- line: 23
	-- upvalues: SelectOrderedToggledOnItemsList (copy), SelectUpdatedSortOrderForToggledOnItems (copy), Constants (copy), SetOrder (copy), SetOrderForTryOns (copy), AddSelectedBundleInfo (copy)
	return function(p2) -- line: 24
		-- upvalues: SelectOrderedToggledOnItemsList (copy), SelectUpdatedSortOrderForToggledOnItems (copy), p1 (copy), Constants (copy), SetOrder (copy), SetOrderForTryOns (copy), AddSelectedBundleInfo (copy)
		local v12 = p2:getState()
		local v13, v14 = SelectOrderedToggledOnItemsList(v12)
		local v15 = SelectUpdatedSortOrderForToggledOnItems(v12, p1, Constants.ItemType.Bundle, nil, v13, v14)

		if v15.equippedAssetsToSetOrder then
			p2:dispatch(SetOrder(v15.equippedAssetsToSetOrder))
		end

		if v15.itemIdToOrderMap then
			p2:dispatch(SetOrderForTryOns(v15.itemIdToOrderMap))
		end

		p2:dispatch(AddSelectedBundleInfo(p1, v15.bundleInfoMapping))
	end
end
