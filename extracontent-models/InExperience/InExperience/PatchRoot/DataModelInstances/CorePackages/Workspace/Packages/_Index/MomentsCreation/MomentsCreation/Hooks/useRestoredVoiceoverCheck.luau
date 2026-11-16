local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
require(MomentsCreation.Types.CreationFlowTypes)

local function useRestoredVoiceoverCheck(p)
	local creationFlowStore = GetCreationFlowStore(false)
	local ttsAudio = p.ttsAudio

	React.useEffect(function()
		if ttsAudio == nil then
			return
		end

		return Signals.createEffect(function(p2)
			local pendingRestoredVoice = creationFlowStore.getPendingRestoredVoice(p2)

			if pendingRestoredVoice == nil then
				return
			end

			local voice = creationFlowStore.getEditsMap(p2).voice

			if
				voice == nil
				or voice.text ~= pendingRestoredVoice.text
				or voice.voiceId ~= pendingRestoredVoice.voiceId
			then
				creationFlowStore.setPendingRestoredVoice(nil)
				return
			end

			local state = ttsAudio.getState(p2)

			if state == "ready" or state == "playing" then
				if
					ttsAudio.getLoadedText(p2) == pendingRestoredVoice.text
					and ttsAudio.getLoadedVoiceId(p2) == pendingRestoredVoice.voiceId
				then
					creationFlowStore.setPendingRestoredVoice(nil)
				end
			elseif state == "error" then
				local activeTool = p.getActiveTool(p2)

				if activeTool ~= nil and activeTool.kind == "voice" then
					return
				end

				creationFlowStore.setPendingRestoredVoice(nil)
				creationFlowStore.setCommittedEdit("voice", nil)

				ttsAudio.reset()
			end
		end)
	end, { creationFlowStore, p, ttsAudio })
end

return useRestoredVoiceoverCheck
