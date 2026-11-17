local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Cryo = require(parent.Cryo)
local Signals = require(parent.Signals)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local DialogType = require(MomentsCreation.Enums.DialogType)
local MomentType = require(MomentsCreation.Enums.MomentType)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local creationToolRegistry = require(MomentsCreation.Tools.creationToolRegistry)
local defaultCreationTools = require(MomentsCreation.Tools.defaultCreationTools)
local createCapturePreviewController = require(MomentsCreation.Preview.createCapturePreviewController)
local createTTSAudioManager = require(MomentsCreation.Audio.createTTSAudioManager)
local createEditSession = require(MomentsCreation.Stores.createEditSession)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local clampTtsStartTime = require(MomentsCreation.Utils.clampTtsStartTime)
local isAvatarMoment = require(MomentsCreation.Utils.isAvatarMoment)
local FFlagMomentsCommentsCreatorControl = require(MomentsCreation.Flags.FFlagMomentsCommentsCreatorControl)
local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)
local GetFFlagMomentsTTSStartTimePositioning = require(MomentsCreation.Flags.GetFFlagMomentsTTSStartTimePositioning)
local FFlagMomentsTTSVoiceSelector = require(MomentsCreation.Flags.FFlagMomentsTTSVoiceSelector)
local FFlagMomentsTTSPublishMetadataEdits = require(MomentsCreation.Flags.FFlagMomentsTTSPublishMetadataEdits)
local FFlagMomentsTTSDraftRestore = require(MomentsCreation.Flags.FFlagMomentsTTSDraftRestore)
local GetFFlagMomentsGenerateTextInTextOverlay = require(MomentsCreation.Flags.GetFFlagMomentsGenerateTextInTextOverlay)
local FFlagMomentsTextOverlayOnPhotos = require(MomentsCreation.Flags.FFlagMomentsTextOverlayOnPhotos)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsRenderCreatePostStatus = SharedFlags2.FFlagMomentsRenderCreatePostStatus
local MomentsDraftStorage = require(MomentsCreation.Storage.MomentsDraftStorage)

local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)

local MomentsCommon = require(parent.MomentsCommon)
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentsCreationSaveDraft = MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft
local FFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(data)
	local store = data.store
	local host = data.host or {}
	local defaultCreationTools2 = defaultCreationTools

	if host.toolKinds ~= nil then
		local toolKindSet = {}

		for _, toolKind in host.toolKinds do
			toolKindSet[toolKind] = true
		end

		defaultCreationTools2 = {}

		for _, defaultCreationTool in defaultCreationTools do
			if toolKindSet[defaultCreationTool.kind] then
				table.insert(defaultCreationTools2, defaultCreationTool)
			end
		end
	end

	local registry = data.registry or creationToolRegistry(defaultCreationTools2)

	if SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow) == nil then
		SessionManager.startSession(FunnelEventNames.FunnelTypes.CreationFlow)
	end

	if
		FFlagMomentsCreateAvatarPosts
		and data.initialAvatarMoment ~= nil
		and store.getSelectedCapture(false) ~= data.initialAvatarMoment
	then
		store.clearEdits(CreationFlowState.Preview)
		store.onSelectedCaptureUpdated(data.initialAvatarMoment)
	end

	local creationController = nil

	local getActiveSession = store.getActiveSession
	local setActiveSession = store.setActiveSession

	local signal, v = createSignal(nil)
	local getIsPublishing, v2

	if FFlagMomentsRenderCreatePostStatus then
		getIsPublishing, v2 = createSignal(false)
	else
		v2 = nil
		getIsPublishing = nil
	end

	local getComposedEdits = createComputed(function(p)
		local editsMap = store.getEditsMap(p)
		local result = {}

		for k, edit in editsMap do
			if edit == nil then
				continue
			end

			local v3 = registry.get(k)

			if v3 == nil or v3.toEdits == nil then
				result[k] = edit
			else
				for k2, v4 in v3.toEdits(edit) do
					result[k2] = v4
				end
			end
		end

		return result
	end)
	local getIsGenerating, v3

	if GetFFlagEnableMomentTextGeneration() then
		getIsGenerating = store.getIsGenerating
		v3 = store.setIsGenerating
	else
		getIsGenerating, v3 = createSignal(false)
	end

	local v4, v5

	if GetFFlagEnableMomentTextGeneration() then
		v4 = store.getActiveGeneration
		v5 = store.setActiveGeneration
	else
		v4, v5 = createSignal(nil)
	end

	local function cancelActiveGeneration() -- 3 equivalent calls inferred from this helper
		local v6 = v4(false)

		if v6 == nil then
			return
		end

		v6.promise:cancel()
		v5(nil)
		v3(false)
	end

	local signal2, v6 = createSignal(false)

	local signal3, setSelectedVoiceId = createSignal(nil)

	local getAvailableTools = createComputed(function(p)
		local selectedCapture = store.getSelectedCapture(p)
		local captureType

		if selectedCapture ~= nil then
			captureType = selectedCapture.CaptureType
		end

		local avatar

		if FFlagMomentsCreateAvatarPosts and isAvatarMoment(selectedCapture) then
			avatar = MomentType.Avatar
		end

		local v7 = {
			canGenerateText = host.generateMomentText ~= nil,
			captureType = captureType,
			momentType = avatar,
			getComposedEdits = getComposedEdits
		}

		local result = {}

		for _, v8 in registry.getAll() do
			local v9

			if v8.supportedCaptureTypes == nil then
				v9 = true
			elseif captureType == nil then
				v9 = false
			else
				v9 = table.find(v8.supportedCaptureTypes, captureType) ~= nil
			end

			if FFlagMomentsCreateAvatarPosts and avatar ~= nil then
				if v8.supportedMomentTypes == nil then
					v9 = false
				else
					v9 = table.find(v8.supportedMomentTypes, avatar) ~= nil
				end
			end

			if v9 and (v8.isAvailable == nil or v8.isAvailable(v7)) then
				table.insert(result, v8)
			end
		end

		return result
	end)

	local getActiveTool = createComputed(function(p)
		local step = store.getStep(p)

		for _, v7 in registry.getAll() do
			if v7.step == step then
				return v7
			end
		end

		return nil
	end)

	local computed = createComputed(function(p)
		local v7 = getActiveTool(p)

		if v7 ~= nil and v7.kind == "trim" then
			local activeSession = getActiveSession(p)
			local v8

			if activeSession ~= nil then
				v8 = activeSession.getDraft(p)
			end

			if v8 ~= nil and v8.startTime ~= nil and v8.endTime ~= nil then
				return { startTime = v8.startTime, endTime = v8.endTime }
			end
		end

		local trim = getComposedEdits(p).trim

		if trim == nil or trim.startTime == nil or trim.endTime == nil then
			return nil
		end

		return { startTime = trim.startTime, endTime = trim.endTime }
	end)

	local computed2 = createComputed(function(p)
		local v7 = getActiveTool(p)

		if v7 ~= nil and v7.kind == "music" then
			local activeSession = getActiveSession(p)
			local selected

			if activeSession ~= nil then
				selected = activeSession.getDraft(p)
			end

			if selected ~= nil and selected.assetId ~= nil then
				return selected
			end
		end

		return getComposedEdits(p).music
	end)

	local getEffectiveTTS = createComputed(function(p)
		if not GetFFlagMomentsTTSAudioOverlay then
			return nil
		end

		local v7 = getActiveTool(p)

		if v7 ~= nil and v7.kind == "voice" then
			local activeSession = getActiveSession(p)
			local selected

			if activeSession ~= nil then
				selected = activeSession.getDraft(p)
			end

			if selected ~= nil and selected.text ~= nil and selected.text ~= "" then
				return selected
			end
		end

		return getComposedEdits(p).tts
	end)

	local preview = data.preview or createCapturePreviewController(store, computed, computed2)

	local v7 = host.toolKinds == nil or table.find(host.toolKinds, "voice") ~= nil
	local ttsAudio = nil

	if data.ttsAudio == nil then
		if GetFFlagMomentsTTSAudioOverlay and v7 then
			ttsAudio = store.getTTSAudio(false)

			if ttsAudio == nil then
				ttsAudio = createTTSAudioManager(nil, host.ttsAudioParent)
				store.setTTSAudio(ttsAudio)
			end
		end
	else
		ttsAudio = data.ttsAudio
	end

	local function dismissModal()
		v(nil)
	end

	local function withCreationSession(p)
		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
		return Cryo.Dictionary.join(p, makeCreationEventFields.makeCreationBaseFields(sessionId))
	end

	local function beginTool(p: string)
		local v8 = registry.get(p)

		if v8 == nil then
			return
		end

		MomentsCommon.Analytics.reportMomentsEditToolOpened(v8.kind)

		if v8.cta.analyticsEvent ~= nil then
			fireAnalyticsEvent(v8.cta.analyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v8)))
		end

		if v8.presentation == "InstantAction" then
			if v8.apply ~= nil then
				v8.apply(creationController)
			end
		else
			local createSession = v8.createSession
			local v9

			if createSession == nil then
				v9 = createEditSession()
			else
				v9 = createSession()
			end

			if v8.step ~= nil and not store.navigate(v8.step) then
				return
			end

			local v10 = store.getEditsMap(false)[p]
			v9.begin(v10)
			setActiveSession(v9)
		end
	end

	local function commitActiveTool()
		local activeSession = getActiveSession(false)
		local v8 = getActiveTool(false)

		if activeSession == nil or v8 == nil then
			store.navigate(CreationFlowState.Preview)
			return
		end

		local commit = activeSession.commit()

		if v8.onCommit ~= nil and v8.onCommit(commit, creationController) == false then
			return
		end

		store.setCommittedEdit(v8.kind, commit)

		if
			GetFFlagMomentsTTSStartTimePositioning
			and v8.kind == "trim"
			and commit ~= nil
			and commit.startTime ~= nil
			and commit.endTime ~= nil
		then
			local v9 = commit.endTime - commit.startTime

			local tts = getComposedEdits(false).tts

			if tts ~= nil and tts.startTime ~= nil and v9 > 0 then
				local startTime = clampTtsStartTime(tts.startTime, v9)

				if startTime ~= tts.startTime then
					local clone = table.clone(tts)
					clone.startTime = startTime
					store.setCommittedEdit("voice", clone)
				end
			end
		end

		local v9 = v8.toEdits == nil or next(v8.toEdits(commit)) ~= nil

		if v8.cta.commitAnalyticsEvent ~= nil and (not v8.cta.commitRequiresEdit or v9) then
			fireAnalyticsEvent(
				v8.cta.commitAnalyticsEvent,
				withCreationSession(makeCreationEventFields.makeToolField(v8))
			)
		end

		setActiveSession(nil)
		store.navigate(CreationFlowState.Preview)
	end

	local function dismiss()
		if
			FFlagMomentsRenderCreatePostStatus
			and host.canDismissCreationFlow ~= nil
			and not host.canDismissCreationFlow()
		then
			return
		end

		local v8

		if FFlagMomentsCreateAvatarPosts then
			v8 = store.getSelectedCapture(false)
		end

		local v9 = FFlagMomentsCreateAvatarPosts and isAvatarMoment(v8)

		if GetFFlagEnableMomentTextGeneration() then
			cancelActiveGeneration() -- inferred equivalent call

			if host.dismissGenerationToasts ~= nil then
				host.dismissGenerationToasts()
			end
		end

		v(nil)
		local v10

		if data.excludeGallery then
			v10 = CreationFlowState.Preview
		else
			v10 = CreationFlowState.Gallery
		end

		store.clearEdits(v10)

		if ttsAudio ~= nil then
			ttsAudio.destroy()
			store.setTTSAudio(nil)
		end

		if GetFFlagMomentsCreationSaveDraft() and not (host.disableDrafts or v9) then
			MomentsDraftStorage.clear()
		end

		if host.exitCreationFlow ~= nil then
			host.exitCreationFlow()
		end
	end

	local function emitGeneratedTextFeedback(p: string)
		if not FFlagMomentTextGenerationFilteredSignal or host.momentGeneratedTextFeedback == nil then
			return
		end

		local generationToken = store.getGenerationToken(false)

		if generationToken == nil or generationToken == "" then
			return
		end

		host.momentGeneratedTextFeedback(generationToken, p):catch(function() end)
	end

	local v8 = 0

	local function acceptPublishTap(): boolean -- 1 equivalent call inferred from this helper
		if host.publishDebounceSeconds == nil then
			return true
		end

		local v9

		if data.clock == nil then
			v9 = os.clock()
		else
			v9 = data.clock()
		end

		if v9 - v8 < host.publishDebounceSeconds then
			return false
		end

		v8 = v9
		return true
	end

	local function settlePublishResult(object)
		local Promise = require(parent.Promise)

		if not (FFlagMomentsRenderCreatePostStatus and Promise.is(object)) then
			dismiss()
			return
		end

		v2(true)
		local function finishPublish(flag: boolean) -- 2 equivalent calls inferred from this helper
			v2(false)

			if host.onPublishFinished ~= nil then
				host.onPublishFinished(flag)
			end

			if flag then
				dismiss()
			end
		end
		object:andThen(function(p)
			finishPublish(p == true) -- inferred equivalent call
		end, function()
			finishPublish(false) -- inferred equivalent call
		end)
	end

	local function publish()
		if FFlagMomentsRenderCreatePostStatus and getIsPublishing(false) then
			return
		end

		local description = store.getDescription(false)

		if host.isTextFiltered ~= nil and host.isTextFiltered(description) then
			v({
				modalType = DialogType.TextFiltered,
				modalProps = { onConfirm = dismissModal }
			})

			return
		end

		if not acceptPublishTap() then -- inferred equivalent call
			return
		end

		if FFlagMomentsTTSDraftRestore and store.getPendingRestoredVoice(false) ~= nil then
			store.setPendingRestoredVoice(nil)
			store.setCommittedEdit("voice", nil)
		end

		if FFlagMomentTextGenerationFilteredSignal then
			local generatedTextFeedback = store.getGeneratedTextFeedback(false)

			if generatedTextFeedback ~= nil then
				emitGeneratedTextFeedback(generatedTextFeedback)
			end
		end

		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
		local v9

		if host.createMoment ~= nil then
			local timeLength = preview.playback.getTimeLength(false)

			if FFlagMomentsCommentsCreatorControl then
				v9 = host.createMoment(
					store.getSelectedCapture(false),
					getComposedEdits(false),
					description,
					sessionId,
					timeLength,
					store.getCommentsEnabled(false)
				)
			else
				v9 = host.createMoment(
					store.getSelectedCapture(false),
					getComposedEdits(false),
					description,
					sessionId,
					timeLength
				)
			end
		end

		local joined = Cryo.Dictionary.join(
			makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowPublished),
			makeCreationEventFields.makeCreationBaseFields(sessionId)
		)

		if GetFFlagEnableMomentTextGeneration() then
			local textOverlayEdits = store.getTextOverlayEdits(false)
			local v10

			if not (textOverlayEdits == nil or textOverlayEdits[1] == nil) then
				v10 = textOverlayEdits[1].text
			end

			joined = Cryo.Dictionary.join(
				joined,
				makeCreationEventFields.makeGeneratedTextOutcomeFields(
					store.getGeneratedDescription(false),
					description,
					store.getGeneratedSummary(false),
					v10
				)
			)
		end

		local v10 = GetFFlagMomentsTTSAudioOverlay and FFlagMomentsTTSPublishMetadataEdits

		if FFlagMomentsTTSVoiceSelector and not v10 then
			local tts = getComposedEdits(false).tts

			if tts ~= nil then
				joined = Cryo.Dictionary.join(joined, { voiceId = tostring(tts.voiceId) })
			end
		end

		if GetFFlagMomentsTTSAudioOverlay and GetFFlagMomentsTTSStartTimePositioning and not v10 then
			local v11 = getComposedEdits(false)
			local tts = v11.tts

			if tts ~= nil then
				local startTime = tts.startTime or 0
				local v12

				if v11.trim == nil then
					v12 = preview.playback.getTimeLength(false)
				else
					v12 = v11.trim.endTime - v11.trim.startTime
				end

				joined = Cryo.Dictionary.join(joined, {
					ttsStartTimeSeconds = tostring(startTime),
					ttsVideoDurationSeconds = tostring(v12),
					ttsStartTimeFraction = tostring(not (v12 > 0) and 0 or startTime / v12)
				})
			end
		end

		if v10 then
			local v11 = getComposedEdits(false)
			local tts = v11.tts

			if tts ~= nil then
				local v12

				if v11.trim == nil then
					v12 = preview.playback.getTimeLength(false)
				else
					v12 = v11.trim.endTime - v11.trim.startTime
				end

				local v13

				if not (ttsAudio == nil or ttsAudio.getLoadedText(false) ~= tts.text or ttsAudio.getLoadedVoiceId(false) ~= tts.voiceId) then
					v13 = ttsAudio.getTimeLength(false)
				end

				joined = Cryo.Dictionary.join(
					joined,
					makeCreationEventFields.makeVoicePublishSummaryFields(tts, v12, v13)
				)
			end
		end

		if FFlagMomentsTextOverlayV2Redesign then
			local textOverlays = getComposedEdits(false).textOverlays
			joined = Cryo.Dictionary.join(
				joined,
				makeCreationEventFields.makeTextOverlayPublishSummaryFields(textOverlays and textOverlays[1])
			)
		end

		fireAnalyticsEvent(EventNames.MomentsEditingFlowPublished, joined)
		MomentsCommon.Analytics.reportMomentsCreationStep("published")

		local analytics = MomentsCommon.Analytics
		local v11 = getComposedEdits(false)
		local count = 0

		if v11.music ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("music")
		end

		if v11.trim ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("trim")
		end

		if v11.textOverlays ~= nil and #v11.textOverlays > 0 then
			count += 1
			analytics.reportMomentsPublishedWithEdit("text_overlay")
		end

		if v11.stickerOverlays ~= nil and #v11.stickerOverlays > 0 then
			count += 1
			analytics.reportMomentsPublishedWithEdit("sticker")
		end

		if description ~= nil and description ~= "" then
			count += 1
			analytics.reportMomentsPublishedWithEdit("description")
		end

		if GetFFlagMomentsTTSAudioOverlay and v11.tts ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("tts")
		end

		analytics.reportMomentsPublishedEditCount(count)

		local selectedCapture = store.getSelectedCapture(false)

		if selectedCapture ~= nil then
			local v12 = selectedCapture.CaptureType == Enum.CaptureType.Video and "video"
				or selectedCapture.CaptureType == Enum.CaptureType.Screenshot and "screenshot"
				or "unknown"

			analytics.reportMomentsPublishedByCaptureType(v12)
		end

		if FFlagMomentsRenderCreatePostStatus then
			settlePublishResult(v9)
		else
			dismiss()
		end
	end

	creationController = {
		getStep = store.getStep,
		navigate = function(p)
			store.navigate(p)
		end,
		returnToGallery = function()
			if GetFFlagEnableMomentTextGeneration() then
				cancelActiveGeneration() -- inferred equivalent call
			end

			store.clearEdits(CreationFlowState.Gallery)
			setActiveSession(nil)

			if ttsAudio ~= nil then
				ttsAudio.reset()
			end

			if GetFFlagMomentsCreationSaveDraft() then
				if not host.disableDrafts then
					MomentsDraftStorage.clear()
				end

				fireAnalyticsEvent(EventNames.MomentsReturnToGallery, withCreationSession({}))
			end
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p)
			local v9 = v4(false)

			if GetFFlagEnableMomentTextGeneration() and v9 ~= nil and p ~= v9.capture then
				cancelActiveGeneration() -- inferred equivalent call
			end

			store.onSelectedCaptureUpdated(p)

			if p ~= nil then
				fireAnalyticsEvent(
					EventNames.EditingFlowGalleryItemSelected,
					withCreationSession(makeCreationEventFields.makeToolFieldFromKind("gallery"))
				)

				MomentsCommon.Analytics.reportMomentsCreationStep("gallery_selected")
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(p: string)
			store.updateDescription(p)
		end,
		getAvailableTools = getAvailableTools,
		getActiveTool = getActiveTool,
		getActiveSession = getActiveSession,
		getComposedEdits = getComposedEdits,
		getEffectiveTTS = getEffectiveTTS,
		beginTool = beginTool,
		commitActiveTool = commitActiveTool,
		saveActiveTool = function()
			local activeSession = getActiveSession(false)
			local v9 = getActiveTool(false)

			if activeSession == nil or v9 == nil then
				return
			end

			local commit = activeSession.commit()
			store.setCommittedEdit(v9.kind, commit)
		end,
		clearActiveTool = function()
			local activeSession = getActiveSession(false)
			local v9 = getActiveTool(false)

			if v9 == nil then
				return
			end

			if activeSession ~= nil then
				activeSession.update(nil)
			end

			if v9.kind == "voice" and ttsAudio ~= nil then
				ttsAudio.reset()
			end
		end,
		discardActiveTool = function()
			local activeSession = getActiveSession(false)
			local v9 = getActiveTool(false)

			if activeSession ~= nil then
				activeSession.discard()
			end

			if v9 ~= nil and v9.kind == "voice" and ttsAudio ~= nil then
				local tts = getComposedEdits(false).tts

				if tts == nil or tts.text == nil or tts.text == "" then
					ttsAudio.reset()
				else
					ttsAudio.generate(tts.text, tts.voiceId)
				end
			end

			if v9 ~= nil and v9.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(
					v9.cta.cancelAnalyticsEvent,
					withCreationSession(makeCreationEventFields.makeToolField(v9))
				)
			end

			if v9 ~= nil then
				MomentsCommon.Analytics.reportMomentsEditToolAbandoned(v9.kind)
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(p: string, p2)
			store.setCommittedEdit(p, p2)
		end,
		onDisabledToolActivated = function(p: string)
			if
				GetFFlagEnableMomentTextGeneration()
				and p == "text"
				and getIsGenerating(false)
				and host.onGenerateTextManualEditBlocked ~= nil
			then
				host.onGenerateTextManualEditBlocked()
			end
		end,
		getActiveModal = signal,
		showModal = function(p)
			v(p)
		end,
		dismissModal = dismissModal,
		getVoiceCoachmarkDismissed = signal2,
		dismissVoiceCoachmark = function()
			v6(true)
		end,
		getSelectedVoiceId = signal3,
		setSelectedVoiceId = setSelectedVoiceId,
		getIsPublishing = getIsPublishing,
		publish = publish,
		exit = function()
			fireAnalyticsEvent(
				EventNames.MomentsEditingFlowExited,
				withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowExited))
			)

			dismiss()
		end,
		generateText = function(p: string?)
			if getIsGenerating(false) or host.generateMomentText == nil then
				return
			end

			local selectedCapture = store.getSelectedCapture(false)

			if selectedCapture == nil then
				return
			end

			if GetFFlagEnableMomentTextGeneration() and host.onGenerateTextWillReplaceInput ~= nil then
				local textOverlayEdits = store.getTextOverlayEdits(false)

				if textOverlayEdits ~= nil and #textOverlayEdits > 0 then
					host.onGenerateTextWillReplaceInput()
				end
			end

			v3(true)
			local momentText = host.generateMomentText(selectedCapture, p)

			if momentText == nil then
				v3(false)
				return
			end

			if GetFFlagEnableMomentTextGeneration() then
				v5({ promise = momentText, capture = selectedCapture })
			end

			momentText:andThen(function(data2)
				if GetFFlagEnableMomentTextGeneration() then
					v5(nil)
				end

				if FFlagMomentTextGenerationFilteredSignal and data2 ~= nil and data2.error == "CONTENT_FILTERED" then
					fireAnalyticsEvent(EventNames.EditingFlowGenerateTextFiltered, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("filtered")

					if host.onGenerateTextFiltered ~= nil then
						host.onGenerateTextFiltered()
					end
				elseif data2 == nil or data2.error ~= nil then
					fireAnalyticsEvent(EventNames.EditingFlowGenerateTextFailed, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("failed")

					if host.onGenerateTextFailure ~= nil then
						host.onGenerateTextFailure()
					end
				else
					if data2.summary ~= nil and data2.summary ~= "" then
						local textOverlayEdits = store.getTextOverlayEdits(false)
						local v9

						if textOverlayEdits ~= nil then
							v9 = textOverlayEdits[1]
						end

						local v10

						if GetFFlagEnableMomentTextGeneration() and v9 ~= nil then
							v10 = table.clone(v9)
						else
							v10 = makeDefaultTextOverlayEdit()
						end

						v10.text = data2.summary
						local v11

						if textOverlayEdits == nil or #textOverlayEdits == 0 then
							v11 = { v10 }
						else
							v11 = table.clone(textOverlayEdits)
							v11[1] = v10
						end

						store.updateTextOverlayEdits(v11)

						if GetFFlagMomentsGenerateTextInTextOverlay() then
							local activeSession = getActiveSession(false)
							local v12 = getActiveTool(false)

							if activeSession ~= nil and v12 ~= nil and v12.kind == "text" then
								local draft = activeSession.getDraft(false)
								local v13 = draft and draft[1]

								if v13 == nil then
									activeSession.update(v11)
								else
									local clone = table.clone(v13)
									clone.text = data2.summary
									activeSession.update({ clone })
								end
							end
						end

						if GetFFlagEnableMomentTextGeneration() then
							store.setGeneratedSummary(data2.summary)
						end
					end

					if data2.description ~= nil and data2.description ~= "" then
						store.updateDescription(data2.description)

						if FFlagMomentTextGenerationFilteredSignal or GetFFlagEnableMomentTextGeneration() then
							store.setGeneratedDescription(data2.description)
							store.setGenerationToken(data2.generationToken)

							store.setGeneratedTextFeedback(nil)
						end
					end

					fireAnalyticsEvent(EventNames.EditingFlowGenerateTextSucceeded, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("succeeded")

					if host.onGenerateTextSuccess ~= nil then
						host.onGenerateTextSuccess()
					end
				end

				v3(false)
			end):catch(function()
				if GetFFlagEnableMomentTextGeneration() then
					v5(nil)
				end

				fireAnalyticsEvent(EventNames.EditingFlowGenerateTextFailed, withCreationSession({}))
				MomentsCommon.Analytics.reportMomentsGenerateText("failed")

				if host.onGenerateTextFailure ~= nil then
					host.onGenerateTextFailure()
				end

				v3(false)
			end)
		end,
		getIsGenerating = getIsGenerating,
		getCanGenerateText = function(_): boolean
			if host.generateMomentText == nil then
				return false
			end

			if not FFlagMomentsTextOverlayOnPhotos then
				return true
			end

			local selectedCapture = store.getSelectedCapture(false)
			return selectedCapture ~= nil and selectedCapture.CaptureType == Enum.CaptureType.Video
		end,
		submitGeneratedTextFeedback = function(p: string)
			if not FFlagMomentTextGenerationFilteredSignal then
				return
			end

			if p ~= "policy_violation" then
				store.setGeneratedTextFeedback(p)

				return
			end

			store.setGeneratedTextFeedback(nil)
			emitGeneratedTextFeedback(p)
		end,
		preview = preview,
		ttsAudio = ttsAudio,
		ttsAudioParent = host.ttsAudioParent
	}

	return creationController
end

return createCreationController
