local CorePackages = game:GetService("CorePackages")
local scriptParent = script.Parent
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)
local CurrentCharacter = AvatarExperienceRodux.Reducers.CurrentCharacter
local PlayingSwimAnimation = AvatarExperienceRodux.Reducers.PlayingSwimAnimation
local ShouldDelaySaveManager = AvatarExperienceRodux.Reducers.ShouldDelaySaveManager
local CharacterVersion = require(scriptParent.CharacterVersion)
local CharacterModelVersion = require(scriptParent.CharacterModelVersion)
local TryOnCharacterModelVersion = require(scriptParent.TryOnCharacterModelVersion)
local SavedCharacterModelVersion = require(scriptParent.SavedCharacterModelVersion)
local ApplyingLayeredClothing = require(scriptParent.ApplyingLayeredClothing)
local WaitingOnLayeredClothingUpdates = require(scriptParent.WaitingOnLayeredClothingUpdates)

return function(p1, p2) -- line: 28
	-- upvalues: CharacterVersion (copy), CurrentCharacter (copy), PlayingSwimAnimation (copy), ApplyingLayeredClothing (copy), CharacterModelVersion (copy), TryOnCharacterModelVersion (copy), SavedCharacterModelVersion (copy), ShouldDelaySaveManager (copy), WaitingOnLayeredClothingUpdates (copy)
	local v15 = p1 or {}

	return {
		CharacterVersion = CharacterVersion(v15.CharacterVersion, p2),
		CurrentCharacter = CurrentCharacter(v15.CurrentCharacter, p2),
		PlayingSwimAnimation = PlayingSwimAnimation(v15.PlayingSwimAnimation, p2),
		ApplyingLayeredClothing = ApplyingLayeredClothing(v15.ApplyingLayeredClothing, p2),
		CharacterModelVersion = CharacterModelVersion(v15.CharacterModelVersion, p2),
		TryOnCharacterModelVersion = TryOnCharacterModelVersion(v15.TryOnCharacterModelVersion, p2),
		SavedCharacterModelVersion = SavedCharacterModelVersion(v15.SavedCharacterModelVersion, p2),
		ShouldDelaySaveManager = ShouldDelaySaveManager(v15.ShouldDelaySaveManager, p2),
		WaitingOnLayeredClothingUpdates = WaitingOnLayeredClothingUpdates(v15.WaitingOnLayeredClothingUpdates, p2)
	}
end
