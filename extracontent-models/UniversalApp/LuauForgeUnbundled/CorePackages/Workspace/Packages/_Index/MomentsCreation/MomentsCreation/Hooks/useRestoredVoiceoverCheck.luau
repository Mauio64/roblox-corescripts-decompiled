local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function useRestoredVoiceoverCheck(p2)
	local v5 = GetCreationFlowStore(false)
	local ttsAudio = p2.ttsAudio

	React.useEffect(function()
		if ttsAudio == nil then
			return
		end

		return Signals.createEffect(function(p3)
			local pendingRestoredVoice = v5.getPendingRestoredVoice(p3)

			if pendingRestoredVoice == nil then
				return
			end

			local voice = v5.getEditsMap(p3).voice

			if
				voice == nil
				or voice.text ~= pendingRestoredVoice.text
				or voice.voiceId ~= pendingRestoredVoice.voiceId
			then
				v5.setPendingRestoredVoice(nil)
				return
			end

			local state = ttsAudio.getState(p3)

			if state == "ready" or state == "playing" then
				if
					ttsAudio.getLoadedText(p3) == pendingRestoredVoice.text
					and ttsAudio.getLoadedVoiceId(p3) == pendingRestoredVoice.voiceId
				then
					v5.setPendingRestoredVoice(nil)
				end
			elseif state == "error" then
				local activeTool = p2.getActiveTool(p3)

				if activeTool ~= nil and activeTool.kind == "voice" then
					return
				end

				v5.setPendingRestoredVoice(nil)
				v5.setCommittedEdit("voice", nil)

				ttsAudio.reset()
			end
		end)
	end, { v5, p2, ttsAudio })
end

return useRestoredVoiceoverCheck
