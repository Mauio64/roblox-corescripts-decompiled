local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dSu")
local module2 = require("@luauforge/bundled/dSy")
local module3 = require("@luauforge/bundled/dSz")
local module4 = require("@luauforge/bundled/dSB")
local module5 = require("@luauforge/bundled/dSD")
local module6 = require("@luauforge/bundled/dSF")
local module7 = require("@luauforge/bundled/dSH")
local module8 = require("@luauforge/bundled/dSK")

local fFlagAXCatalogSpecialFeaturesFilter = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogSpecialFeaturesFilter

local v5 = if fFlagAXCatalogSpecialFeaturesFilter then require("@luauforge/bundled/dSM") else nil

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
