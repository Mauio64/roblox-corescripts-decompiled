local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local AvatarExperienceHeadRefinement = require(CorePackages.Workspace.Packages.AvatarExperienceHeadRefinement)
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local scriptParent = script.Parent
local Character = require(scriptParent.Character)
local TryOn = require(scriptParent.TryOn)
local AvatarRoute = AvatarExperienceRodux.Reducers.AvatarRoute
local OutfitTryOn = require(scriptParent.OutfitTryOn)
local Looks = require(scriptParent.Looks)
local LastSavedTriedOnOutfit = require(scriptParent.LastSavedTriedOnOutfit)
local HeadRefinementReducer = AvatarExperienceHeadRefinement.Reducers.HeadRefinementReducer
local ProfileConfiguration = AvatarExperienceRodux.Reducers.ProfileConfiguration

return Rodux.combineReducers({
	Character = Character,
	TryOn = TryOn,
	AvatarRoute = AvatarRoute,
	OutfitTryOn = OutfitTryOn,
	Looks = Looks,
	LastSavedTriedOnOutfit = LastSavedTriedOnOutfit,
	HeadRefinement = HeadRefinementReducer,
	ProfileConfiguration = ProfileConfiguration
})
