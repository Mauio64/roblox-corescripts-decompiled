local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useCallback = React.useCallback
local module = require("@luauforge/bundled/fCn")
local module2 = require("@luauforge/deferred/gPt")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local module3 = require("@luauforge/deferred/hff")

require("@luauforge/deferred/hfd")

local buildSlotCategoryTabItems = module.Utils.buildSlotCategoryTabItems
local buildSlotCategoryLocalizationKeys = module.Utils.buildSlotCategoryLocalizationKeys
local categoryMenuButtonsLocationEnum = module2.CategoryMenuButtonsLocationEnum

local function useCategoryMenuSlotNavigationProps(data)
	local categories = data.categories
	local slotCategory = data.slotCategory

	local v5 = useLocalization(buildSlotCategoryLocalizationKeys(categories))
	local v6 = React.useMemo(function()
		return buildSlotCategoryTabItems(categories, v5)
	end, { categories, v5 })

	React.useEffect(function()
		local category = categories[slotCategory]
		local v7 = category and category.hide and data.onSlotCategorySelected and v6[1]

		if v7 then
			local id = v7.id
			data.onSlotCategorySelected(id, categories[id])
		end
	end, { slotCategory, categories, v6, data.onSlotCategorySelected })

	local v7 = module3(data.showFilterButton == true)
	local v8 = React.useMemo(function()
		if v7 then
			return { v7 }
		end

		return nil
	end, { v7 })

	return {
		categories = v6,
		activeCategoryId = slotCategory,
		onCategoryActivated = useCallback(function(p2)
			if not data.onSlotCategorySelected then
				return
			end

			local category = categories[p2]

			if category then
				data.onSlotCategorySelected(p2, category)
			end
		end, { categories, data.onSlotCategorySelected }),
		buttons = v8,
		buttonsLocation = categoryMenuButtonsLocationEnum.CategoriesEnd,
		LayoutOrder = data.LayoutOrder,
		ZIndex = data.ZIndex
	}
end

return useCategoryMenuSlotNavigationProps
