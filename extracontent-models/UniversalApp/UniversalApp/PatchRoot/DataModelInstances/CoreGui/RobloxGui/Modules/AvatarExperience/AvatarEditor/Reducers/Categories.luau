local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Actions.SetCategoryAndSubcategory)
local NavigatedToDeepLinkAvatarEditor = require(Modules.AvatarExperience.AvatarEditor.Actions.NavigatedToDeepLinkAvatarEditor)
local FFlagAXEditorSubcategoryFilters = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEditorSubcategoryFilters
local t1 = {
	category = 1,
	subcategory = 1,
	subButton = 1,
	subcategoryFilter = if not FFlagAXEditorSubcategoryFilters then nil else 1
}

return Rodux.createReducer(t1, {
	[SetCategoryAndSubcategory.name] = function(t2: {[any]: any}, t3: {[any]: any}) -- line: 31
		-- upvalues: Cryo (copy), FFlagAXEditorSubcategoryFilters (copy)
		return Cryo.Dictionary.join(t2, {
			subButton = 1,
			category = t3.category or t2.category,
			subcategory = t3.subcategory or 1,
			subcategoryFilter = if not FFlagAXEditorSubcategoryFilters then nil else t3.subcategoryFilter or 1
		})
	end,
	[NavigatedToDeepLinkAvatarEditor.name] = function(t4: {[any]: any}, t5: {[any]: any}) -- line: 41
		-- upvalues: Cryo (copy), FFlagAXEditorSubcategoryFilters (copy)
		return Cryo.Dictionary.join(t4, {
			subButton = 1,
			category = t5.category or t4.category,
			subcategory = t5.subcategory or 1,
			subcategoryFilter = if not FFlagAXEditorSubcategoryFilters then nil else t5.subcategoryFilter or 1
		})
	end
})
