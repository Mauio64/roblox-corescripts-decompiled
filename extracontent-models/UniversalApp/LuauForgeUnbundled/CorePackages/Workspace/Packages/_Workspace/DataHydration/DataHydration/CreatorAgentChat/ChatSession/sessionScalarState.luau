local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Types/model")
local fFlagBuildExperienceModelPickerData = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagBuildExperienceModelPickerData

return {
	createSessionScalarState = function(p2)
		local v5, v6, v7, v8

		if fFlagBuildExperienceModelPickerData then
			v5, v6 = Signals.createSignal(nil)
			v7, v8 = Signals.createSignal(false)
		end

		local signal, v9 = Signals.createSignal(p2)
		local signal2, v10 = Signals.createSignal(false)
		local signal3, v11 = Signals.createSignal(nil)
		local signal4, v12 = Signals.createSignal(false)
		local signal5, v13 = Signals.createSignal(false)
		local signal6, v14 = Signals.createSignal(0)

		local signal7, v15 = Signals.createSignal(nil)

		return {
			getModels = v5,
			hasObservedModels = v7,
			setHasObservedModels = v8,
			setModels = v6,
			getCasSessionId = signal,
			setCasSessionId = v9,
			getHasLoadedHistory = signal2,
			setHasLoadedHistory = v10,
			markHistoryLoaded = function()
				v10(true)
			end,
			getNextHistoryPageToken = signal3,
			setNextHistoryPageToken = v11,
			getHistoryLoadInFlight = signal4,
			setHistoryLoadInFlight = v12,
			getInitialized = signal5,
			setInitialized = v13,
			getAssistantTurnSequence = signal6,
			incrementAssistantTurnSequence = function()
				local v16 = signal6(false) + 1
				v14(v16)
				return v16
			end,
			getLatestObservedHistorySequenceId = signal7,
			setLatestObservedHistorySequenceId = function(p3)
				v15(p3)
			end,
			noteHistorySequenceId = function(p3)
				if p3 == nil then
					return
				end

				local v16 = signal7(false)

				if v16 == nil or v16 < p3 then
					v15(p3)
				end
			end
		}
	end
}
