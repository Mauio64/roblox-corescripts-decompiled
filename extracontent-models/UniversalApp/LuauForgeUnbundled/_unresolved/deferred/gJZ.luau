local module = require("@luauforge/bundled/dSf")
local fFlagAXEditorSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorSubcategoryFilters

return function(p2, p3, p4, p5)
	return function(object)
		object:dispatch(module(p2, p3, if fFlagAXEditorSubcategoryFilters then p5 else nil))

		local category = object:getState().AvatarExperience.AvatarEditor.Categories.category
		local subcategory = object:getState().AvatarExperience.AvatarEditor.Categories.subcategory
		local subcategoryFilter = object:getState().AvatarExperience.AvatarEditor.Categories.subcategoryFilter
		p4.clickNavigationTab(category, subcategory, subcategoryFilter)
	end
end
