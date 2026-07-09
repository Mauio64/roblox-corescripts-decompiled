local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local scriptParent = script.Parent
local LastSavedSort = require(scriptParent.LastSavedSort)
local CurrentSort = require(scriptParent.CurrentSort)
local EntryPage = require(scriptParent.EntryPage)
local CharacterUpdatesLocked = require(scriptParent.CharacterUpdatesLocked)

return Rodux.combineReducers({
	LastSavedSort = LastSavedSort,
	CurrentSort = CurrentSort,
	EntryPage = EntryPage,
	CharacterUpdatesLocked = CharacterUpdatesLocked
})
