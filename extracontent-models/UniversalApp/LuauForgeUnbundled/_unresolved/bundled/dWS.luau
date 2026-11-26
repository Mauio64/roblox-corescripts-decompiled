local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXUseSignalsForLayeredClothingEntryPage = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingEntryPage

local fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice = AvatarExperienceFlags.FFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice

local fFlagAXUseSignalsForLayeredClothingCurrentSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingCurrentSort

local fFlagAXUseSignalsForLayeredClothingLastSavedSort = AvatarExperienceFlags.FFlagAXUseSignalsForLayeredClothingLastSavedSort

local module2 = require("@luauforge/bundled/dWT")
local module3 = require("@luauforge/bundled/dWV")
local module4 = require("@luauforge/bundled/dXa")
local module5 = require("@luauforge/bundled/dXc")

local combineReducers = Rodux.combineReducers

if fFlagAXUseSignalsForLayeredClothingLastSavedSort then
	module2 = nil
end

if fFlagAXUseSignalsForLayeredClothingCurrentSort then
	module3 = nil
end

if fFlagAXUseSignalsForLayeredClothingEntryPage then
	module4 = nil
end

if fFlagAXRemoveUnusedCharacterUpdatesLockedRoduxSlice then
	module5 = nil
end

return combineReducers({
	LastSavedSort = module2,
	CurrentSort = module3,
	EntryPage = module4,
	CharacterUpdatesLocked = module5
})
