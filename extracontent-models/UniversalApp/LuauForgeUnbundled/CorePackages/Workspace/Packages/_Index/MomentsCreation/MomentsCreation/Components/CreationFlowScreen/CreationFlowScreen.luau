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

	local v38 = useCallback(function()
		if not (v21 and v21.modalType) then
			return nil
		end

		if v21.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v21.modalProps)
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
	end, { v21 })

	local v39 = useCallback(function(p2)
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

	local v40 = useMemo(function()
		local signal, v41 = Signals.createSignal(Vector2.zero)
		return { getItemSize = signal, setItemSize = v41 }
	end, {})

	local v41 = useMemo(function()
		local signal, v42 = Signals.createSignal(Vector2.zero)
		return { getItemResolution = signal, setItemResolution = v42 }
	end, {})

	local v42 = useMemo(function()
		local signal, v43 = Signals.createSignal(false)
		return { get = signal, set = v43 }
	end, {})
	local v43 = useSignalState(v42.get)

	if FFlagMomentsTextOverlayDragToDeleteRefinement then
		useEffect(function()
			v42.set(false)
		end, { v15, v42 })
	end

	local v44 = useMemo(function()
		return {
			getItemSize = v40.getItemSize,
			getItemResolution = v41.getItemResolution,
			setIsOverlayDragging = v42.set
		}
	end, { v40, v41, v42 })

	local v45 = useCallback(function(p2)
		v40.setItemSize(p2.AbsoluteSize)
	end, { v40 })

	local v46 = useCallback(function(p2)
		v41.setItemResolution(p2)
	end, { v41 })

	local v47 = useMemo(function()
		local result = {}

		for k, v48 in v19 do
			if v48.renderPreviewLayer ~= nil then
				result[v48.kind .. "PreviewLayer"] = v48.renderPreviewLayer(v8, v44)
			end
		end

		return result
	end, { v19, v8, v44 })

	local v48 = if v12.enabled then Enum.ScaleType.Fit else Enum.ScaleType.Crop

	local AvatarMomentContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment/AvatarMomentContainer")

	local createElement = React.createElement
	local v50 = {
		backgroundStyle = v10.Color.Common.Scrim,
		tag = "position-center-center anchor-center-center size-full-full",
		onActivated = v36,
		stateLayer = v7,
		testId = "moments-creation-background-scrim"
	}

	local createElement2 = React.createElement
	local v53 = {
		tag = {
			["position-center-center anchor-center-center size-full-full bg-surface-0"] = true,
			["radius-large"] = not FFlagMomentsCreationCompactPanelSquareCorners or v11 == formFactor.Wide
		},
		sizeConstraint = 0,
		onActivated = 0,
		stateLayer = 0,
		testId = "moments-creation-panel"
	}

	local v55 = if v11 == formFactor.Wide then Vector2.new(600, 700) else nil
	v53.sizeConstraint = { MaxSize = v55 }

	v53.onActivated = noopActivated
	v53.stateLayer = v7

	local v57 = if GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice then React.createElement(module48) else nil

	local v58 = if (not GetFFlagMomentsTTSAudioOverlay or v15 ~= CreationFlowState.Voice) and not (state > 0) and not (FFlagMomentsTextOverlayDragToDeleteRefinement and v43) and (not FFlagMomentsTextOverlayTopNav or v15 ~= CreationFlowState.TextOverlay) then React.createElement(view, {
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
	local v63 = {
		tag = "col align-x-center",
		Size = v24:map(function(p2)
			return UDim2.new(1, 0, 1, -(p2 + state))
		end)
	}

	local createElement5 = React.createElement
	local v66 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v10.Color.None.Transparency
	}
	local v67 = {
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

	local v68 = if v17 == nil then React.createElement(module35, {
		preview = v8.preview,
		scaleType = v48,
		onAbsoluteSizeChanged = v45,
		onResolutionChanged = v46,
		ttsAudio = v8.ttsAudio
	}, v47) else nil
	v67.CaptureView = v68

	local v69 = if v17 ~= nil then React.createElement(AvatarMomentContainer, {
		preview = v8.preview,
		avatarMoment = v17,
		onAbsoluteSizeChanged = v45,
		onResolutionChanged = v46,
		ttsAudio = v8.ttsAudio
	}, v47) else nil
	v67.AvatarMomentView = v69

	local v70 = if GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice then React.createElement(gradientBackdrop, {
		color3 = v10.Color.Common.Scrim.Color3,
		rotation = 90,
		size = UDim2.new(1, 0, 0.25, 0),
		zIndex = 2
	}) else nil
	v67.VoiceTopScrim = v70

	local createElement6 = React.createElement

	local createElement7 = React.createElement
	local v75 = {
		padding = {
			bottom = UDim.new(0, v10.Padding.Large),
			left = UDim.new(0, (math.max(v9.left, v10.Padding.Large))),
			right = UDim.new(0, (math.max(v9.right, v10.Padding.Large)))
		},
		tag = "size-full-0 auto-y",
		LayoutOrder = 1
	}
	local v77

	if music and (v15 == CreationFlowState.Preview or v15 == CreationFlowState.Description) and not (FFlagMomentsTextOverlayDragToDeleteRefinement and v43) then
		local createElement8 = React.createElement

		local createElement9 = React.createElement
		local v82 = { musicAssetId = music.assetId, onActivated = v32, onRemove = 0 }

		if not FFlagMomentsCreationMusicChipRemoveButton then
			v33 = nil
		end

		v82.onRemove = v33
		v77 = createElement8(view, {
			tag = "position-bottom-left anchor-bottom-left auto-xy"
		}, {
			MusicChip = createElement9(module52, v82)
		})
	end

	local v73 = {
		OtherControls = createElement7(view, v75, { MusicIndicator = v77 }),
		PlaybackControls = 0
	}
	local v78

	if
		v16
		and v16.CaptureType == Enum.CaptureType.Video
		and (v15 == CreationFlowState.Gallery or v15 == CreationFlowState.Preview or GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice)
		and (v13 or GetFFlagMomentsTTSAudioOverlay and v15 == CreationFlowState.Voice)
		and not v43
	then
		v78 = React.createElement(module40, {
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

	v73.PlaybackControls = v78
	v67.PreviewMediaOverlay = createElement6(
		view,
		{
			tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
			ZIndex = 5
		},
		v73
	)
	local v79

	if v15 == CreationFlowState.Preview then
		local createElement8 = React.createElement
		local v81 = {
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
			v43 = nil
		end

		v81.hidden = v43

		local v82 = if GetFFlagMomentsTTSAudioOverlay and GetFFlagMomentsTTSCoachmark() then require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/CreationFlowScreen/makeVoiceCoachmarkConfig")(GetFFlagMomentsTTSAudioOverlay, GetFFlagMomentsTTSCoachmark()) else nil
		v81.coachmark = v82
		v79 = createElement8(module38, v81)
	end

	v67.EditCTABar = v79
	local v64 = {
		PreviewContainer = createElement5("CanvasGroup", v66, v67),
		GalleryView = 0,
		PreviewView = 0,
		ActiveStepEditor = 0,
		DescriptionView = 0
	}
	local v80

	if v15 == CreationFlowState.Gallery then
		if captureSource == nil then
			v80 = React.createElement(module39, {
				captures = v6,
				layoutOrder = 2,
				onCaptureSelected = v27,
				onNextCallback = v28,
				selectedCapture = v16,
				hasMoreCaptures = false,
				onShowMore = nil
			})
		else
			v80 = React.createElement(GallerySourceView, {
				captureSource = captureSource,
				layoutOrder = 2,
				onCaptureSelected = v27,
				onNextCallback = v28,
				selectedCapture = v16
			})
		end
	end

	v64.GalleryView = v80
	local v81

	if v15 == CreationFlowState.Preview then
		local createElement8 = React.createElement

		if props.excludeGallery then
			v34 = nil
		end

		v81 = createElement8(module41, {
			layoutOrder = 2,
			onContinueCallback = v29,
			onReturnToGalleryCallback = v34
		})
	end

	v64.PreviewView = v81

	v64.ActiveStepEditor = v39("Step")
	local v82

	if v15 == CreationFlowState.Description then
		local createElement8 = React.createElement

		if not fFlagMomentsRenderCreatePostStatus then
			v23 = nil
		end

		v82 = createElement8(module37, {
			layoutOrder = 2,
			isPublishing = v23,
			onPublish = v35,
			onReturnToEditing = v30
		})
	end

	v64.DescriptionView = v82
	local v61 = { MainView = createElement4(view, v63, v64), MusicView = 0 }

	local v83 = if FFlagMomentsCreationMusicEditorRedesign then React.createElement(DockedEditorContext.Provider, {
		value = v26
	}, {
		MusicView = v39("Overlay")
	}) else v39("Overlay")
	v61.MusicView = v83
	local element = createElement(view, v50, {
		CreationFlowView = createElement2(view, v53, {
			VoiceBackControls = v57,
			CloseButtonContainer = v58,
			MainViewContainer = createElement3(view, {
				tag = "size-full",
				ZIndex = GetFFlagMomentsCreationCloseButtonZIndexFix and 1 or nil,
				onAbsoluteSizeChanged = v25
			}, v61)
		}),
		Modal = v38()
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
	local ref

	if fFlagMomentsRenderCreatePostStatus then
		ref = React.useRef(props.onPublishFinished)
		ref.current = props.onPublishFinished
	else
		ref = nil
	end

	local v8 = React.useMemo(function()
		if host == nil then
			return {
				exitCreationFlow = onExit,
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

		return host
	end, { host, onExit, captureSource })

	local createElement = React.createElement
	local v10 = { colorMode = colorMode.Dark }

	local createElement2 = React.createElement
	local v13 = {
		host = v8,
		excludeGallery = props.excludeGallery,
		initialAvatarMoment = 0
	}
	local v14 = if fFlagMomentsCreateAvatarPosts then props.initialAvatarMoment else nil
	v13.initialAvatarMoment = v14
	return createElement(foundationProvider, v10, {
		Root = createElement2(creationControllerProvider, v13, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = props.excludeGallery,
				captureSource = v8.captureSource,
				disableDrafts = v8.disableDrafts,
				disableExperimentExposure = v8.disableExperimentExposure
			})
		})
	})
end

return CreationFlowScreen
