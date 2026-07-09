local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local AvatarExperienceSaveParent = AvatarExperienceSave.Parent
local React = require(AvatarExperienceSaveParent.React)
local Signals = require(AvatarExperienceSaveParent.Signals)
local SaveStatusEnum = require(AvatarExperienceSave.Enums.SaveStatusEnum)

if game:DefineFastFlag("FFlagAXFixAvatarSaveContext", false) then
	return (React.createContext({
		getHistorySignal = Signals.createSignal({}),
		getCurrentHistoryIndexSignal = Signals.createSignal(0),
		updateHistoryIndexAndGetCharacterData = function(_: number) -- line: 42
			return nil
		end,
		getLastSuccessfullySavedStateSignal = Signals.createSignal({}),
		getSaveEligibilityStatusSignal = Signals.createSignal(SaveStatusEnum.AlreadySaved),
		autoSaveNextNewSaveData = function() -- line: 47
			return nil
		end,
		trySaveAvatar = function() -- line: 50
			return nil
		end
	}))
end

return (React.createContext(nil))
