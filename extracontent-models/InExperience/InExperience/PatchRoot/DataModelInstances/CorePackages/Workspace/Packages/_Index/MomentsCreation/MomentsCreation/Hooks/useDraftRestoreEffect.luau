local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local MomentsCommon = require(parent.MomentsCommon)

local GetCreationFlowStore = require(MomentsCreation.Stores.GetCreationFlowStore)
local MomentsDraftStorage = require(MomentsCreation.Storage.MomentsDraftStorage)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local FailureReason = require(MomentsCreation.Enums.FailureReason)
require(MomentsCreation.Types.CreationFlowTypes)
local FFlagMomentsCommentsCreatorControl = require(MomentsCreation.Flags.FFlagMomentsCommentsCreatorControl)
local FFlagMomentsTTSDraftRestore = require(MomentsCreation.Flags.FFlagMomentsTTSDraftRestore)
local FFlagMomentsTTSVoiceSelector = require(MomentsCreation.Flags.FFlagMomentsTTSVoiceSelector)
local defaultCreationTools = require(MomentsCreation.Tools.defaultCreationTools)
local voiceTool = require(MomentsCreation.Tools.voiceTool)
local voiceCatalog = require(MomentsCreation.Components.Voice.voiceCatalog)

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local function withCreationSession(p)
	local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
	return Cryo.Dictionary.join(p, makeCreationEventFields.makeCreationBaseFields(sessionId))
end

local function withAvailableVoice(p)
	if FFlagMomentsTTSVoiceSelector and voiceCatalog.getVoiceById(p.voiceId) ~= nil then
		return p
	end

	local clone = table.clone(p)
	clone.voiceId = voiceCatalog.getDefaultVoiceId()
	return clone
end

local function useDraftRestoreEffect(p, flag: boolean?)
	local creationFlowStore = GetCreationFlowStore(false)

	React.useEffect(function()
		if
			flag
			or (creationFlowStore.getSelectedCapture(false) ~= nil or next(creationFlowStore.getEditsMap(false)) ~= nil)
			or p == nil
		then
			return
		end

		local loaded, reason = MomentsDraftStorage.load()

		if reason ~= nil then
			fireAnalyticsEvent(EventNames.DraftRestoreFailedEvent, { reason = reason })
			return
		end

		if loaded == nil then
			return
		end

		local v = nil

		for _, v2 in p.getCaptures(false) do
			if v2.LocalId == loaded.captureRef.localId then
				v = v2
				break
			end
		end

		if v == nil then
			MomentsDraftStorage.clear()
			fireAnalyticsEvent(EventNames.DraftRestoreFailedEvent, {
				reason = FailureReason.CaptureDeleted
			})
		else
			creationFlowStore.onSelectedCaptureUpdated(v)
			creationFlowStore.updateDescription(loaded.description or "")

			if FFlagMomentsCommentsCreatorControl then
				creationFlowStore.updateCommentsEnabled(loaded.commentsEnabled ~= false)
			end

			for k, edit in pairs(loaded.edits) do
				if not FFlagMomentsTTSDraftRestore or k ~= "voice" then
					creationFlowStore.setCommittedEdit(k, edit)
				end
			end

			if
				FFlagMomentsTTSDraftRestore
				and loaded.edits.voice ~= nil
				and table.find(defaultCreationTools, voiceTool) ~= nil
			then
				local voice = loaded.edits.voice

				if not FFlagMomentsTTSVoiceSelector or voiceCatalog.getVoiceById(voice.voiceId) == nil then
					voice = table.clone(voice)
					voice.voiceId = voiceCatalog.getDefaultVoiceId()
				end

				creationFlowStore.setCommittedEdit("voice", voice)
				creationFlowStore.setPendingRestoredVoice(voice)
			end

			creationFlowStore.updateCurrentState(CreationFlowState.Preview)

			fireAnalyticsEvent(EventNames.DraftRestoreSucceededEvent, withCreationSession({}))
		end
	end, { creationFlowStore, p, flag })
end

return useDraftRestoreEffect
