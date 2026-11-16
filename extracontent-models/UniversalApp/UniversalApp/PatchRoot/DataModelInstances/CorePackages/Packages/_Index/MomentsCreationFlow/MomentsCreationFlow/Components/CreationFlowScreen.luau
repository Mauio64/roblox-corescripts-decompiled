local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Icon = Foundation.Icon
local View = Foundation.View

local CaptureView = require(MomentsCreationFlow.Components.CaptureView)
local DescriptionView = require(MomentsCreationFlow.Components.DescriptionView)
local EditCTABar = require(MomentsCreationFlow.Components.EditCTABar)
local GalleryView = require(MomentsCreationFlow.Components.GalleryView)
local MusicChip = require(MomentsCreationFlow.Components.MusicChip)
local MusicOverlay = require(MomentsCreationFlow.Components.MusicOverlay)
local PlaybackControls = require(MomentsCreationFlow.Components.PlaybackControls)
local PreviewView = require(MomentsCreationFlow.Components.PreviewView)
local TextOverlayDisplay = MomentsCommon.TextOverlayDisplay
local ExitConfirmationDialog = require(MomentsCreationFlow.Components.Dialogs.ExitConfirmationDialog)
local TextFilteredDialog = require(MomentsCreationFlow.Components.Dialogs.TextFilteredDialog)
local TextOverlayEditor = require(MomentsCreationFlow.Components.TextOverlay.TextOverlayEditor)
local TextOverlayView = require(MomentsCreationFlow.Components.TextOverlay.TextOverlayView)
local TrimmingView = require(MomentsCreationFlow.Components.TrimmingView)

local ClearEdits = require(MomentsCreationFlow.Actions.ClearEdits)
local CreationFlowStateUpdated = require(MomentsCreationFlow.Actions.CreationFlowStateUpdated)
local MusicEditUpdated = require(MomentsCreationFlow.Actions.MusicEditUpdated)
local SelectedCaptureUpdated = require(MomentsCreationFlow.Actions.SelectedCaptureUpdated)
local TextOverlayEditsUpdated = require(MomentsCreationFlow.Actions.TextOverlayEditsUpdated)
local TrimEditUpdated = require(MomentsCreationFlow.Actions.TrimEditUpdated)

local useAutoDismissState = require(MomentsCreationFlow.Hooks.useAutoDismissState)
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useDispatch = MomentsCommon.Hooks.useDispatch
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useMemo = React.useMemo
local useRef = React.useRef
local useSelector = MomentsCommon.Hooks.useSelector
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens
local useUnifiedPlayback = MomentsCommon.Hooks.useUnifiedPlayback

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)

local getContentFromCapture = require(MomentsCreationFlow.Utils.getContentFromCapture)
local makeMomentMetadata = require(MomentsCreationFlow.Utils.makeMomentMetadata)
local makeRegistrationInfo = require(MomentsCreationFlow.Utils.makeRegistrationInfo)

local CreationFlowState = require(MomentsCreationFlow.Enums.CreationFlowState)
local DialogType = require(MomentsCreationFlow.Enums.DialogType)
local FormFactor = MomentsCommon.Enums.FormFactor

local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local EventNames = require(MomentsCreationFlow.Analytics.EventNames)

local v = {
	position = UDim2.fromScale(0.5, 0.5),
	rotation = 0,
	scale = 1,
	text = "",
	textOverlayStyle = {
		font = Enum.Font.BuilderSansMedium,
		fontColor = Color3.new(0, 0, 0),
		fontSize = 16,
		textXAlignment = Enum.TextXAlignment.Center
	},
	zIndex = 1
}

return function(p)
	local v2 = useDispatch()
	local v3 = useDeviceInsets()
	local v4 = useTokens()
	local v5 = useFormFactor()
	local v6 = useToggleState(false)
	local showText, onActivated = useAutoDismissState()
	local v7 = React.useContext(CreationFlowContext)

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))
	local state3, setState3 = React.useState({ modalType = nil, modalProps = nil })

	local onAbsoluteSizeChanged = useCallback(function(p2)
		setState2(p2.AbsoluteSize)
	end, {})

	local captures = v7.captures

	local v8 = useRef(0)

	local editFlowState = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.currentState
	end)

	local v9 = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.capture
	end)

	local v10 = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.textOverlayEdits
	end)

	local trim = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.trimEdit
	end)

	local music = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.musicEdit
	end)

	local v11 = useSelector(function(p2)
		return p2[Constants.RoduxKey].CreationFlow.description
	end)

	local state4, setState4 = React.useState(nil)
	local state5, setState5 = React.useState(nil)
	local state6, setState6 = React.useState(nil)

	local v12 = useMemo(function()
		return state6 or music
	end, { state6, music })

	local v13 = useMemo(function()
		return state5 or trim
	end, { state5, trim })
	local content

	if v9 then
		content = getContentFromCapture(v9)
	end

	local captureType

	if v9 then
		captureType = v9.CaptureType
	end

	local playbackController = useUnifiedPlayback(true, {
		autoplay = true,
		edits = { trim = v13, music = v12 },
		looping = true,
		content = content,
		captureType = captureType
	})

	local onNextCallback = useCallback(function()
		v7.fireEvent(EventNames.EditingFlowNextButtonPressed, { editFlowState = editFlowState })

		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		onActivated()
		v7.fireEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed)
	end, { onActivated, editFlowState })

	local onContinueCallback = useCallback(function()
		v7.fireEvent(EventNames.EditingFlowNextButtonPressed, { editFlowState = editFlowState })

		v2(CreationFlowStateUpdated(CreationFlowState.Description))
		v6.disable()

		v7.fireEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)
	end, { editFlowState })

	local v14 = useCallback(function(p2: string)
		local textFiltered = v7.isTextFiltered(p2)

		if textFiltered then
			setState3({
				modalType = DialogType.TextFiltered,
				modalProps = {
					onConfirm = function()
						setState3(nil)
					end
				}
			})
		end

		return textFiltered
	end, {})

	local onPublish = useCallback(function()
		if v14(v11) then
			return
		end

		local now = os.clock()

		if now - v8.current < 0.5 then
			return
		end

		v8.current = now

		local momentMetadata = makeMomentMetadata(v9, v11, {
			trim = trim,
			music = music,
			textOverlays = v10
		})
		local registrationInfo = makeRegistrationInfo(v9, momentMetadata)

		v7.createMoment(v9, momentMetadata, registrationInfo)

		if p.excludeGallery then
			v2(ClearEdits(CreationFlowState.Preview))
		else
			v2(ClearEdits(CreationFlowState.Gallery))
		end

		v7.fireEvent(EventNames.MomentsEditingFlowPublished)

		v7.exitCreationFlow()
	end, { v9, v11, music, v7, v10, trim, p.excludeGallery })

	local onReturnToEditing = useCallback(function()
		v7.fireEvent(EventNames.EditingFlowReturnButtonPressed, { editFlowState = editFlowState })

		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
	end, { editFlowState })

	local onReturnToGalleryCallback = useCallback(function()
		v7.fireEvent(EventNames.EditingFlowReturnButtonPressed, { editFlowState = editFlowState })

		local function onExitCreation()
			setState3(nil)
			v2(ClearEdits(CreationFlowState.Gallery))
			v6.disable()
		end

		setState3({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = function()
					setState3(nil)
				end,
				onConfirm = onExitCreation
			}
		})
	end, { editFlowState })

	local onTrimDiscard = useCallback(function()
		setState5(nil)
		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowTrimBackButtonPressed)
	end, { v7 })

	local onTrimSave = useCallback(function()
		v2(TrimEditUpdated(state5))
		setState5(nil)
		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowTrimDoneButtonPressed)
	end, { state5, v7 })

	local onTrimUpdate = useCallback(function(p2)
		setState5(p2)
	end, {})

	local onMusicDiscard = useCallback(function()
		setState6(nil)
		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowMusicBackButtonPressed)
	end, {})

	local onMusicSave = useCallback(function()
		v2(MusicEditUpdated(state6))
		setState6(nil)
		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowMusicDoneButtonPressed)
	end, { state6 })

	local onMusicUpdate = useCallback(function(p2)
		setState6(p2)
	end, {})

	local onTextOverlayDiscard = useCallback(function()
		setState4(nil)
		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowTextOverlayBackButtonPressed)
	end, { state4, v7 })

	local onTextOverlaySave = useCallback(function()
		local text = state4 and state4[1] and state4[1].text

		if text == "" then
			v2(TextOverlayEditsUpdated(nil))
		elseif v14(text) then
			return
		else
			v2(TextOverlayEditsUpdated(state4))
		end

		v2(CreationFlowStateUpdated(CreationFlowState.Preview))
		v7.fireEvent(EventNames.EditingFlowTextOverlayDoneButtonPressed)
		setState4(nil)
	end, { state4, v7, v14 })

	local onTextOverlayUpdated = useCallback(function(p2)
		setState4(p2)
	end, {})

	local onTextOverlayDragEnd = useCallback(function(p2)
		v2(TextOverlayEditsUpdated(p2))
	end, {})

	local onTextOverlayActivated = useCallback(function()
		setState4(v10)
		v2(CreationFlowStateUpdated(CreationFlowState.TextOverlay))
	end, { v10 })

	React.useEffect(function()
		if editFlowState == CreationFlowState.TextOverlay then
			setState4(v10 or { v })
		end
	end, { v10, editFlowState })

	local onActivated2 = useCallback(function()
		v2(CreationFlowStateUpdated(CreationFlowState.Music))
		v7.fireEvent(EventNames.EditingFlowMusicButtonPressed)
	end, {})

	local onCaptureSelected = useCallback(function(p2)
		v2(SelectedCaptureUpdated(p2))
		onActivated()
		v7.fireEvent(EventNames.EditingFlowGalleryItemSelected)
	end, { onActivated, v7 })

	local onRenderFailed = React.useCallback(function()
		return (React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
		}, {
			ModeratedText = React.createElement("TextLabel", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Text = v7.getLocalization(CreationFlowLocalization.PostRemovedTitle),
				TextColor3 = v4.Color.Extended.White.White_70
			})
		}))
	end, {})

	local onActivated3 = useCallback(function()
		local function onExitCreation()
			v7.fireEvent(EventNames.MomentsEditingFlowExited)
			setState3(nil)

			if p.excludeGallery then
				v2(ClearEdits(CreationFlowState.Preview))
			else
				v2(ClearEdits(CreationFlowState.Gallery))
			end

			v7.exitCreationFlow()
		end

		if v9 then
			setState3({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = function()
						setState3(nil)
					end,
					onConfirm = onExitCreation
				}
			})
		else
			onExitCreation()
		end
	end, { v9, v7, p.excludeGallery })

	React.useEffect(function()
		v7.setScreenOrientation(Enum.ScreenOrientation.Portrait)

		return function()
			v7.setScreenOrientation(Enum.ScreenOrientation.Sensor)
		end
	end, {})

	React.useEffect(function()
		if
			editFlowState == CreationFlowState.Gallery
			or editFlowState == CreationFlowState.Music
			or editFlowState == CreationFlowState.Description
		then
			v6.disable()
		end
	end, { editFlowState })

	local v15 = React.useCallback(function()
		if not state3 then
			return nil
		end

		if state3.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, state3.modalProps)
		end

		if state3.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, state3.modalProps)
		end

		return nil
	end, { state3 })

	local createElement = React.createElement
	local v16 = {
		backgroundStyle = v4.Color.Common.Scrim,
		tag = "anchor-center-center position-center-center size-full-full"
	}

	local createElement2 = React.createElement
	local maxSize

	if v5 == FormFactor.Wide then
		maxSize = Vector2.new(600, 700)
	end

	local v17 = {
		CloseButtonContainer = React.createElement(View, {
			tag = "auto-xy anchor-top-right position-top-right"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v3.top + v4.Padding.Medium),
				PaddingRight = UDim.new(0, v3.right + v4.Padding.Medium)
			}),
			CloseButton = React.createElement(
				View,
				{
					LayoutOrder = 1,
					onActivated = onActivated3,
					tag = "size-1100-1100 bg-over-media-0 padding-medium radius-circle"
				},
				{
					CloseIcon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						name = "icons/navigation/close_small",
						size = Foundation.Enums.IconSize.Small,
						style = v4.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				}
			)
		}),
		MainViewContainer = 0
	}

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local createElement5 = React.createElement
	local v18 = {
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = v4.Color.None.Transparency
	}
	local children = {
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.Custom,
			ShrinkRatio = v9 and 1 or 2
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v4.Radius.Large) }),
		ClickCapture = React.createElement(View, {
			tag = "size-full",
			onActivated = onActivated,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			ZIndex = 0
		}),
		PreviewMediaOverlay = 0,
		TextOverlayEditor = 0,
		CaptureView = 0,
		EditCTABar = 0
	}

	local createElement6 = React.createElement

	local createElement7 = React.createElement

	local v19 = {
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, (math.max(v3.right, v4.Padding.Large))),
			PaddingRight = UDim.new(0, (math.max(v3.right, v4.Padding.Large)))
		}),
		MusicIndicator = 0
	}
	local musicIndicator

	if music and (editFlowState == CreationFlowState.Preview or editFlowState == CreationFlowState.Description) then
		musicIndicator = React.createElement(View, {
			tag = "anchor-bottom-left auto-xy position-bottom-left"
		}, {
			MusicChip = React.createElement(MusicChip, {
				musicAssetId = music.assetId,
				onActivated = onActivated2
			})
		})
	end

	v19.MusicIndicator = musicIndicator
	local v20 = {
		OtherControls = createElement7(
			View,
			{ tag = "auto-y padding-x-large padding-bottom-large size-full-0", LayoutOrder = 1 },
			v19
		),
		PlaybackControls = 0
	}
	local playbackControls

	if
		v9
		and v9.CaptureType == Enum.CaptureType.Video
		and showText
		and (editFlowState == CreationFlowState.Gallery or editFlowState == CreationFlowState.Preview)
	then
		playbackControls = React.createElement(PlaybackControls, {
			layoutOrder = 2,
			playbackController = playbackController,
			toggleFitMode = v6.toggle,
			isFitMode = v6.enabled
		})
	end

	v20.PlaybackControls = playbackControls
	children.PreviewMediaOverlay = createElement6(
		View,
		{ tag = "auto-y anchor-bottom-center col position-bottom-center size-full-0", ZIndex = 5 },
		v20
	)
	local textOverlayEditor

	if editFlowState == CreationFlowState.TextOverlay then
		textOverlayEditor = React.createElement(TextOverlayEditor, {
			layoutOrder = 2,
			onTextOverlayDiscard = onTextOverlayDiscard,
			onTextOverlaySave = onTextOverlaySave,
			onTextOverlayUpdated = onTextOverlayUpdated,
			textOverlayEdits = state4
		})
	end

	children.TextOverlayEditor = textOverlayEditor

	local createElement8 = React.createElement
	local v21 = {
		capture = v9,
		playbackController = playbackController,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		onRenderFailed = onRenderFailed,
		onResolutionChanged = setState,
		scaleType = 0
	}
	local scaleType

	if v6.enabled then
		scaleType = Enum.ScaleType.Fit
	else
		scaleType = Enum.ScaleType.Crop
	end

	v21.scaleType = scaleType

	local createElement9 = React.createElement
	local v22 = {
		draggable = editFlowState == CreationFlowState.Preview,
		editable = editFlowState == CreationFlowState.TextOverlay,
		itemResolution = state,
		itemSize = state2,
		scaleType = 0,
		onTextOverlayActivated = 0,
		onTextOverlayDragEnd = 0,
		textOverlayEdits = 0,
		zIndex = 3
	}
	local scaleType2

	if v6.enabled then
		scaleType2 = Enum.ScaleType.Fit
	else
		scaleType2 = Enum.ScaleType.Crop
	end

	v22.scaleType = scaleType2
	v22.onTextOverlayActivated = onTextOverlayActivated
	v22.onTextOverlayDragEnd = onTextOverlayDragEnd
	v22.textOverlayEdits = v10
	children.CaptureView = createElement8(CaptureView, v21, {
		TextOverlayDisplay = createElement9(TextOverlayDisplay, v22)
	})
	local editCTABar

	if editFlowState == CreationFlowState.Preview then
		local createElement10 = React.createElement
		local captureType2

		if v9 then
			captureType2 = v9.CaptureType
		end

		editCTABar = createElement10(EditCTABar, {
			captureType = captureType2,
			showText = showText,
			zIndex = 4
		})
	end

	children.EditCTABar = editCTABar
	local v23 = {
		PreviewContainer = createElement5("CanvasGroup", v18, children),
		GalleryView = 0,
		PreviewView = 0,
		TrimmingView = 0,
		TextOverlayView = 0,
		DescriptionView = 0
	}
	local galleryView

	if editFlowState == CreationFlowState.Gallery then
		galleryView = React.createElement(GalleryView, {
			layoutOrder = 2,
			captures = captures,
			selectedCapture = v9,
			onCaptureSelected = onCaptureSelected,
			onNextCallback = onNextCallback
		})
	end

	v23.GalleryView = galleryView
	local previewView

	if editFlowState == CreationFlowState.Preview then
		local createElement10 = React.createElement

		if p.excludeGallery then
			onReturnToGalleryCallback = nil
		end

		previewView = createElement10(PreviewView, {
			layoutOrder = 2,
			onContinueCallback = onContinueCallback,
			onReturnToGalleryCallback = onReturnToGalleryCallback
		})
	end

	v23.PreviewView = previewView
	local trimmingView

	if editFlowState == CreationFlowState.Trimming then
		trimmingView = React.createElement(TrimmingView, {
			layoutOrder = 2,
			playbackController = playbackController,
			onTrimDiscard = onTrimDiscard,
			onTrimSave = onTrimSave,
			onTrimUpdate = onTrimUpdate,
			selectedCapture = v9,
			trimEdit = v13
		})
	end

	v23.TrimmingView = trimmingView
	local textOverlayView

	if editFlowState == CreationFlowState.TextOverlay then
		textOverlayView = React.createElement(TextOverlayView, {
			layoutOrder = 2,
			onTextOverlayDiscard = onTextOverlayDiscard,
			onTextOverlaySave = onTextOverlaySave
		})
	end

	v23.TextOverlayView = textOverlayView
	local descriptionView

	if editFlowState == CreationFlowState.Description then
		descriptionView = React.createElement(DescriptionView, {
			layoutOrder = 2,
			onPublish = onPublish,
			onReturnToEditing = onReturnToEditing
		})
	end

	v23.DescriptionView = descriptionView
	local v24 = {
		MainView = createElement4(View, { tag = "size-full col align-x-center" }, v23),
		MusicView = 0
	}
	local musicView

	if editFlowState == CreationFlowState.Music then
		musicView = React.createElement(View, { Size = UDim2.fromScale(1, 1), LayoutOrder = 2 }, {
			MusicOverlay = React.createElement(MusicOverlay, {
				musicEdit = v12,
				playbackController = playbackController,
				onMusicDiscard = onMusicDiscard,
				onMusicSave = onMusicSave,
				onMusicUpdate = onMusicUpdate
			})
		})
	end

	v24.MusicView = musicView
	v17.MainViewContainer = createElement3(View, { tag = "size-full" }, v24)
	return createElement(View, v16, {
		CreationFlowView = createElement2(View, {
			tag = "anchor-center-center bg-surface-0 position-center-center radius-large size-full-full",
			sizeConstraint = { MaxSize = maxSize }
		}, v17),
		Modal = v15()
	})
end
