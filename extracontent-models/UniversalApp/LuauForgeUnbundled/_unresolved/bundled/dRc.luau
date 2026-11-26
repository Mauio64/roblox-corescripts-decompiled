local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)

local module = require("@luauforge/bundled/dRd")
local module2 = require("@luauforge/bundled/dSe")
local module3 = require("@luauforge/bundled/dSg")
local module4 = require("@luauforge/bundled/dSi")
local module5 = require("@luauforge/bundled/dSl")
local module6 = require("@luauforge/bundled/dSn")
local module7 = require("@luauforge/bundled/dSp")
local module8 = require("@luauforge/bundled/dSr")
local module9 = require("@luauforge/bundled/dSt")
local module10 = require("@luauforge/bundled/dSv")
local module11 = require("@luauforge/bundled/dSx")
local module12 = require("@luauforge/bundled/dSC")
local module13 = require("@luauforge/bundled/dSH")
local module14 = require("@luauforge/bundled/dSI")
local module15 = require("@luauforge/bundled/dSL")
local module16 = require("@luauforge/bundled/dSN")
require("@luauforge/bundled/dKU")
require("@luauforge/bundled/dPs")

local module17 = require("@luauforge/bundled/dRr")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXUseSignalsForBodyColorPickerSettings = AvatarExperienceFlags.FFlagAXUseSignalsForBodyColorPickerSettings
local fFlagAXUseSignalsForAvatarSettings = AvatarExperienceFlags.FFlagAXUseSignalsForAvatarSettings
local module19 = require("@luauforge/bundled/dSO")

local combineReducers = Rodux.combineReducers

if fFlagAXUseSignalsForAvatarSettings then
	module5 = nil
end

if not module19() then
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
