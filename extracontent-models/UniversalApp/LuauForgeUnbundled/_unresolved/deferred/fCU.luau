local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local navigateWithLock = AvatarExperienceNavigation.Thunks.NavigateWithLock

local module2 = require("@luauforge/bundled/fCV")
local module3 = require("@luauforge/deferred/fCX")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXLogNilCategoryAndSubcategorySelection = AvatarExperienceFlags.FFlagAXLogNilCategoryAndSubcategorySelection

local module5 = require("@luauforge/bundled/dFs")

local function setCatalogCategoryForEmotes(object, data, p2)
	if fFlagAXCatalogCategoriesSDUI then
		local categoryId = data.MatchingCatalogPageIds.CategoryId
		local subcategoryId = data.MatchingCatalogPageIds.SubcategoryId

		if fFlagAXLogNilCategoryAndSubcategorySelection and (categoryId == nil or subcategoryId == nil) then
			module5("Navigating to missing catalog category for", data.Name)
		end

		object:dispatch(module3(categoryId, subcategoryId, p2))
	else
		local categoryKey = data.MatchingCatalogPage.CategoryKey
		local subcategoryKey = data.MatchingCatalogPage.SubcategoryKey
		local rawValue = categoryKey:rawValue()
		local v5 = if subcategoryKey then subcategoryKey:rawValue() else nil

		if fFlagAXLogNilCategoryAndSubcategorySelection and (rawValue == nil or v5 == nil) then
			module5("Navigating to missing catalog category for", data.Name)
		end

		object:dispatch(module3(rawValue, v5, p2))
	end
end

return function(p2, p3, p4)
	return function(object)
		local emotesCategorySubcategoryAndInfo, v5, v6 = module2.getEmotesCategorySubcategoryAndInfo()
		setCatalogCategoryForEmotes(object, v6, p3)

		object:dispatch(navigateWithLock(function()
			p2.navigate(avatarScreen.Catalog)

			if p4 then
				p4.clickShopForMore(emotesCategorySubcategoryAndInfo, v5)
			end
		end))
	end
end
