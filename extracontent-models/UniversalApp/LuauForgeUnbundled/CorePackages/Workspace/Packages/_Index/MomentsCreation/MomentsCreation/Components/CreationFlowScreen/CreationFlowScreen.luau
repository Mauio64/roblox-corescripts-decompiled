local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local foundationProvider = Foundation.FoundationProvider
local icon = Foundation.Icon
local view = Foundation.View

local colorMode = Foundation.Enums.ColorMode

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useTokens = Foundation.Hooks.useTokens

local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useToggleState = MomentsCommon.Hooks.useToggleState
local formFactor = MomentsCommon.Enums.FormFactor
local gradientBackdrop = MomentsCommon.Components.GradientBackdrop

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local isAvatarMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/isAvatarMoment")
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local getFFlagMomentsCreationSaveDraft = MomentsCommon.Flags.GetFFlagMomentsCreationSaveDraft

local useSignalState = SignalsReact.useSignalState

local CreationController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/CreationController")
local creationControllerProvider = CreationController.CreationControllerProvider
local useCreationController = CreationController.useCreationController

local useAutoDismissState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useAutoDismissState")
local useDraftRestoreEffect = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useDraftRestoreEffect")
local useDraftSaveEffect = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useDraftSaveEffect")
local useRestoredVoiceoverCheck = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useRestoredVoiceoverCheck")
local useDescriptionKeyboardInset = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useDescriptionKeyboardInset")
local getFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")
local GetFFlagMomentsTTSCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSCoachmark")
local FFlagMomentsTTSDraftRestore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSDraftRestore")

local GetFFlagMomentsCreationCloseButtonZIndexFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsCreationCloseButtonZIndexFix")
local FFlagMomentsCreationToolsIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationToolsIxpEnabled")

local FFlagMomentsCreationMusicChipRemoveButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicChipRemoveButton")
local FFlagMomentsCreationMusicEditorRedesign = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicEditorRedesign")
local FFlagMomentsTextOverlayTopNav = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayTopNav")

local FFlagMomentsCreationCompactPanelSquareCorners = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationCompactPanelSquareCorners")
local FStringMomentsCreationToolsIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FStringMomentsCreationToolsIxpLayer")
local FFlagMomentsCreationToolsIxpEnabled2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationToolsIxpEnabled2")
local FStringMomentsCreationToolsIxpLayer2 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FStringMomentsCreationToolsIxpLayer2")
local FFlagMomentsCreationToolsIxpEnabled3 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationToolsIxpEnabled3")
local FStringMomentsCreationToolsIxpLayer3 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FStringMomentsCreationToolsIxpLayer3")

local FFlagMomentsTextOverlayDragToDeleteRefinement = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayDragToDeleteRefinement")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsCreateAvatarPosts
local fFlagMomentsRenderCreatePostStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SharedFlags").FFlagMomentsRenderCreatePostStatus
local logMomentsLayerExposure = MomentsCommon.Utils.logMomentsLayerExposure
local StepStub = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CreationFlowScreen/StepStub")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local DialogType = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DialogType")
local DockedEditorContext = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Contexts/DockedEditorContext")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local module35 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CaptureView")
local CreationMediaProvider = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CreationMediaProvider")
local module37 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/DescriptionView")
local module38 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/EditCTABar")
local module39 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/GalleryView")
local module40 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/PlaybackControls")
local module41 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/PreviewView")
local ExitConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/ExitConfirmationDialog")
local TextFilteredDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/TextFilteredDialog")
local GenerateTextOptionsDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/GenerateTextOptionsDialog")
local VoiceoverErrorDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/VoiceoverErrorDialog")
local VoiceoverDeleteConfirmDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/VoiceoverDeleteConfirmDialog")
local VoiceSelectorDialog = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Dialogs/VoiceSelectorDialog")
local module48 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Voice/VoiceBackControls")

local sampleCaptures = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/sampleCaptures")
local publishMoment = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Upload/publishMoment")
local module51 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Moderation/isTextFiltered")

local module52 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicChip")

local v5 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCommon/isStudio")()
local v6 = not v5 and {} or sampleCaptures

local function noopActivated() end
local v7 = { affordance = Foundation.Enums.StateLayerAffordance.None }

local function GallerySourceView(props)
	local captureSource = props.captureSource
	local v8 = useSignalState(captureSource.getCaptures)
	local v9 = useSignalState(captureSource.getIsFinished)
	return React.createElement(module39, {
		captures = v8,
		layoutOrder = props.layoutOrder,
		onCaptureSelected = props.onCaptureSelected,
		onNextCallback = props.onNextCallback,
		selectedCapture = props.selectedCapture,
		hasMoreCaptures = not v9,
		onShowMore = captureSource.fetchMore
	})
end

local function CreationFlowContent(props)
	local v8 = useCreationController()

	if getFFlagMomentsCreationSaveDraft() then
		useDraftRestoreEffect(props.captureSource, props.disableDrafts)
		useDraftSaveEffect(props.disableDrafts)

		if FFlagMomentsTTSDraftRestore then
			useRestoredVoiceoverCheck(v8)
		end
	end

	local v9 = useDeviceInsets()
	local v10 = useTokens()
	local v11 = useFormFactor()
	local v12 = useToggleState(false)
	local v13, v14 = useAutoDismissState()

	local v15 = useSignalState(v8.getStep)
	local v16 = useSignalState(v8.getSelectedCapture)

	local v17 = if fFlagMomentsCreateAvatarPosts and isAvatarMoment(v16) then v16 else nil

	local v18 = useSignalState(v8.getComposedEdits)
	local v19 = useSignalState(v8.getAvailableTools)
	local v20 = useSignalState(v8.getActiveTool)
	local v21 = useSignalState(v8.getActiveModal)
	local v22 = useSignalState(v8.getIsGenerating)

	local v23 = if fFlagMomentsRenderCreatePostStatus then useSignalState(v8.getIsPublishing) else nil

	local music = v18.music

	local v24, v25 = useDescriptionKeyboardInset(v15 == CreationFlowState.Description or GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice)
	local state, v26

	if FFlagMomentsCreationMusicEditorRedesign then
		local setState
		state, setState = React.useState(0)

		v26 = useMemo(function()
			return { setDockedEditorHeight = setState }
		end, { setState })
	else
		state = 0
	end

	local captureSource = props.captureSource

	local v27 = useCallback(function(p2)
		v8.selectCapture(p2)
		v14()
	end, { v8, v14 })

	local function withCreationSession(p2)
		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)
		return Cryo.Dictionary.join(p2, makeCreationEventFields.makeCreationBaseFields(sessionId))
	end

	local function flowStepFields()
		return withCreationSession(makeCreationEventFields.makeStepFieldFromState(v8.getStep(false)))
	end

	local v28 = useCallback(function()
		fireAnalyticsEvent(eventNames.EditingFlowNextButtonPressed, flowStepFields())
		v8.navigate(CreationFlowState.Preview)
		v14()
		fireAnalyticsEvent(
			eventNames.MomentsEditingFlowContinueToEditButtonPressed,
			withCreationSession(makeCreationEventFields.makeStepField(eventNames.MomentsEditingFlowContinueToEditButtonPressed))
		)
	end, { v8, v14 })

	local v29 = useCallback(function()
		fireAnalyticsEvent(eventNames.EditingFlowNextButtonPressed, flowStepFields())
		v8.navigate(CreationFlowState.Description)
		v12.disable()
		fireAnalyticsEvent(
			eventNames.MomentsEditingFlowContinueToDescriptionButtonPressed,
			withCreationSession(makeCreationEventFields.makeStepField(eventNames.MomentsEditingFlowContinueToDescriptionButtonPressed))
		)
	end, { v8, v12.disable })

	local v30 = useCallback(function()
		fireAnalyticsEvent(eventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v8.navigate(CreationFlowState.Preview)
	end, { v8 })

	local v31 = useCallback(function(p2)
		v8.beginTool(p2)
	end, { v8 })

	local v32 = useCallback(function()
		v8.beginTool("music")
	end, { v8 })

	local v33 = useCallback(function()
		v8.updateCommittedEdit("music", nil)
	end, { v8 })

	local v34 = useCallback(function()
		fireAnalyticsEvent(eventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v8.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v8.dismissModal,
				onConfirm = function()
					v8.dismissModal()
					v8.returnToGallery()
					v12.disable()
				end
			}
		})
	end, { v8, v12.disable })

	local v35 = useCallback(function()
		v8.publish()
	end, { v8 })

	local v36 = useCallback(function()
		if v16 then
			v8.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = { onCancel = v8.dismissModal, onConfirm = v8.exit }
			})
		else
			v8.exit()
		end
	end, { v8, v16 })

	local v37 = useRef(nil)
	useEffect(function()
		local current = v37.current
		v37.current = v15

		if v15 == CreationFlowState.Gallery then
			fireAnalyticsEvent(
				eventNames.EditingFlowGalleryPageAppear,
				withCreationSession(makeCreationEventFields.makeStepField(eventNames.EditingFlowGalleryPageAppear))
			)
		elseif v15 == CreationFlowState.Preview then
			if
				current ~= CreationFlowState.Trimming
				and current ~= CreationFlowState.Music
				and current ~= CreationFlowState.TextOverlay
				and (not getFFlagMomentsStickerButton() or current ~= CreationFlowState.StickerOverlay)
				and (not GetFFlagMomentsTTSAudioOverlay or current ~= CreationFlowState.Voice)
			then
				fireAnalyticsEvent(
					eventNames.EditingFlowEditPageAppear,
					withCreationSession(makeCreationEventFields.makeStepField(eventNames.EditingFlowEditPageAppear))
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
		elseif v15 == CreationFlowState.Description then
			fireAnalyticsEvent(
				eventNames.EditingFlowPreviewPageAppear,
				withCreationSession(makeCreationEventFields.makeStepField(eventNames.EditingFlowPreviewPageAppear))
			)
		end
	end, { v15, props.disableExperimentExposure })

	useEffect(function()
		if v15 == CreationFlowState.Gallery or v15 == CreationFlowState.Music or v15 == CreationFlowState.Description then
			v12.disable()
		end
	end, { v15, v12.disable })

	local function fn()
		if not (v21 and v21.modalType) then
			return nil
		end

		if v21.modalType == DialogType.ExitCreationConfirmation then
			local createElement = React.createElement

			local v40 = if fFlagMomentsCreateAvatarPosts and v17 ~= nil then Cryo.Dictionary.join(v21.modalProps, {
				bodyLocalizationKey = "Feature.Moments.Description.LeaveAvatarMomentsCreation"
			}) else v21.modalProps
			return createElement(ExitConfirmationDialog, v40)
		end

		if v21.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v21.modalProps)
		end

		if v21.modalType == DialogType.GenerateTextOptions then
			return React.createElement(GenerateTextOptionsDialog, v21.modalProps)
		end

		if v21.modalType == DialogType.VoiceoverError then
			return React.createElement(VoiceoverErrorDialog, v21.modalProps)
		end

		if v21.modalType == DialogType.VoiceoverDelete then
			return React.createElement(VoiceoverDeleteConfirmDialog, v21.modalProps)
		end

		if v21.modalType == DialogType.VoiceSelector then
			return React.createElement(VoiceSelectorDialog, v21.modalProps)
		end

		return nil
	end

	local v41 = useCallback(fn, { v21, if fFlagMomentsCreateAvatarPosts then v17 else nil })

	local v42 = useCallback(function(p2)
		if v20 == nil or v20.presentation ~= p2 or v15 ~= v20.step then
			return nil
		end

		if v20.renderEditor ~= nil then
			local editor = v20.renderEditor(v8)

			if editor ~= nil then
				return editor
			end
		end

		return React.createElement(StepStub(v20.kind), {})
	end, { v20, v15, v8 })

	local v43 = useMemo(function()
		local signal, v44 = Signals.createSignal(Vector2.zero)
		return { getItemSize = signal, setItemSize = v44 }
	end, {})

	local v44 = useMemo(function()
		local signal, v45 = Signals.createSignal(Vector2.zero)
		return { getItemResolution = signal, setItemResolution = v45 }
	end, {})

	local v45 = useMemo(function()
		local signal, v46 = Signals.createSignal(false)
		return { get = signal, set = v46 }
	end, {})
	local v46 = useSignalState(v45.get)

	if FFlagMomentsTextOverlayDragToDeleteRefinement then
		useEffect(function()
			v45.set(false)
		end, { v15, v45 })
	end

	local v47 = useMemo(function()
		return {
			getItemSize = v43.getItemSize,
			getItemResolution = v44.getItemResolution,
			setIsOverlayDragging = v45.set
		}
	end, { v43, v44, v45 })

	local v48 = useCallback(function(p2)
		v43.setItemSize(p2.AbsoluteSize)
	end, { v43 })

	local v49 = useCallback(function(p2)
		v44.setItemResolution(p2)
	end, { v44 })

	local v50 = useMemo(function()
		local result = {}

		for k, v51 in v19 do
			if v51.renderPreviewLayer ~= nil then
				result[v51.kind .. "PreviewLayer"] = v51.renderPreviewLayer(v8, v47)
			end
		end

		return result
	end, { v19, v8, v47 })

	local v51 = if v12.enabled then Enum.ScaleType.Fit else Enum.ScaleType.Crop

	local AvatarMomentContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/AvatarMomentContainer")

	local createElement = React.createElement
	local v53 = {
		backgroundStyle = v10.Color.Common.Scrim,
		tag = "position-center-center anchor-center-center size-full-full",
		onActivated = v36,
		stateLayer = v7,
		testId = "moments-creation-background-scrim"
	}

	local createElement2 = React.createElement
	local v56 = {
		tag = {
			["position-center-center anchor-center-center size-full-full bg-surface-0"] = true,
			["radius-large"] = not FFlagMomentsCreationCompactPanelSquareCorners or v11 == formFactor.Wide
		},
		sizeConstraint = 0,
		onActivated = 0,
		stateLayer = 0,
		testId = "moments-creation-panel"
	}

	local v58 = if v11 == formFactor.Wide then Vector2.new(600, 700) else nil
	v56.sizeConstraint = { MaxSize = v58 }

	v56.onActivated = noopActivated
	v56.stateLayer = v7

	local v60 = if GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice then React.createElement(module48) else nil

	local v61 = if (not GetFFlagMomentsTTSAudioOverlay or v15 ~= CreationFlowState.Voice) and not (state > 0) and not (FFlagMomentsTextOverlayDragToDeleteRefinement and v46) and (not FFlagMomentsTextOverlayTopNav or v15 ~= CreationFlowState.TextOverlay) then React.createElement(view, {
		padding = {
			top = UDim.new(0, v9.top + v10.Padding.Medium),
			right = UDim.new(0, v9.right + v10.Padding.Medium)
		},
		tag = "position-top-right anchor-top-right auto-xy",
		ZIndex = GetFFlagMomentsCreationCloseButtonZIndexFix and 10 or nil
	}, {
		CloseButton = React.createElement(
			view,
			{
				LayoutOrder = 1,
				onActivated = v36,
				tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0"
			},
			{
				CloseIcon = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					name = "icons/navigation/close_small",
					size = Foundation.Enums.IconSize.Small,
					style = v10.Color.ActionEmphasis.Foreground,
					ZIndex = 2
				})
			}
		)
	}) else nil

	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v66 = {
		tag = "col align-x-center",
		Size = v24:map(function(p2)
			return UDim2.new(1, 0, 1, -(p2 + state))
		end)
	}

	local createElement5 = React.createElement
	local v69 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v10.Color.None.Transparency
	}
	local v70 = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Custom,
			ShrinkRatio = v16 and 1 or 2
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v10.Radius.Large)
		}),
		ClickCapture = React.createElement(view, {
			tag = "size-full",
			onActivated = v14,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			ZIndex = 0
		}),
		CaptureView = 0,
		AvatarMomentView = 0,
		VoiceTopScrim = 0,
		PreviewMediaOverlay = 0,
		EditCTABar = 0
	}

	local v71 = if v17 == nil then React.createElement(module35, {
		preview = v8.preview,
		scaleType = v51,
		onAbsoluteSizeChanged = v48,
		onResolutionChanged = v49,
		ttsAudio = v8.ttsAudio
	}, v50) else nil
	v70.CaptureView = v71

	local v72 = if v17 ~= nil then React.createElement(AvatarMomentContainer, {
		preview = v8.preview,
		avatarMoment = v17,
		onAbsoluteSizeChanged = v48,
		onResolutionChanged = v49,
		ttsAudio = v8.ttsAudio
	}, v50) else nil
	v70.AvatarMomentView = v72

	local v73 = if GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice then React.createElement(gradientBackdrop, {
		color3 = v10.Color.Common.Scrim.Color3,
		rotation = 90,
		size = UDim2.new(1, 0, 0.25, 0),
		zIndex = 2
	}) else nil
	v70.VoiceTopScrim = v73

	local createElement6 = React.createElement

	local createElement7 = React.createElement
	local v78 = {
		padding = {
			bottom = UDim.new(0, v10.Padding.Large),
			left = UDim.new(0, (math.max(v9.left, v10.Padding.Large))),
			right = UDim.new(0, (math.max(v9.right, v10.Padding.Large)))
		},
		tag = "size-full-0 auto-y",
		LayoutOrder = 1
	}
	local v80

	if music and (v15 == CreationFlowState.Preview or v15 == CreationFlowState.Description) and not (FFlagMomentsTextOverlayDragToDeleteRefinement and v46) then
		local createElement8 = React.createElement

		local createElement9 = React.createElement
		local v85 = { musicAssetId = music.assetId, onActivated = v32, onRemove = 0 }

		if not FFlagMomentsCreationMusicChipRemoveButton then
			v33 = nil
		end

		v85.onRemove = v33
		v80 = createElement8(view, {
			tag = "position-bottom-left anchor-bottom-left auto-xy"
		}, {
			MusicChip = createElement9(module52, v85)
		})
	end

	local v76 = {
		OtherControls = createElement7(view, v78, { MusicIndicator = v80 }),
		PlaybackControls = 0
	}
	local v81

	if
		v16
		and v16.CaptureType == Enum.CaptureType.Video
		and (v15 == CreationFlowState.Gallery or v15 == CreationFlowState.Preview or GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice)
		and (v13 or GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice)
		and not v46
	then
		v81 = React.createElement(module40, {
			layoutOrder = 2,
			preview = v8.preview,
			toggleFitMode = v12.toggle,
			isFitMode = v12.enabled,
			onSeek = GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice and function(p2)
				local ttsAudio = v8.ttsAudio

				if ttsAudio == nil then
					return
				end

				local timeLength = ttsAudio.getTimeLength(false)

				if timeLength > 0 and p2 >= 0 and p2 < timeLength then
					ttsAudio.seek(p2)
				end
			end or nil
		})
	end

	v76.PlaybackControls = v81
	v70.PreviewMediaOverlay = createElement6(
		view,
		{
			tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
			ZIndex = 5
		},
		v76
	)
	local v82

	if v15 == CreationFlowState.Preview then
		local createElement8 = React.createElement
		local v84 = {
			tools = v19,
			onToolSelected = v31,
			showText = v13,
			zIndex = 4,
			isLoadingMap = v22 and { generateText = true } or nil,
			isDisabledMap = getFFlagEnableMomentTextGeneration() and v22 and {
				text = true
			} or nil,
			onDisabledToolActivated = v8.onDisabledToolActivated,
			hidden = 0,
			coachmark = 0
		}

		if not FFlagMomentsTextOverlayDragToDeleteRefinement then
			v46 = nil
		end

		v84.hidden = v46

		local v85 = if GetFFlagMomentsTTSAudioOverlay and GetFFlagMomentsTTSCoachmark() then require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CreationFlowScreen/makeVoiceCoachmarkConfig")(GetFFlagMomentsTTSAudioOverlay, GetFFlagMomentsTTSCoachmark()) else nil
		v84.coachmark = v85
		v82 = createElement8(module38, v84)
	end

	v70.EditCTABar = v82
	local v67 = {
		PreviewContainer = createElement5("CanvasGroup", v69, v70),
		GalleryView = 0,
		PreviewView = 0,
		ActiveStepEditor = 0,
		DescriptionView = 0
	}
	local v83

	if v15 == CreationFlowState.Gallery then
		if captureSource == nil then
			v83 = React.createElement(module39, {
				captures = v6,
				layoutOrder = 2,
				onCaptureSelected = v27,
				onNextCallback = v28,
				selectedCapture = v16,
				hasMoreCaptures = false,
				onShowMore = nil
			})
		else
			v83 = React.createElement(GallerySourceView, {
				captureSource = captureSource,
				layoutOrder = 2,
				onCaptureSelected = v27,
				onNextCallback = v28,
				selectedCapture = v16
			})
		end
	end

	v67.GalleryView = v83
	local v84

	if v15 == CreationFlowState.Preview then
		local createElement8 = React.createElement

		if props.excludeGallery then
			v34 = nil
		end

		v84 = createElement8(module41, {
			layoutOrder = 2,
			onContinueCallback = v29,
			onReturnToGalleryCallback = v34
		})
	end

	v67.PreviewView = v84

	v67.ActiveStepEditor = v42("Step")
	local v85

	if v15 == CreationFlowState.Description then
		local createElement8 = React.createElement

		if not fFlagMomentsRenderCreatePostStatus then
			v23 = nil
		end

		v85 = createElement8(module37, {
			layoutOrder = 2,
			isPublishing = v23,
			onPublish = v35,
			onReturnToEditing = v30
		})
	end

	v67.DescriptionView = v85
	local v64 = { MainView = createElement4(view, v66, v67), MusicView = 0 }

	local v86 = if FFlagMomentsCreationMusicEditorRedesign then React.createElement(DockedEditorContext.Provider, {
		value = v26
	}, {
		MusicView = v42("Overlay")
	}) else v42("Overlay")
	v64.MusicView = v86
	local element = createElement(view, v53, {
		CreationFlowView = createElement2(view, v56, {
			VoiceBackControls = v60,
			CloseButtonContainer = v61,
			MainViewContainer = createElement3(view, {
				tag = "size-full",
				ZIndex = GetFFlagMomentsCreationCloseButtonZIndexFix and 1 or nil,
				onAbsoluteSizeChanged = v25
			}, v64)
		}),
		Modal = v41()
	})

	return React.createElement(
		CreationMediaProvider,
		{ preview = v8.preview, getSelectedCapture = v8.getSelectedCapture },
		element
	)
end

local function CreationFlowScreen(props)
	local onExit = props.onExit
	local host = props.host
	local captureSource = props.captureSource
	local canDismissCreationFlow = if fFlagMomentsRenderCreatePostStatus then props.canDismissCreationFlow else nil
	local ref

	if fFlagMomentsRenderCreatePostStatus then
		ref = React.useRef(props.onPublishFinished)
		ref.current = props.onPublishFinished
	else
		ref = nil
	end

	local function fn()
		if host ~= nil then
			return host
		end

		return {
			exitCreationFlow = onExit,
			canDismissCreationFlow = if fFlagMomentsRenderCreatePostStatus then canDismissCreationFlow else nil,
			onPublishFinished = fFlagMomentsRenderCreatePostStatus and function(p2)
				local current = ref.current

				if current ~= nil then
					current(p2)
				end
			end or nil,
			captureSource = captureSource,
			isTextFiltered = module51,
			createMoment = v5 and function(p2, p3, p4)
				print(`[moments-creation] dev publish (not uploaded): "{p4}"`)
			end or publishMoment
		}
	end

	local v10 = React.useMemo(fn, {
		host,
		onExit,
		captureSource,
		if fFlagMomentsRenderCreatePostStatus then canDismissCreationFlow else nil
	})

	local createElement = React.createElement
	local v12 = { colorMode = colorMode.Dark }

	local createElement2 = React.createElement
	local v15 = {
		host = v10,
		excludeGallery = props.excludeGallery,
		initialAvatarMoment = 0
	}
	local v16 = if fFlagMomentsCreateAvatarPosts then props.initialAvatarMoment else nil
	v15.initialAvatarMoment = v16
	return createElement(foundationProvider, v12, {
		Root = createElement2(creationControllerProvider, v15, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = props.excludeGallery,
				captureSource = v10.captureSource,
				disableDrafts = v10.disableDrafts,
				disableExperimentExposure = v10.disableExperimentExposure
			})
		})
	})
end

return CreationFlowScreen
