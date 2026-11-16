local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dNN")
local module2 = require("@luauforge/bundled/dOO")
local module3 = require("@luauforge/bundled/dOQ")
local module4 = require("@luauforge/bundled/dOS")
local module5 = require("@luauforge/bundled/dOV")
local module6 = require("@luauforge/bundled/dOX")
local module7 = require("@luauforge/bundled/dOZ")
local module8 = require("@luauforge/bundled/dPb")
local module9 = require("@luauforge/bundled/dPd")
local module10 = require("@luauforge/bundled/dPf")
local module11 = require("@luauforge/bundled/dPh")
local module12 = require("@luauforge/bundled/dPm")
local module13 = require("@luauforge/bundled/dPr")
local module14 = require("@luauforge/bundled/dPs")
local module15 = require("@luauforge/bundled/dPv")
local module16 = require("@luauforge/bundled/dPx")
require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dMc")

local module17 = require("@luauforge/bundled/dOb")
local fFlagAXUseSignalsForBodyColorPickerSettings = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForBodyColorPickerSettings
local module18 = require("@luauforge/bundled/dPy")

local combineReducers = Rodux.combineReducers

if not module18() then
	module9 = nil
end

if fFlagAXUseSignalsForBodyColorPickerSettings then
	module12 = nil
end

if not module17() then
	module16 = nil
end

return combineReducers({
	Character = module,
	Categories = module2,
	EquippedEmotes = module3,
	OutfitInfos = module4,
	AvatarSettings = module5,
	DefaultBodyColorRanges = module6,
	PageFinished = module7,
	RecommendedItems = module8,
	UprankedItems = module9,
	PageLoaded = module10,
	NewItemNotifications = module11,
	BodyColorPickerSettings = module12,
	HasAvatarData = module13,
	UserInventoryRecommendations = module14,
	UserInventoryRecommendationsFetchStatus = module15,
	GrantedItems = module16
})
