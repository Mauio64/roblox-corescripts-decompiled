local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")
local parent = AvatarExperienceSave.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local SaveStatusEnum = require(AvatarExperienceSave.Enums.SaveStatusEnum)

if game:DefineFastFlag("FFlagAXFixAvatarSaveContext", false) then
	return (React.createContext({
		getHistorySignal = Signals.createSignal({}),
		getCurrentHistoryIndexSignal = Signals.createSignal(0),
		updateHistoryIndexAndGetCharacterData = function(_: number): nil
			return nil
		end,
		getLastSuccessfullySavedStateSignal = Signals.createSignal({}),
		getSaveEligibilityStatusSignal = Signals.createSignal(SaveStatusEnum.AlreadySaved),
		autoSaveNextNewSaveData = function(_: number?): nil
			return nil
		end,
		trySaveAvatar = function(): nil
			return nil
		end
	}))
end

return (React.createContext(nil))
