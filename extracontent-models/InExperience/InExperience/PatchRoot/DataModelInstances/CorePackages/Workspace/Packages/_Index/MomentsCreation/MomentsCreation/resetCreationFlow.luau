local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local MomentsCommon = require(parent.MomentsCommon)

require(MomentsCreation.Enums.CreationFlowState)
local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)

local function resetCreationFlow(p)
	local creationFlowStore = GetCreationFlowStore(false)
	local ttsAudio = creationFlowStore.getTTSAudio(false)

	if ttsAudio ~= nil then
		ttsAudio.destroy()
		creationFlowStore.setTTSAudio(nil)
	end

	creationFlowStore.clearEdits(p)

	local funnelTypes = MomentsCommon.Analytics.FunnelEventNames.FunnelTypes
	local sessionManager = MomentsCommon.Analytics.SessionManager
	sessionManager.endSession(funnelTypes.CreationFlow)
	sessionManager.endSession(funnelTypes.MusicEnhancement)
	sessionManager.endSession(funnelTypes.TextOverlayEnhancement)
	sessionManager.endSession(funnelTypes.StickerOverlayEnhancement)
	sessionManager.endSession(funnelTypes.TrimEnhancement)
	sessionManager.endSession(funnelTypes.VoiceEnhancement)
end

return resetCreationFlow
