local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")

local function resetCreationFlow(p2)
	local v5 = GetCreationFlowStore(false)
	local ttsAudio = v5.getTTSAudio(false)

	if ttsAudio ~= nil then
		ttsAudio.destroy()
		v5.setTTSAudio(nil)
	end

	v5.clearEdits(p2)

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
