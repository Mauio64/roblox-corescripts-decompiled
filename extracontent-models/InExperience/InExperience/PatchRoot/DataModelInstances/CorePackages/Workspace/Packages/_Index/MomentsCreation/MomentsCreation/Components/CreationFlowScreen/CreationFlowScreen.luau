local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local FoundationProvider = Foundation.FoundationProvider
local Icon = Foundation.Icon
local View = Foundation.View

local ColorMode = Foundation.Enums.ColorMode

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useTokens = Foundation.Hooks.useTokens

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useToggleState = MomentsCommon.Hooks.useToggleState
local FormFactor = MomentsCommon.Enums.FormFactor
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local isAvatarMoment = require(MomentsCreation.Utils.isAvatarMoment)
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local GetFFlagMomentsCreationSaveDraft = MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft

local useSignalState = SignalsReact.useSignalState

local CreationController = require(MomentsCreation.CreationController)
local CreationControllerProvider = CreationController.CreationControllerProvider
local useCreationController = CreationController.useCreationController

local useAutoDismissState = require(MomentsCreation.Hooks.useAutoDismissState)
local useDraftRestoreEffect = require(MomentsCreation.Hooks.useDraftRestoreEffect)
local useDraftSaveEffect = require(MomentsCreation.Hooks.useDraftSaveEffect)
local useRestoredVoiceoverCheck = require(MomentsCreation.Hooks.useRestoredVoiceoverCheck)
local useDescriptionKeyboardInset = require(MomentsCreation.Hooks.useDescriptionKeyboardInset)
local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagMomentsTTSAudioOverlay = require(MomentsCreation.Flags.GetFFlagMomentsTTSAudioOverlay)
local GetFFlagMomentsTTSCoachmark = require(MomentsCreation.Flags.GetFFlagMomentsTTSCoachmark)
local FFlagMomentsTTSDraftRestore = require(MomentsCreation.Flags.FFlagMomentsTTSDraftRestore)

local GetFFlagMomentsCreationCloseButtonZIndexFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationCloseButtonZIndexFix)
local FFlagMomentsCreationToolsIxpEnabled = require(MomentsCreation.Flags.FFlagMomentsCreationToolsIxpEnabled)

local FFlagMomentsCreationMusicChipRemoveButton = require(MomentsCreation.Flags.FFlagMomentsCreationMusicChipRemoveButton)
local FFlagMomentsCreationMusicEditorRedesign = require(MomentsCreation.Flags.FFlagMomentsCreationMusicEditorRedesign)
local FFlagMomentsTextOverlayTopNav = require(MomentsCreation.Flags.FFlagMomentsTextOverlayTopNav)

local FFlagMomentsCreationCompactPanelSquareCorners = require(MomentsCreation.Flags.FFlagMomentsCreationCompactPanelSquareCorners)
local FStringMomentsCreationToolsIxpLayer = require(MomentsCreation.Flags.FStringMomentsCreationToolsIxpLayer)
local FFlagMomentsCreationToolsIxpEnabled2 = require(MomentsCreation.Flags.FFlagMomentsCreationToolsIxpEnabled2)
local FStringMomentsCreationToolsIxpLayer2 = require(MomentsCreation.Flags.FStringMomentsCreationToolsIxpLayer2)
local FFlagMomentsCreationToolsIxpEnabled3 = require(MomentsCreation.Flags.FFlagMomentsCreationToolsIxpEnabled3)
local FStringMomentsCreationToolsIxpLayer3 = require(MomentsCreation.Flags.FStringMomentsCreationToolsIxpLayer3)

local FFlagMomentsTextOverlayDragToDeleteRefinement = require(MomentsCreation.Flags.FFlagMomentsTextOverlayDragToDeleteRefinement)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsRenderCreatePostStatus = SharedFlags2.FFlagMomentsRenderCreatePostStatus
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local StepStub = require(script.Parent.StepStub)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local DialogType = require(MomentsCreation.Enums.DialogType)
local DockedEditorContext = require(MomentsCreation.Contexts.DockedEditorContext)
require(MomentsCreation.Types.CreationFlowTypes)

local CaptureView = require(MomentsCreation.Components.CaptureView)
local CreationMediaProvider = require(MomentsCreation.Components.CreationMediaProvider)
local DescriptionView = require(MomentsCreation.Components.DescriptionView)
local EditCTABar = require(MomentsCreation.Components.EditCTABar)
local GalleryView = require(MomentsCreation.Components.GalleryView)
local PlaybackControls = require(MomentsCreation.Components.PlaybackControls)
local PreviewView = require(MomentsCreation.Components.PreviewView)
local ExitConfirmationDialog = require(MomentsCreation.Components.Dialogs.ExitConfirmationDialog)
local TextFilteredDialog = require(MomentsCreation.Components.Dialogs.TextFilteredDialog)
local GenerateTextOptionsDialog = require(MomentsCreation.Components.Dialogs.GenerateTextOptionsDialog)
local VoiceoverErrorDialog = require(MomentsCreation.Components.Dialogs.VoiceoverErrorDialog)
local VoiceoverDeleteConfirmDialog = require(MomentsCreation.Components.Dialogs.VoiceoverDeleteConfirmDialog)
local VoiceSelectorDialog = require(MomentsCreation.Components.Dialogs.VoiceSelectorDialog)
local VoiceBackControls = require(MomentsCreation.Components.Voice.VoiceBackControls)

local sampleCaptures = require(MomentsCreation.Capture.sampleCaptures)
local publishMoment = require(MomentsCreation.Upload.publishMoment)
local isTextFiltered = require(MomentsCreation.Moderation.isTextFiltered)

local MusicChip = require(MomentsCreation.Components.MusicChip)

local isStudio = require(parent.MomentsCommon.isStudio)

local studio = isStudio()
local captures = not studio and {} or sampleCaptures

local function noopActivated() end
local stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function GallerySourceView(props)
	local captureSource = props.captureSource
	local captures2 = useSignalState(captureSource.getCaptures)
	local v = useSignalState(captureSource.getIsFinished)
	return React.createElement(GalleryView, {
		captures = captures2,
		layoutOrder = props.layoutOrder,
		onCaptureSelected = props.onCaptureSelected,
		onNextCallback = props.onNextCallback,
		selectedCapture = props.selectedCapture,
		hasMoreCaptures = not v,
		onShowMore = captureSource.fetchMore
	})
end

local function CreationFlowContent(props)
	local v = useCreationController()

	if GetFFlagMomentsCreationSaveDraft() then
		useDraftRestoreEffect(props.captureSource, props.disableDrafts)
		useDraftSaveEffect(props.disableDrafts)

		if FFlagMomentsTTSDraftRestore then
			useRestoredVoiceoverCheck(v)
		end
	end

	local v2 = useDeviceInsets()
	local v3 = useTokens()
	local v4 = useFormFactor()
	local v5 = useToggleState(false)
	local showText, onActivated = useAutoDismissState()

	local current2 = useSignalState(v.getStep)
	local selectedCapture = useSignalState(v.getSelectedCapture)
	local avatarMoment

	if FFlagMomentsCreateAvatarPosts and isAvatarMoment(selectedCapture) then
		avatarMoment = selectedCapture
	else
		avatarMoment = nil
	end

	local v6 = useSignalState(v.getComposedEdits)
	local tools = useSignalState(v.getAvailableTools)
	local v7 = useSignalState(v.getActiveTool)
	local v8 = useSignalState(v.getActiveModal)
	local v9 = useSignalState(v.getIsGenerating)
	local isPublishing

	if FFlagMomentsRenderCreatePostStatus then
		isPublishing = useSignalState(v.getIsPublishing)
	end

	local music = v6.music

	local v10, onAbsoluteSizeChanged = useDescriptionKeyboardInset(current2 == CreationFlowState.Description or GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice)
	local state, v11

	if FFlagMomentsCreationMusicEditorRedesign then
		local setState
		state, setState = React.useState(0)

		v11 = useMemo(function()
			return { setDockedEditorHeight = setState }
		end, { setState })
	else
		state = 0
	end

	local captureSource = props.captureSource

	local onCaptureSelected = useCallback(function(p)
		v.selectCapture(p)
		onActivated()
	end, { v, onActivated })

	local function withCreationSession(p)
		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)
		return Cryo.Dictionary.join(p, makeCreationEventFields.makeCreationBaseFields(sessionId))
	end

	local function flowStepFields()
		return withCreationSession(makeCreationEventFields.makeStepFieldFromState((v.getStep(false))))
	end

	local onNextCallback = useCallback(function()
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v.navigate(CreationFlowState.Preview)
		onActivated()
		fireAnalyticsEvent(
			EventNames.MomentsEditingFlowContinueToEditButtonPressed,
			withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToEditButtonPressed))
		)
	end, { v, onActivated })

	local onContinueCallback = useCallback(function()
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v.navigate(CreationFlowState.Description)
		v5.disable()
		fireAnalyticsEvent(
			EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed,
			withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed))
		)
	end, { v, v5.disable })

	local onReturnToEditing = useCallback(function()
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v.navigate(CreationFlowState.Preview)
	end, { v })

	local onToolSelected = useCallback(function(p: string)
		v.beginTool(p)
	end, { v })

	local onActivated2 = useCallback(function()
		v.beginTool("music")
	end, { v })

	local onRemove = useCallback(function()
		v.updateCommittedEdit("music", nil)
	end, { v })

	local onReturnToGalleryCallback = useCallback(function()
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v.dismissModal,
				onConfirm = function()
					v.dismissModal()
					v.returnToGallery()
					v5.disable()
				end
			}
		})
	end, { v, v5.disable })

	local onPublish = useCallback(function()
		v.publish()
	end, { v })

	local onActivated3 = useCallback(function()
		if selectedCapture then
			v.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = { onCancel = v.dismissModal, onConfirm = v.exit }
			})
		else
			v.exit()
		end
	end, { v, selectedCapture })

	local v12 = useRef(nil)
	useEffect(function()
		local current = v12.current
		v12.current = current2

		if current2 == CreationFlowState.Gallery then
			fireAnalyticsEvent(
				EventNames.EditingFlowGalleryPageAppear,
				withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowGalleryPageAppear))
			)
		elseif current2 == CreationFlowState.Preview then
			if
				current ~= CreationFlowState.Trimming
				and current ~= CreationFlowState.Music
				and current ~= CreationFlowState.TextOverlay
				and (not GetFFlagMomentsStickerButton() or current ~= CreationFlowState.StickerOverlay)
				and (not GetFFlagMomentsTTSAudioOverlay or current ~= CreationFlowState.Voice)
			then
				fireAnalyticsEvent(
					EventNames.EditingFlowEditPageAppear,
					withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowEditPageAppear))
				)

				if FFlagMomentsCreationToolsIxpEnabled and not props.disableExperimentExposure then
					logMomentsLayerExposure(FStringMomentsCreationToolsIxpLayer)
				end

				if FFlagMomentsCreationToolsIxpEnabled2 and not props.disableExperimentExposure then
					logMomentsLayerExposure(FStringMomentsCreationToolsIxpLayer2)
				end

				if FFlagMomentsCreationToolsIxpEnabled3 and not props.disableExperimentExposure then
					logMomentsLayerExposure(FStringMomentsCreationToolsIxpLayer3)
				end
			end
		elseif current2 == CreationFlowState.Description then
			fireAnalyticsEvent(
				EventNames.EditingFlowPreviewPageAppear,
				withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowPreviewPageAppear))
			)
		end
	end, { current2, props.disableExperimentExposure })

	useEffect(function()
		if
			current2 == CreationFlowState.Gallery
			or current2 == CreationFlowState.Music
			or current2 == CreationFlowState.Description
		then
			v5.disable()
		end
	end, { current2, v5.disable })

	local function fn()
		if not (v8 and v8.modalType) then
			return nil
		end

		if v8.modalType == DialogType.ExitCreationConfirmation then
			local createElement = React.createElement
			local v13

			if FFlagMomentsCreateAvatarPosts and avatarMoment ~= nil then
				v13 = Cryo.Dictionary.join(v8.modalProps, {
					bodyLocalizationKey = "Feature.Moments.Description.LeaveAvatarMomentsCreation"
				})
			else
				v13 = v8.modalProps
			end

			return createElement(ExitConfirmationDialog, v13)
		end

		if v8.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v8.modalProps)
		end

		if v8.modalType == DialogType.GenerateTextOptions then
			return React.createElement(GenerateTextOptionsDialog, v8.modalProps)
		end

		if v8.modalType == DialogType.VoiceoverError then
			return React.createElement(VoiceoverErrorDialog, v8.modalProps)
		end

		if v8.modalType == DialogType.VoiceoverDelete then
			return React.createElement(VoiceoverDeleteConfirmDialog, v8.modalProps)
		end

		if v8.modalType == DialogType.VoiceSelector then
			return React.createElement(VoiceSelectorDialog, v8.modalProps)
		end

		return nil
	end

	local v13

	if FFlagMomentsCreateAvatarPosts then
		v13 = avatarMoment
	end

	local v14 = useCallback(fn, { v8, v13 })

	local v15 = useCallback(function(p: string)
		if v7 == nil or v7.presentation ~= p or current2 ~= v7.step then
			return nil
		end

		if v7.renderEditor ~= nil then
			local editor = v7.renderEditor(v)

			if editor ~= nil then
				return editor
			end
		end

		return React.createElement(StepStub(v7.kind), {})
	end, { v7, current2, v })

	local v16 = useMemo(function()
		local signal, setItemSize = Signals.createSignal(Vector2.zero)
		return { getItemSize = signal, setItemSize = setItemSize }
	end, {})

	local v17 = useMemo(function()
		local signal, setItemResolution = Signals.createSignal(Vector2.zero)
		return { getItemResolution = signal, setItemResolution = setItemResolution }
	end, {})

	local v18 = useMemo(function()
		local signal, set = Signals.createSignal(false)
		return { get = signal, set = set }
	end, {})
	local hidden = useSignalState(v18.get)

	if FFlagMomentsTextOverlayDragToDeleteRefinement then
		useEffect(function()
			v18.set(false)
		end, { current2, v18 })
	end

	local v19 = useMemo(function()
		return {
			getItemSize = v16.getItemSize,
			getItemResolution = v17.getItemResolution,
			setIsOverlayDragging = v18.set
		}
	end, { v16, v17, v18 })

	local onAbsoluteSizeChanged2 = useCallback(function(p)
		v16.setItemSize(p.AbsoluteSize)
	end, { v16 })

	local onResolutionChanged = useCallback(function(vector2: Vector2)
		v17.setItemResolution(vector2)
	end, { v17 })

	local v20 = useMemo(function()
		local result = {}

		for _, v20 in tools do
			if v20.renderPreviewLayer ~= nil then
				result[v20.kind .. "PreviewLayer"] = v20.renderPreviewLayer(v, v19)
			end
		end

		return result
	end, { tools, v, v19 })
	local scaleType

	if v5.enabled then
		scaleType = Enum.ScaleType.Fit
	else
		scaleType = Enum.ScaleType.Crop
	end

	local AvatarMomentContainer = require(MomentsCreation.Components.AvatarMomentContainer)

	local createElement = React.createElement
	local v21 = {
		backgroundStyle = v3.Color.Common.Scrim,
		tag = "position-center-center anchor-center-center size-full-full",
		onActivated = onActivated3,
		stateLayer = stateLayer,
		testId = "moments-creation-background-scrim"
	}

	local createElement2 = React.createElement
	local v22 = {
		tag = {
			["position-center-center anchor-center-center size-full-full bg-surface-0"] = true,
			["radius-large"] = not FFlagMomentsCreationCompactPanelSquareCorners or v4 == FormFactor.Wide
		},
		sizeConstraint = 0,
		onActivated = 0,
		stateLayer = 0,
		testId = "moments-creation-panel"
	}
	local maxSize

	if v4 == FormFactor.Wide then
		maxSize = Vector2.new(600, 700)
	end

	v22.sizeConstraint = { MaxSize = maxSize }

	v22.onActivated = noopActivated
	v22.stateLayer = stateLayer
	local voiceBackControls

	if GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice then
		voiceBackControls = React.createElement(VoiceBackControls)
	end

	local closeButtonContainer

	if not (GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice or state > 0 or FFlagMomentsTextOverlayDragToDeleteRefinement and hidden or FFlagMomentsTextOverlayTopNav and current2 == CreationFlowState.TextOverlay) then
		closeButtonContainer = React.createElement(View, {
			padding = {
				top = UDim.new(0, v2.top + v3.Padding.Medium),
				right = UDim.new(0, v2.right + v3.Padding.Medium)
			},
			tag = "position-top-right anchor-top-right auto-xy",
			ZIndex = GetFFlagMomentsCreationCloseButtonZIndexFix and 10 or nil
		}, {
			CloseButton = React.createElement(
				View,
				{
					LayoutOrder = 1,
					onActivated = onActivated3,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0"
				},
				{
					CloseIcon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = "icons/navigation/close_small",
						size = Foundation.Enums.IconSize.Small,
						style = v3.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		})
	end

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v23 = {
		tag = "col align-x-center",
		Size = v10:map(function(p: number)
			return UDim2.new(1, 0, 1, -(p + state))
		end)
	}

	local createElement5 = React.createElement
	local v24 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v3.Color.None.Transparency
	}
	local v25 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Custom,
			ShrinkRatio = selectedCapture and 1 or 2
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v3.Radius.Large) }),
		ClickCapture = React.createElement(View, {
			tag = "size-full",
			onActivated = onActivated,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			ZIndex = 0
		}),
		CaptureView = 0,
		AvatarMomentView = 0,
		VoiceTopScrim = 0,
		PreviewMediaOverlay = 0,
		EditCTABar = 0
	}
	local captureView

	if avatarMoment == nil then
		captureView = React.createElement(CaptureView, {
			preview = v.preview,
			scaleType = scaleType,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2,
			onResolutionChanged = onResolutionChanged,
			ttsAudio = v.ttsAudio
		}, v20)
	end

	v25.CaptureView = captureView
	local avatarMomentView

	if avatarMoment ~= nil then
		avatarMomentView = React.createElement(AvatarMomentContainer, {
			preview = v.preview,
			avatarMoment = avatarMoment,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2,
			onResolutionChanged = onResolutionChanged,
			ttsAudio = v.ttsAudio
		}, v20)
	end

	v25.AvatarMomentView = avatarMomentView
	local voiceTopScrim

	if GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice then
		voiceTopScrim = React.createElement(GradientBackdrop, {
			color3 = v3.Color.Common.Scrim.Color3,
			rotation = 90,
			size = UDim2.new(1, 0, 0.25, 0),
			zIndex = 2
		})
	end

	v25.VoiceTopScrim = voiceTopScrim

	local createElement6 = React.createElement

	local createElement7 = React.createElement
	local v26 = {
		padding = {
			bottom = UDim.new(0, v3.Padding.Large),
			left = UDim.new(0, (math.max(v2.left, v3.Padding.Large))),
			right = UDim.new(0, (math.max(v2.right, v3.Padding.Large)))
		},
		tag = "size-full-0 auto-y",
		LayoutOrder = 1
	}
	local musicIndicator

	if
		music
		and (current2 == CreationFlowState.Preview or current2 == CreationFlowState.Description)
		and not (FFlagMomentsTextOverlayDragToDeleteRefinement and hidden)
	then
		local createElement8 = React.createElement

		local createElement9 = React.createElement
		local v27 = { musicAssetId = music.assetId, onActivated = onActivated2, onRemove = 0 }

		if not FFlagMomentsCreationMusicChipRemoveButton then
			onRemove = nil
		end

		v27.onRemove = onRemove
		musicIndicator = createElement8(View, {
			tag = "position-bottom-left anchor-bottom-left auto-xy"
		}, {
			MusicChip = createElement9(MusicChip, v27)
		})
	end

	local v27 = {
		OtherControls = createElement7(View, v26, { MusicIndicator = musicIndicator }),
		PlaybackControls = 0
	}
	local playbackControls

	if
		selectedCapture
		and selectedCapture.CaptureType == Enum.CaptureType.Video
		and (current2 == CreationFlowState.Gallery or current2 == CreationFlowState.Preview or GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice)
		and (showText or GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice)
		and not hidden
	then
		playbackControls = React.createElement(PlaybackControls, {
			layoutOrder = 2,
			preview = v.preview,
			toggleFitMode = v5.toggle,
			isFitMode = v5.enabled,
			onSeek = GetFFlagMomentsTTSAudioOverlay and current2 == CreationFlowState.Voice and function(p: number)
				local ttsAudio = v.ttsAudio

				if ttsAudio == nil then
					return
				end

				local timeLength = ttsAudio.getTimeLength(false)

				if timeLength > 0 and p >= 0 and p < timeLength then
					ttsAudio.seek(p)
				end
			end or nil
		})
	end

	v27.PlaybackControls = playbackControls
	v25.PreviewMediaOverlay = createElement6(
		View,
		{ tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y", ZIndex = 5 },
		v27
	)
	local editCTABar

	if current2 == CreationFlowState.Preview then
		local createElement8 = React.createElement
		local v28 = {
			tools = tools,
			onToolSelected = onToolSelected,
			showText = showText,
			zIndex = 4,
			isLoadingMap = v9 and { generateText = true } or nil,
			isDisabledMap = GetFFlagEnableMomentTextGeneration() and v9 and { text = true } or nil,
			onDisabledToolActivated = v.onDisabledToolActivated,
			hidden = 0,
			coachmark = 0
		}

		if not FFlagMomentsTextOverlayDragToDeleteRefinement then
			hidden = nil
		end

		v28.hidden = hidden
		local coachmark

		if GetFFlagMomentsTTSAudioOverlay and GetFFlagMomentsTTSCoachmark() then
			local makeVoiceCoachmarkConfig = require(script.Parent.makeVoiceCoachmarkConfig)
			coachmark = makeVoiceCoachmarkConfig(GetFFlagMomentsTTSAudioOverlay, GetFFlagMomentsTTSCoachmark())
		end

		v28.coachmark = coachmark
		editCTABar = createElement8(EditCTABar, v28)
	end

	v25.EditCTABar = editCTABar
	local v28 = {
		PreviewContainer = createElement5("CanvasGroup", v24, v25),
		GalleryView = 0,
		PreviewView = 0,
		ActiveStepEditor = 0,
		DescriptionView = 0
	}
	local galleryView

	if current2 == CreationFlowState.Gallery then
		if captureSource == nil then
			galleryView = React.createElement(GalleryView, {
				captures = captures,
				layoutOrder = 2,
				onCaptureSelected = onCaptureSelected,
				onNextCallback = onNextCallback,
				selectedCapture = selectedCapture,
				hasMoreCaptures = false,
				onShowMore = nil
			})
		else
			galleryView = React.createElement(GallerySourceView, {
				captureSource = captureSource,
				layoutOrder = 2,
				onCaptureSelected = onCaptureSelected,
				onNextCallback = onNextCallback,
				selectedCapture = selectedCapture
			})
		end
	end

	v28.GalleryView = galleryView
	local previewView

	if current2 == CreationFlowState.Preview then
		local createElement8 = React.createElement

		if props.excludeGallery then
			onReturnToGalleryCallback = nil
		end

		previewView = createElement8(PreviewView, {
			layoutOrder = 2,
			onContinueCallback = onContinueCallback,
			onReturnToGalleryCallback = onReturnToGalleryCallback
		})
	end

	v28.PreviewView = previewView

	v28.ActiveStepEditor = v15("Step")
	local descriptionView

	if current2 == CreationFlowState.Description then
		local createElement8 = React.createElement

		if not FFlagMomentsRenderCreatePostStatus then
			isPublishing = nil
		end

		descriptionView = createElement8(DescriptionView, {
			layoutOrder = 2,
			isPublishing = isPublishing,
			onPublish = onPublish,
			onReturnToEditing = onReturnToEditing
		})
	end

	v28.DescriptionView = descriptionView
	local v29 = { MainView = createElement4(View, v23, v28), MusicView = 0 }
	local musicView

	if FFlagMomentsCreationMusicEditorRedesign then
		musicView = React.createElement(DockedEditorContext.Provider, { value = v11 }, {
			MusicView = v15("Overlay")
		})
	else
		musicView = v15("Overlay")
	end

	v29.MusicView = musicView
	local element = createElement(View, v21, {
		CreationFlowView = createElement2(View, v22, {
			VoiceBackControls = voiceBackControls,
			CloseButtonContainer = closeButtonContainer,
			MainViewContainer = createElement3(View, {
				tag = "size-full",
				ZIndex = GetFFlagMomentsCreationCloseButtonZIndexFix and 1 or nil,
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			}, v29)
		}),
		Modal = v14()
	})

	return React.createElement(
		CreationMediaProvider,
		{ preview = v.preview, getSelectedCapture = v.getSelectedCapture },
		element
	)
end

local function CreationFlowScreen(props)
	local onExit = props.onExit
	local host = props.host
	local captureSource = props.captureSource
	local canDismissCreationFlow

	if FFlagMomentsRenderCreatePostStatus then
		canDismissCreationFlow = props.canDismissCreationFlow
	else
		canDismissCreationFlow = nil
	end

	local ref

	if FFlagMomentsRenderCreatePostStatus then
		ref = React.useRef(props.onPublishFinished)
		ref.current = props.onPublishFinished
	else
		ref = nil
	end

	local useMemo2 = React.useMemo
	local function fn()
		if host ~= nil then
			return host
		end

		local v = {
			exitCreationFlow = onExit,
			canDismissCreationFlow = nil,
			onPublishFinished = 0,
			captureSource = 0,
			isTextFiltered = 0,
			createMoment = 0
		}
		local canDismissCreationFlow2

		if FFlagMomentsRenderCreatePostStatus then
			canDismissCreationFlow2 = canDismissCreationFlow
		end

		v.canDismissCreationFlow = canDismissCreationFlow2
		v.onPublishFinished = FFlagMomentsRenderCreatePostStatus and function(flag: boolean)
			local current = ref.current

			if current ~= nil then
				current(flag)
			end
		end or nil

		v.captureSource = captureSource
		v.isTextFiltered = isTextFiltered
		v.createMoment = studio and function(_, _, p: string)
			print(`[moments-creation] dev publish (not uploaded): "{p}"`)
		end or publishMoment
		return v
	end

	local v

	if FFlagMomentsRenderCreatePostStatus then
		v = canDismissCreationFlow
	end

	local host2 = useMemo2(fn, { host, onExit, captureSource, v })

	local createElement = React.createElement
	local v2 = { colorMode = ColorMode.Dark }

	local createElement2 = React.createElement
	local v3 = { host = host2, excludeGallery = props.excludeGallery, initialAvatarMoment = 0 }
	local initialAvatarMoment

	if FFlagMomentsCreateAvatarPosts then
		initialAvatarMoment = props.initialAvatarMoment
	end

	v3.initialAvatarMoment = initialAvatarMoment
	return createElement(FoundationProvider, v2, {
		Root = createElement2(CreationControllerProvider, v3, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = props.excludeGallery,
				captureSource = host2.captureSource,
				disableDrafts = host2.disableDrafts,
				disableExperimentExposure = host2.disableExperimentExposure
			})
		})
	})
end

return CreationFlowScreen
