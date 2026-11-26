local module = require("@luauforge/bundled/dKU")
local currentCharacter = module.Reducers.CurrentCharacter
local playingSwimAnimation = module.Reducers.PlayingSwimAnimation
local shouldDelaySaveManager = module.Reducers.ShouldDelaySaveManager
local module2 = require("@luauforge/bundled/dOY")
local module3 = require("@luauforge/bundled/dPa")
local module4 = require("@luauforge/bundled/dPc")
local module5 = require("@luauforge/bundled/dPe")
local module6 = require("@luauforge/bundled/dPg")
local module7 = require("@luauforge/bundled/dPj")

local fFlagAXUseSignalsForApplyingLayeredClothing = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForApplyingLayeredClothing

return function(options, p2)
	local v5 = options or {}

	local v6 = {
		CharacterVersion = module2(v5.CharacterVersion, p2),
		CurrentCharacter = currentCharacter(v5.CurrentCharacter, p2),
		PlayingSwimAnimation = playingSwimAnimation(v5.PlayingSwimAnimation, p2),
		ApplyingLayeredClothing = 0,
		CharacterModelVersion = 0,
		TryOnCharacterModelVersion = 0,
		SavedCharacterModelVersion = 0,
		ShouldDelaySaveManager = 0,
		WaitingOnLayeredClothingUpdates = 0
	}

	local v7 = if not fFlagAXUseSignalsForApplyingLayeredClothing then module6(v5.ApplyingLayeredClothing, p2) else nil
	v6.ApplyingLayeredClothing = v7

	v6.CharacterModelVersion = module3(v5.CharacterModelVersion, p2)
	v6.TryOnCharacterModelVersion = module4(v5.TryOnCharacterModelVersion, p2)
	v6.SavedCharacterModelVersion = module5(v5.SavedCharacterModelVersion, p2)
	v6.ShouldDelaySaveManager = shouldDelaySaveManager(v5.ShouldDelaySaveManager, p2)
	v6.WaitingOnLayeredClothingUpdates = module7(v5.WaitingOnLayeredClothingUpdates, p2)
	return v6
end
