local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Actions.SetCategoryAndSubcategory)
local FFlagAXEditorSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEditorSubcategoryFilters

return function(p1, p2, p3, p4) -- line: 10
	-- upvalues: SetCategoryAndSubcategory (copy), FFlagAXEditorSubcategoryFilters (copy)
	return function(p5) -- line: 11
		-- upvalues: SetCategoryAndSubcategory (copy), p1 (copy), p2 (copy), FFlagAXEditorSubcategoryFilters (copy), p4 (copy), p3 (copy)
		p5:dispatch(SetCategoryAndSubcategory(p1, p2, if not FFlagAXEditorSubcategoryFilters then nil else p4))

		local category = p5:getState().AvatarExperience.AvatarEditor.Categories.category
		local subcategory = p5:getState().AvatarExperience.AvatarEditor.Categories.subcategory
		local subcategoryFilter = p5:getState().AvatarExperience.AvatarEditor.Categories.subcategoryFilter

		p3.clickNavigationTab(category, subcategory, subcategoryFilter)
	end
end
