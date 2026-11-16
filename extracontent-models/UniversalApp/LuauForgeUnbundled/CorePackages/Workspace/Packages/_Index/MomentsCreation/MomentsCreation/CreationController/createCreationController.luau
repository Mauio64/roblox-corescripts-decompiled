local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Cryo")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local DialogType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
local MomentType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/MomentType")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local creationToolRegistry = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/creationToolRegistry")
local defaultCreationTools = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Tools/defaultCreationTools")
local createCapturePreviewController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Preview/createCapturePreviewController")
local createTTSAudioManager = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/createTTSAudioManager")
local createEditSession = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createEditSession")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeDefaultTextOverlayEdit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeDefaultTextOverlayEdit")
local clampTtsStartTime = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/clampTtsStartTime")
local isAvatarMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/isAvatarMoment")
local FFlagMomentsCommentsCreatorControl = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCommentsCreatorControl")
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")
local GetFFlagMomentsTTSStartTimePositioning = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSStartTimePositioning")
local FFlagMomentsTTSVoiceSelector = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSVoiceSelector")
local FFlagMomentsTTSPublishMetadataEdits = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSPublishMetadataEdits")
local FFlagMomentsTTSDraftRestore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSDraftRestore")
local GetFFlagMomentsGenerateTextInTextOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsGenerateTextInTextOverlay")
local FFlagMomentsTextOverlayOnPhotos = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayOnPhotos")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts
local fFlagMomentsRenderCreatePostStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsRenderCreatePostStatus
local MomentsDraftStorage = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Storage/MomentsDraftStorage")

local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local getFFlagMomentsCreationSaveDraft = MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft
local fFlagMomentTextGenerationFilteredSignal = MomentsCommon.Flags.FFlagMomentTextGenerationFilteredSignal
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign

local createComputed = Signals.createComputed
local createSignal = Signals.createSignal

local function createCreationController(data)
	local store = data.store
	local host = data.host or {}
	local v5 = defaultCreationTools

	if host.toolKinds ~= nil then
		local toolKindSet = {}

		for k, toolKind in host.toolKinds do
			toolKindSet[toolKind] = true
		end

		v5 = {}

		for k, v6 in defaultCreationTools do
			if toolKindSet[v6.kind] then
				table.insert(v5, v6)
			end
		end
	end

	local registry = data.registry or creationToolRegistry(v5)

	if sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow) == nil then
		sessionManager.startSession(funnelEventNames.FunnelTypes.CreationFlow)
	end

	if
		fFlagMomentsCreateAvatarPosts
		and data.initialAvatarMoment ~= nil
		and store.getSelectedCapture(false) ~= data.initialAvatarMoment
	then
		store.clearEdits(CreationFlowState.Preview)
		store.onSelectedCaptureUpdated(data.initialAvatarMoment)
	end

	local creationController = nil

	local getActiveSession = store.getActiveSession
	local setActiveSession = store.setActiveSession

	local signal, v6 = createSignal(nil)
	local v7, v8

	if fFlagMomentsRenderCreatePostStatus then
		v7, v8 = createSignal(false)
	else
		v8 = nil
		v7 = nil
	end

	local computed = createComputed(function(p2)
		local editsMap = store.getEditsMap(p2)
		local result = {}

		for k, edit in editsMap do
			if edit == nil then
				continue
			end

			local v9 = registry.get(k)

			if v9 == nil or v9.toEdits == nil then
				result[k] = edit
			else
				for k2, v10 in v9.toEdits(edit) do
					result[k2] = v10
				end
			end
		end

		return result
	end)
	local v9, v10

	if getFFlagEnableMomentTextGeneration() then
		v9 = store.getIsGenerating
		v10 = store.setIsGenerating
	else
		v9, v10 = createSignal(false)
	end

	local v11, v12

	if getFFlagEnableMomentTextGeneration() then
		v11 = store.getActiveGeneration
		v12 = store.setActiveGeneration
	else
		v11, v12 = createSignal(nil)
	end

	local function cancelActiveGeneration()
		local v13 = v11(false)

		if v13 == nil then
			return
		end

		v13.promise:cancel()
		v12(nil)
		v10(false)
	end

	local signal2, v13 = createSignal(false)

	local signal3, v14 = createSignal(nil)

	local computed2 = createComputed(function(p2)
		local selectedCapture = store.getSelectedCapture(p2)
		local captureType = if selectedCapture ~= nil then selectedCapture.CaptureType else nil
		local avatar

		if fFlagMomentsCreateAvatarPosts and isAvatarMoment(selectedCapture) then
			avatar = MomentType.Avatar
		end

		local v15 = {
			canGenerateText = host.generateMomentText ~= nil,
			captureType = captureType,
			momentType = avatar,
			getComposedEdits = computed
		}

		local result = {}

		for k, v16 in registry.getAll() do
			local v17

			if v16.supportedCaptureTypes == nil then
				v17 = true
			else
				v17 = not (captureType == nil) and table.find(v16.supportedCaptureTypes, captureType) ~= nil
			end

			if fFlagMomentsCreateAvatarPosts and avatar ~= nil then
				if v16.supportedMomentTypes == nil then
					v17 = false
				else
					v17 = table.find(v16.supportedMomentTypes, avatar) ~= nil
				end
			end

			if v17 and (v16.isAvailable == nil or v16.isAvailable(v15)) then
				table.insert(result, v16)
			end
		end

		return result
	end)

	local computed3 = createComputed(function(p2)
		local step = store.getStep(p2)

		for k, v15 in registry.getAll() do
			if v15.step == step then
				return v15
			end
		end

		return nil
	end)

	local computed4 = createComputed(function(p2)
		local v15 = computed3(p2)

		if v15 ~= nil and v15.kind == "trim" then
			local activeSession = getActiveSession(p2)
			local v16 = if activeSession ~= nil then activeSession.getDraft(p2) else nil

			if v16 ~= nil and v16.startTime ~= nil and v16.endTime ~= nil then
				return { startTime = v16.startTime, endTime = v16.endTime }
			end
		end

		local trim = computed(p2).trim

		if trim == nil or trim.startTime == nil or trim.endTime == nil then
			return nil
		end

		return { startTime = trim.startTime, endTime = trim.endTime }
	end)

	local computed5 = createComputed(function(p2)
		local v15 = computed3(p2)

		if v15 ~= nil and v15.kind == "music" then
			local activeSession = getActiveSession(p2)
			local v16 = if activeSession ~= nil then activeSession.getDraft(p2) else nil

			if v16 ~= nil and v16.assetId ~= nil then
				return v16
			end
		end

		return computed(p2).music
	end)

	local computed6 = createComputed(function(p2)
		if not GetFFlagMomentsTTSAudioOverlay then
			return nil
		end

		local v15 = computed3(p2)

		if v15 ~= nil and v15.kind == "voice" then
			local activeSession = getActiveSession(p2)
			local v16 = if activeSession ~= nil then activeSession.getDraft(p2) else nil

			if v16 ~= nil and v16.text ~= nil and v16.text ~= "" then
				return v16
			end
		end

		return computed(p2).tts
	end)

	local preview = data.preview or createCapturePreviewController(store, computed4, computed5)

	local v15 = host.toolKinds == nil or table.find(host.toolKinds, "voice") ~= nil
	local v16 = nil

	if data.ttsAudio == nil then
		if GetFFlagMomentsTTSAudioOverlay and v15 then
			v16 = store.getTTSAudio(false)

			if v16 == nil then
				v16 = createTTSAudioManager(nil, host.ttsAudioParent)
				store.setTTSAudio(v16)
			end
		end
	else
		v16 = data.ttsAudio
	end

	local function dismissModal()
		v6(nil)
	end

	local function withCreationSession(p2)
		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		return Cryo.Dictionary.join(p2, makeCreationEventFields.makeCreationBaseFields(sessionId))
	end

	local function beginTool(p2)
		local v17 = registry.get(p2)

		if v17 == nil then
			return
		end

		MomentsCommon.Analytics.reportMomentsEditToolOpened(v17.kind)

		if v17.cta.analyticsEvent ~= nil then
			fireAnalyticsEvent(v17.cta.analyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v17)))
		end

		if v17.presentation == "InstantAction" then
			if v17.apply ~= nil then
				v17.apply(creationController)
			end
		else
			local createSession = v17.createSession
			local v18 = if createSession == nil then createEditSession() else createSession()

			if v17.step ~= nil and not store.navigate(v17.step) then
				return
			end

			local v19 = store.getEditsMap(false)[p2]
			v18.begin(v19)
			setActiveSession(v18)
		end
	end

	local function commitActiveTool()
		local activeSession = getActiveSession(false)
		local v17 = computed3(false)

		if activeSession == nil or v17 == nil then
			store.navigate(CreationFlowState.Preview)
			return
		end

		local commit = activeSession.commit()

		if v17.onCommit ~= nil and v17.onCommit(commit, creationController) == false then
			return
		end

		store.setCommittedEdit(v17.kind, commit)

		if
			GetFFlagMomentsTTSStartTimePositioning
			and v17.kind == "trim"
			and commit ~= nil
			and commit.startTime ~= nil
			and commit.endTime ~= nil
		then
			local v18 = commit.endTime - commit.startTime

			local tts = computed(false).tts

			if tts ~= nil and tts.startTime ~= nil and v18 > 0 then
				local v19 = clampTtsStartTime(tts.startTime, v18)

				if v19 ~= tts.startTime then
					local clone = table.clone(tts)
					clone.startTime = v19
					store.setCommittedEdit("voice", clone)
				end
			end
		end

		local v18 = v17.toEdits == nil or next(v17.toEdits(commit)) ~= nil

		if v17.cta.commitAnalyticsEvent ~= nil and (not v17.cta.commitRequiresEdit or v18) then
			fireAnalyticsEvent(v17.cta.commitAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v17)))
		end

		setActiveSession(nil)
		store.navigate(CreationFlowState.Preview)
	end

	local function dismiss()
		local v17 = if fFlagMomentsCreateAvatarPosts then store.getSelectedCapture(false) else nil
		local v18 = fFlagMomentsCreateAvatarPosts and isAvatarMoment(v17)

		if getFFlagEnableMomentTextGeneration() then
			local v19 = v11(false)

			if v19 ~= nil then
				v19.promise:cancel()
				v12(nil)
				v10(false)
			end

			if host.dismissGenerationToasts ~= nil then
				host.dismissGenerationToasts()
			end
		end

		v6(nil)
		local v19 = if data.excludeGallery then CreationFlowState.Preview else CreationFlowState.Gallery
		store.clearEdits(v19)

		if v16 ~= nil then
			v16.destroy()
			store.setTTSAudio(nil)
		end

		if getFFlagMomentsCreationSaveDraft() and not (host.disableDrafts or v18) then
			MomentsDraftStorage.clear()
		end

		if host.exitCreationFlow ~= nil then
			host.exitCreationFlow()
		end
	end

	local function emitGeneratedTextFeedback(p2)
		if not fFlagMomentTextGenerationFilteredSignal or host.momentGeneratedTextFeedback == nil then
			return
		end

		local generationToken = store.getGenerationToken(false)

		if generationToken == nil or generationToken == "" then
			return
		end

		host.momentGeneratedTextFeedback(generationToken, p2):catch(function() end)
	end

	local v17 = 0

	local function acceptPublishTap(): boolean
		if host.publishDebounceSeconds == nil then
			return true
		end

		local v18 = if data.clock == nil then os.clock() else data.clock()

		if v18 - v17 < host.publishDebounceSeconds then
			return false
		end

		v17 = v18
		return true
	end

	local function settlePublishResult(object)
		local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Promise")

		if not (fFlagMomentsRenderCreatePostStatus and Promise.is(object)) then
			dismiss()
			return
		end

		v8(true)
		local function finishPublish(p2)
			v8(false)

			if host.onPublishFinished ~= nil then
				host.onPublishFinished(p2)
			end

			if p2 then
				dismiss()
			end
		end
		object:andThen(function(p2)
			local v18 = p2 == true
			v8(false)

			if host.onPublishFinished ~= nil then
				host.onPublishFinished(v18)
			end

			if v18 then
				dismiss()
			end
		end, function()
			v8(false)

			if host.onPublishFinished ~= nil then
				host.onPublishFinished(false)
			end
		end)
	end

	local function publish()
		if fFlagMomentsRenderCreatePostStatus and v7(false) then
			return
		end

		local description = store.getDescription(false)

		if host.isTextFiltered ~= nil and host.isTextFiltered(description) then
			v6({
				modalType = DialogType.TextFiltered,
				modalProps = { onConfirm = dismissModal }
			})

			return
		end

		local v18

		if host.publishDebounceSeconds == nil then
			v18 = true
		else
			local v19 = if data.clock == nil then os.clock() else data.clock()

			if v19 - v17 < host.publishDebounceSeconds then
				v18 = false
			else
				v17 = v19
				v18 = true
			end
		end

		if not v18 then
			return
		end

		if FFlagMomentsTTSDraftRestore and store.getPendingRestoredVoice(false) ~= nil then
			store.setPendingRestoredVoice(nil)
			store.setCommittedEdit("voice", nil)
		end

		if fFlagMomentTextGenerationFilteredSignal then
			local generatedTextFeedback = store.getGeneratedTextFeedback(false)

			if generatedTextFeedback ~= nil then
				emitGeneratedTextFeedback(generatedTextFeedback)
			end
		end

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		local v19

		if host.createMoment ~= nil then
			local timeLength = preview.playback.getTimeLength(false)

			if FFlagMomentsCommentsCreatorControl then
				v19 = host.createMoment(
					store.getSelectedCapture(false),
					computed(false),
					description,
					sessionId,
					timeLength,
					store.getCommentsEnabled(false)
				)
			else
				v19 = host.createMoment(
					store.getSelectedCapture(false),
					computed(false),
					description,
					sessionId,
					timeLength
				)
			end
		end

		local joined = Cryo.Dictionary.join(
			makeCreationEventFields.makeStepField(eventNames.MomentsEditingFlowPublished),
			makeCreationEventFields.makeCreationBaseFields(sessionId)
		)

		if getFFlagEnableMomentTextGeneration() then
			local textOverlayEdits = store.getTextOverlayEdits(false)
			local v20

			if not (textOverlayEdits == nil or textOverlayEdits[1] == nil) then
				v20 = textOverlayEdits[1].text
			end

			joined = Cryo.Dictionary.join(
				joined,
				makeCreationEventFields.makeGeneratedTextOutcomeFields(
					store.getGeneratedDescription(false),
					description,
					store.getGeneratedSummary(false),
					v20
				)
			)
		end

		local v20 = GetFFlagMomentsTTSAudioOverlay and FFlagMomentsTTSPublishMetadataEdits

		if FFlagMomentsTTSVoiceSelector and not v20 then
			local tts = computed(false).tts

			if tts ~= nil then
				joined = Cryo.Dictionary.join(joined, {
					voiceId = tostring(tts.voiceId)
				})
			end
		end

		if GetFFlagMomentsTTSAudioOverlay and GetFFlagMomentsTTSStartTimePositioning and not v20 then
			local v21 = computed(false)
			local tts = v21.tts

			if tts ~= nil then
				local startTime = tts.startTime or 0
				local v22

				if v21.trim == nil then
					v22 = preview.playback.getTimeLength(false)
				else
					v22 = v21.trim.endTime - v21.trim.startTime
				end

				joined = Cryo.Dictionary.join(joined, {
					ttsStartTimeSeconds = tostring(startTime),
					ttsVideoDurationSeconds = tostring(v22),
					ttsStartTimeFraction = tostring(not (v22 > 0) and 0 or startTime / v22)
				})
			end
		end

		if v20 then
			local v21 = computed(false)
			local tts = v21.tts

			if tts ~= nil then
				local v22

				if v21.trim == nil then
					v22 = preview.playback.getTimeLength(false)
				else
					v22 = v21.trim.endTime - v21.trim.startTime
				end

				local v23

				if not (v16 == nil or v16.getLoadedText(false) ~= tts.text or v16.getLoadedVoiceId(false) ~= tts.voiceId) then
					v23 = v16.getTimeLength(false)
				end

				joined = Cryo.Dictionary.join(
					joined,
					makeCreationEventFields.makeVoicePublishSummaryFields(tts, v22, v23)
				)
			end
		end

		if fFlagMomentsTextOverlayV2Redesign then
			local textOverlays = computed(false).textOverlays
			joined = Cryo.Dictionary.join(
				joined,
				makeCreationEventFields.makeTextOverlayPublishSummaryFields(textOverlays and textOverlays[1])
			)
		end

		fireAnalyticsEvent(eventNames.MomentsEditingFlowPublished, joined)
		MomentsCommon.Analytics.reportMomentsCreationStep("published")

		local analytics = MomentsCommon.Analytics
		local v21 = computed(false)
		local count = 0

		if v21.music ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("music")
		end

		if v21.trim ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("trim")
		end

		if v21.textOverlays ~= nil and #v21.textOverlays > 0 then
			count += 1
			analytics.reportMomentsPublishedWithEdit("text_overlay")
		end

		if v21.stickerOverlays ~= nil and #v21.stickerOverlays > 0 then
			count += 1
			analytics.reportMomentsPublishedWithEdit("sticker")
		end

		if description ~= nil and description ~= "" then
			count += 1
			analytics.reportMomentsPublishedWithEdit("description")
		end

		if GetFFlagMomentsTTSAudioOverlay and v21.tts ~= nil then
			count += 1
			analytics.reportMomentsPublishedWithEdit("tts")
		end

		analytics.reportMomentsPublishedEditCount(count)

		local selectedCapture = store.getSelectedCapture(false)

		if selectedCapture ~= nil then
			local v22 = selectedCapture.CaptureType == Enum.CaptureType.Video and "video"
				or selectedCapture.CaptureType == Enum.CaptureType.Screenshot and "screenshot"
				or "unknown"

			analytics.reportMomentsPublishedByCaptureType(v22)
		end

		if fFlagMomentsRenderCreatePostStatus then
			settlePublishResult(v19)
		else
			dismiss()
		end
	end

	creationController = {
		getStep = store.getStep,
		navigate = function(p2)
			store.navigate(p2)
		end,
		returnToGallery = function()
			if getFFlagEnableMomentTextGeneration() then
				local v17 = v11(false)

				if v17 ~= nil then
					v17.promise:cancel()
					v12(nil)
					v10(false)
				end
			end

			store.clearEdits(CreationFlowState.Gallery)
			setActiveSession(nil)

			if v16 ~= nil then
				v16.reset()
			end

			if getFFlagMomentsCreationSaveDraft() then
				if not host.disableDrafts then
					MomentsDraftStorage.clear()
				end

				fireAnalyticsEvent(eventNames.MomentsReturnToGallery, withCreationSession({}))
			end
		end,
		getSelectedCapture = store.getSelectedCapture,
		selectCapture = function(p2)
			local v17 = v11(false)

			if getFFlagEnableMomentTextGeneration() and v17 ~= nil and p2 ~= v17.capture then
				local v18 = v11(false)

				if v18 ~= nil then
					v18.promise:cancel()
					v12(nil)
					v10(false)
				end
			end

			store.onSelectedCaptureUpdated(p2)

			if p2 ~= nil then
				fireAnalyticsEvent(
					eventNames.EditingFlowGalleryItemSelected,
					withCreationSession(makeCreationEventFields.makeToolFieldFromKind("gallery"))
				)

				MomentsCommon.Analytics.reportMomentsCreationStep("gallery_selected")
			end
		end,
		getDescription = store.getDescription,
		setDescription = function(p2)
			store.updateDescription(p2)
		end,
		getAvailableTools = computed2,
		getActiveTool = computed3,
		getActiveSession = getActiveSession,
		getComposedEdits = computed,
		getEffectiveTTS = computed6,
		beginTool = beginTool,
		commitActiveTool = commitActiveTool,
		saveActiveTool = function()
			local activeSession = getActiveSession(false)
			local v17 = computed3(false)

			if activeSession == nil or v17 == nil then
				return
			end

			local commit = activeSession.commit()
			store.setCommittedEdit(v17.kind, commit)
		end,
		clearActiveTool = function()
			local activeSession = getActiveSession(false)
			local v17 = computed3(false)

			if v17 == nil then
				return
			end

			if activeSession ~= nil then
				activeSession.update(nil)
			end

			if v17.kind == "voice" and v16 ~= nil then
				v16.reset()
			end
		end,
		discardActiveTool = function()
			local activeSession = getActiveSession(false)
			local v17 = computed3(false)

			if activeSession ~= nil then
				activeSession.discard()
			end

			if v17 ~= nil and v17.kind == "voice" and v16 ~= nil then
				local tts = computed(false).tts

				if tts == nil or tts.text == nil or tts.text == "" then
					v16.reset()
				else
					v16.generate(tts.text, tts.voiceId)
				end
			end

			if v17 ~= nil and v17.cta.cancelAnalyticsEvent ~= nil then
				fireAnalyticsEvent(v17.cta.cancelAnalyticsEvent, withCreationSession(makeCreationEventFields.makeToolField(v17)))
			end

			if v17 ~= nil then
				MomentsCommon.Analytics.reportMomentsEditToolAbandoned(v17.kind)
			end

			setActiveSession(nil)
			store.navigate(CreationFlowState.Preview)
		end,
		updateCommittedEdit = function(p2, p3)
			store.setCommittedEdit(p2, p3)
		end,
		onDisabledToolActivated = function(p2)
			if
				getFFlagEnableMomentTextGeneration()
				and p2 == "text"
				and v9(false)
				and host.onGenerateTextManualEditBlocked ~= nil
			then
				host.onGenerateTextManualEditBlocked()
			end
		end,
		getActiveModal = signal,
		showModal = function(p2)
			v6(p2)
		end,
		dismissModal = dismissModal,
		getVoiceCoachmarkDismissed = signal2,
		dismissVoiceCoachmark = function()
			v13(true)
		end,
		getSelectedVoiceId = signal3,
		setSelectedVoiceId = v14,
		getIsPublishing = v7,
		publish = publish,
		exit = function()
			fireAnalyticsEvent(
				eventNames.MomentsEditingFlowExited,
				withCreationSession(makeCreationEventFields.makeStepField(eventNames.MomentsEditingFlowExited))
			)

			dismiss()
		end,
		generateText = function(p2)
			if v9(false) or host.generateMomentText == nil then
				return
			end

			local selectedCapture = store.getSelectedCapture(false)

			if selectedCapture == nil then
				return
			end

			if getFFlagEnableMomentTextGeneration() and host.onGenerateTextWillReplaceInput ~= nil then
				local textOverlayEdits = store.getTextOverlayEdits(false)

				if textOverlayEdits ~= nil and #textOverlayEdits > 0 then
					host.onGenerateTextWillReplaceInput()
				end
			end

			v10(true)
			local momentText = host.generateMomentText(selectedCapture, p2)

			if momentText == nil then
				v10(false)
				return
			end

			if getFFlagEnableMomentTextGeneration() then
				v12({ promise = momentText, capture = selectedCapture })
			end

			momentText:andThen(function(data2)
				if getFFlagEnableMomentTextGeneration() then
					v12(nil)
				end

				if
					fFlagMomentTextGenerationFilteredSignal
					and data2 ~= nil
					and data2.error == "CONTENT_FILTERED"
				then
					fireAnalyticsEvent(eventNames.EditingFlowGenerateTextFiltered, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("filtered")

					if host.onGenerateTextFiltered ~= nil then
						host.onGenerateTextFiltered()
					end
				elseif data2 == nil or data2.error ~= nil then
					fireAnalyticsEvent(eventNames.EditingFlowGenerateTextFailed, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("failed")

					if host.onGenerateTextFailure ~= nil then
						host.onGenerateTextFailure()
					end
				else
					if data2.summary ~= nil and data2.summary ~= "" then
						local textOverlayEdits = store.getTextOverlayEdits(false)
						local v18 = if textOverlayEdits ~= nil then textOverlayEdits[1] else nil
						local v19

						if getFFlagEnableMomentTextGeneration() and v18 ~= nil then
							v19 = table.clone(v18)
						else
							v19 = makeDefaultTextOverlayEdit()
						end

						v19.text = data2.summary
						local v20

						if textOverlayEdits == nil or #textOverlayEdits == 0 then
							v20 = { v19 }
						else
							v20 = table.clone(textOverlayEdits)
							v20[1] = v19
						end

						store.updateTextOverlayEdits(v20)

						if GetFFlagMomentsGenerateTextInTextOverlay() then
							local activeSession = getActiveSession(false)
							local v21 = computed3(false)

							if activeSession ~= nil and v21 ~= nil and v21.kind == "text" then
								local draft = activeSession.getDraft(false)
								local v22 = draft and draft[1]

								if v22 == nil then
									activeSession.update(v20)
								else
									local clone = table.clone(v22)
									clone.text = data2.summary
									activeSession.update({ clone })
								end
							end
						end

						if getFFlagEnableMomentTextGeneration() then
							store.setGeneratedSummary(data2.summary)
						end
					end

					if data2.description ~= nil and data2.description ~= "" then
						store.updateDescription(data2.description)

						if
							fFlagMomentTextGenerationFilteredSignal
							or getFFlagEnableMomentTextGeneration()
						then
							store.setGeneratedDescription(data2.description)
							store.setGenerationToken(data2.generationToken)

							store.setGeneratedTextFeedback(nil)
						end
					end

					fireAnalyticsEvent(eventNames.EditingFlowGenerateTextSucceeded, withCreationSession({}))
					MomentsCommon.Analytics.reportMomentsGenerateText("succeeded")

					if host.onGenerateTextSuccess ~= nil then
						host.onGenerateTextSuccess()
					end
				end

				v10(false)
			end):catch(function()
				if getFFlagEnableMomentTextGeneration() then
					v12(nil)
				end

				fireAnalyticsEvent(eventNames.EditingFlowGenerateTextFailed, withCreationSession({}))
				MomentsCommon.Analytics.reportMomentsGenerateText("failed")

				if host.onGenerateTextFailure ~= nil then
					host.onGenerateTextFailure()
				end

				v10(false)
			end)
		end,
		getIsGenerating = v9,
		getCanGenerateText = function(p2): boolean
			if host.generateMomentText == nil then
				return false
			end

			if not FFlagMomentsTextOverlayOnPhotos then
				return true
			end

			local selectedCapture = store.getSelectedCapture(false)
			return selectedCapture ~= nil and selectedCapture.CaptureType == Enum.CaptureType.Video
		end,
		submitGeneratedTextFeedback = function(p2)
			if not fFlagMomentTextGenerationFilteredSignal then
				return
			end

			if p2 ~= "policy_violation" then
				store.setGeneratedTextFeedback(p2)

				return
			end

			store.setGeneratedTextFeedback(nil)
			emitGeneratedTextFeedback(p2)
		end,
		preview = preview,
		ttsAudio = v16,
		ttsAudioParent = host.ttsAudioParent
	}

	return creationController
end

return createCreationController
