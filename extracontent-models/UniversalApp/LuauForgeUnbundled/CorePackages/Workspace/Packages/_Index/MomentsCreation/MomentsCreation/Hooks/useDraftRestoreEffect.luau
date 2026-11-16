local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")

local GetCreationFlowStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetCreationFlowStore")
local MomentsDraftStorage = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Storage/MomentsDraftStorage")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local FailureReason = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/FailureReason")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
local FFlagMomentsCommentsCreatorControl = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCommentsCreatorControl")
local FFlagMomentsTTSDraftRestore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSDraftRestore")
local FFlagMomentsTTSVoiceSelector = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSVoiceSelector")
local defaultCreationTools = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/defaultCreationTools")
local voiceTool = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/voiceTool")
local voiceCatalog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/voiceCatalog")

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local function withCreationSession(p2)
	local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
	return Cryo.Dictionary.join(p2, makeCreationEventFields.makeCreationBaseFields(sessionId))
end

local function withAvailableVoice(p2)
	if FFlagMomentsTTSVoiceSelector and voiceCatalog.getVoiceById(p2.voiceId) ~= nil then
		return p2
	end

	local clone = table.clone(p2)
	clone.voiceId = voiceCatalog.getDefaultVoiceId()
	return clone
end

local function useDraftRestoreEffect(p2, p3)
	local v5 = GetCreationFlowStore(false)

	React.useEffect(function()
		if
			p3
			or (v5.getSelectedCapture(false) ~= nil or next(v5.getEditsMap(false)) ~= nil)
			or p2 == nil
		then
			return
		end

		local loaded, v6 = MomentsDraftStorage.load()

		if v6 ~= nil then
			fireAnalyticsEvent(eventNames.DraftRestoreFailedEvent, { reason = v6 })
			return
		end

		if loaded == nil then
			return
		end

		local v7 = nil

		for k, v9 in p2.getCaptures(false) do
			if v9.LocalId == loaded.captureRef.localId then
				v7 = v9
				break
			end
		end

		if v7 == nil then
			MomentsDraftStorage.clear()
			fireAnalyticsEvent(eventNames.DraftRestoreFailedEvent, {
				reason = FailureReason.CaptureDeleted
			})
		else
			v5.onSelectedCaptureUpdated(v7)
			v5.updateDescription(loaded.description or "")

			if FFlagMomentsCommentsCreatorControl then
				v5.updateCommentsEnabled(loaded.commentsEnabled ~= false)
			end

			for k, edit in pairs(loaded.edits) do
				if not FFlagMomentsTTSDraftRestore or k ~= "voice" then
					v5.setCommittedEdit(k, edit)
				end
			end

			if FFlagMomentsTTSDraftRestore and loaded.edits.voice ~= nil and table.find(defaultCreationTools, voiceTool) ~= nil then
				local voice = loaded.edits.voice

				if not FFlagMomentsTTSVoiceSelector or voiceCatalog.getVoiceById(voice.voiceId) == nil then
					voice = table.clone(voice)
					voice.voiceId = voiceCatalog.getDefaultVoiceId()
				end

				v5.setCommittedEdit("voice", voice)
				v5.setPendingRestoredVoice(voice)
			end

			v5.updateCurrentState(CreationFlowState.Preview)

			fireAnalyticsEvent(eventNames.DraftRestoreSucceededEvent, withCreationSession({}))
		end
	end, { v5, p2, p3 })
end

return useDraftRestoreEffect
