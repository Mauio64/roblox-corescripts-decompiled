local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dVP")
local module2 = require("@luauforge/bundled/dVT")
local module3 = require("@luauforge/bundled/dVU")
local module4 = require("@luauforge/bundled/dVW")
local module5 = require("@luauforge/bundled/dVY")
local module6 = require("@luauforge/bundled/dWa")
local module7 = require("@luauforge/bundled/dWc")
local module8 = require("@luauforge/bundled/dWf")

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local v5 = if fFlagAXCatalogSpecialFeaturesFilter then require("@luauforge/bundled/dWh") else nil

local combineReducers = Rodux.combineReducers

if not fFlagAXCatalogSpecialFeaturesFilter then
	v5 = nil
end

return combineReducers({
	CatalogSort = module,
	CatalogSortAggregation = module2,
	PriceRange = module3,
	SalesTypeFilter = module4,
	CreatorFilter = module5,
	UnavailableItemFilter = module6,
	SelectedTopics = module7,
	WearTimeFilter = module8,
	SpecialFeaturesFilter = v5
})
