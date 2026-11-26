local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dSf")

local module2 = require("@luauforge/bundled/dPJ")
local fFlagAXEditorSubcategoryFilters = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXEditorSubcategoryFilters

return Rodux.createReducer({
	category = 1,
	subcategory = 1,
	subcategoryFilter = fFlagAXEditorSubcategoryFilters and 1 or nil,
	subButton = 1
}, {
	[module.name] = function(p2, data)
		return Cryo.Dictionary.join(p2, {
			category = data.category or p2.category,
			subcategory = data.subcategory or 1,
			subcategoryFilter = fFlagAXEditorSubcategoryFilters and (data.subcategoryFilter or 1) or nil,
			subButton = 1
		})
	end,
	[module2.name] = function(p2, data)
		return Cryo.Dictionary.join(p2, {
			category = data.category or p2.category,
			subcategory = data.subcategory or 1,
			subcategoryFilter = fFlagAXEditorSubcategoryFilters and (data.subcategoryFilter or 1) or nil,
			subButton = 1
		})
	end
})
