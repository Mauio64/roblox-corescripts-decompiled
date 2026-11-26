local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")
local fFlagAXEditorSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorSubcategoryFilters

return Rodux.makeActionCreator("Avatar-SetCategoryAndSubcategory", function(p2, p3, subcategoryFilter)
	module.isTypeOrNil(p2, "number", "SetCategoryAndSubCategory expects category")
	module.isTypeOrNil(p3, "number", "SetCategoryAndSubCategory expects subcategory")

	if fFlagAXEditorSubcategoryFilters then
		module.isTypeOrNil(
			subcategoryFilter,
			"number",
			"SetCategoryAndSubCategory expects subcategoryFilter"
		)
	end

	if not fFlagAXEditorSubcategoryFilters then
		subcategoryFilter = nil
	end

	return { category = p2, subcategory = p3, subcategoryFilter = subcategoryFilter }
end)
