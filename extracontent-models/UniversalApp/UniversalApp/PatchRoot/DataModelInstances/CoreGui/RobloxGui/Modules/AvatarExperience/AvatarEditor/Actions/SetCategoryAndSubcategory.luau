local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local FFlagAXEditorSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEditorSubcategoryFilters

return Rodux.makeActionCreator("Avatar-" .. script.Name, function(p1, p2, p3) -- line: 14
	-- upvalues: ArgCheck (copy), FFlagAXEditorSubcategoryFilters (copy)
	ArgCheck.isTypeOrNil(p1, "number", "SetCategoryAndSubCategory expects category")
	ArgCheck.isTypeOrNil(p2, "number", "SetCategoryAndSubCategory expects subcategory")

	if FFlagAXEditorSubcategoryFilters then
		ArgCheck.isTypeOrNil(p3, "number", "SetCategoryAndSubCategory expects subcategoryFilter")
	end

	return {
		category = p1,
		subcategory = p2,
		subcategoryFilter = if not FFlagAXEditorSubcategoryFilters then nil else p3
	}
end)
