local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)
require(script.Parent.Parent.Types.model)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceModelPickerData = SharedFlags.FFlagBuildExperienceModelPickerData

return {
	createSessionScalarState = function(p: string?)
		local getModels, setModels, hasObservedModels, setHasObservedModels

		if FFlagBuildExperienceModelPickerData then
			getModels, setModels = Signals.createSignal(nil)
			hasObservedModels, setHasObservedModels = Signals.createSignal(false)
		end

		local signal, setCasSessionId = Signals.createSignal(p)
		local signal2, setHasLoadedHistory = Signals.createSignal(false)
		local signal3, setNextHistoryPageToken = Signals.createSignal(nil)
		local signal4, setHistoryLoadInFlight = Signals.createSignal(false)
		local signal5, setInitialized = Signals.createSignal(false)
		local signal6, v = Signals.createSignal(0)

		local signal7, v2 = Signals.createSignal(nil)

		local function setLatestObservedHistorySequenceId(p2: number?) -- 1 equivalent call inferred from this helper
			v2(p2)
		end

		return {
			getModels = getModels,
			hasObservedModels = hasObservedModels,
			setHasObservedModels = setHasObservedModels,
			setModels = setModels,
			getCasSessionId = signal,
			setCasSessionId = setCasSessionId,
			getHasLoadedHistory = signal2,
			setHasLoadedHistory = setHasLoadedHistory,
			markHistoryLoaded = function()
				setHasLoadedHistory(true)
			end,
			getNextHistoryPageToken = signal3,
			setNextHistoryPageToken = setNextHistoryPageToken,
			getHistoryLoadInFlight = signal4,
			setHistoryLoadInFlight = setHistoryLoadInFlight,
			getInitialized = signal5,
			setInitialized = setInitialized,
			getAssistantTurnSequence = signal6,
			incrementAssistantTurnSequence = function()
				local v3 = signal6(false) + 1
				v(v3)
				return v3
			end,
			getLatestObservedHistorySequenceId = signal7,
			setLatestObservedHistorySequenceId = setLatestObservedHistorySequenceId,
			noteHistorySequenceId = function(p2: number?)
				if p2 == nil then
					return
				end

				local v3 = signal7(false)

				if v3 == nil or v3 < p2 then
					setLatestObservedHistorySequenceId(p2) -- inferred equivalent call
				end
			end
		}
	end
}
