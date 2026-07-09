local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local t1 = {
	subcategoryId = nil,
	categoryId = Constants.DefaultCatalogCategoryId
}

return Rodux.createReducer(t1, {})
