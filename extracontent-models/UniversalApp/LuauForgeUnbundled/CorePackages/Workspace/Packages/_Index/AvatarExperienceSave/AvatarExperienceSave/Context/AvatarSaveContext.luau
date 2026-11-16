local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSave/Signals")

local SaveStatusEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Enums/SaveStatusEnum")

if game:DefineFastFlag("FFlagAXFixAvatarSaveContext", false) then
	return (React.createContext({
		getHistorySignal = Signals.createSignal({}),
		getCurrentHistoryIndexSignal = Signals.createSignal(0),
		updateHistoryIndexAndGetCharacterData = function(p2): nil
			return nil
		end,
		getLastSuccessfullySavedStateSignal = Signals.createSignal({}),
		getSaveEligibilityStatusSignal = Signals.createSignal(SaveStatusEnum.AlreadySaved),
		autoSaveNextNewSaveData = function(): nil
			return nil
		end,
		trySaveAvatar = function(): nil
			return nil
		end
	}))
end

return (React.createContext(nil))
