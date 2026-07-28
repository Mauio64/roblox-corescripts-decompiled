local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Cryo = require(MomentsCreationParent.Cryo)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local FoundationProvider = Foundation.FoundationProvider
local Icon = Foundation.Icon
local View = Foundation.View
local Theme = Foundation.Enums.Theme
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useFormFactor = MomentsCommon.Hooks.useFormFactor
local useToggleState = MomentsCommon.Hooks.useToggleState
local FormFactor = MomentsCommon.Enums.FormFactor
local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local GetFFlagMomentsAnalyticsProducerPrereqs = MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs
local useSignalState = SignalsReact.useSignalState
local CreationController = require(MomentsCreation.CreationController)
local CreationControllerProvider = CreationController.CreationControllerProvider
local useCreationController = CreationController.useCreationController
local useAutoDismissState = require(MomentsCreation.Hooks.useAutoDismissState)
local useDescriptionKeyboardInset = require(MomentsCreation.Hooks.useDescriptionKeyboardInset)
local GetFFlagMomentsDescriptionKeyboardAvoidance = require(MomentsCreation.Flags.GetFFlagMomentsDescriptionKeyboardAvoidance)
local GetFFlagMomentsDescriptionKeyboardAvoidanceFix = require(MomentsCreation.Flags.GetFFlagMomentsDescriptionKeyboardAvoidanceFix)
local GetFFlagMomentsCreationBlockBackgroundInteraction = require(MomentsCreation.Flags.GetFFlagMomentsCreationBlockBackgroundInteraction)
local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagMomentsCreationTextOverlayResolutionScale = require(MomentsCreation.Flags.GetFFlagMomentsCreationTextOverlayResolutionScale)
local StepStub = require(script.Parent.StepStub)
local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local DialogType = require(MomentsCreation.Enums.DialogType)

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
local sampleCaptures = require(MomentsCreation.Capture.sampleCaptures)
local publishMoment = require(MomentsCreation.Upload.publishMoment)
local isTextFiltered = require(MomentsCreation.Moderation.isTextFiltered)
local MusicChip = require(MomentsCreation.Components.MusicChip)
local v55 = require(MomentsCreationParent.MomentsCommon.isStudio)()
local v56 = if not v55 then {} else sampleCaptures

local function noopActivated() -- line: 108
end

local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function GallerySourceView(t2: {[any]: any}) -- line: 115
	-- upvalues: useSignalState (copy), React (copy), GalleryView (copy)
	local captureSource = t2.captureSource
	local v64 = useSignalState(captureSource.getCaptures)
	local v65 = useSignalState(captureSource.getIsFinished)

	return React.createElement(GalleryView, {
		captures = v64,
		layoutOrder = t2.layoutOrder,
		onCaptureSelected = t2.onCaptureSelected,
		onNextCallback = t2.onNextCallback,
		selectedCapture = t2.selectedCapture,
		hasMoreCaptures = not v65,
		onShowMore = captureSource.fetchMore
	})
end
local function CreationFlowContent(p1) -- line: 137
	-- upvalues: useCreationController (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), useToggleState (copy), useAutoDismissState (copy), useSignalState (copy), useDescriptionKeyboardInset (copy), GetFFlagMomentsDescriptionKeyboardAvoidance (copy), CreationFlowState (copy), useCallback (copy), SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), DialogType (copy), useRef (copy), useEffect (copy), GetFFlagMomentsStickerButton (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy), StepStub (copy), useMemo (copy), Signals (copy), GetFFlagMomentsCreationBlockBackgroundInteraction (copy), View (copy), t1 (copy), FormFactor (copy), noopActivated (copy), Icon (copy), Foundation (copy), GetFFlagMomentsDescriptionKeyboardAvoidanceFix (copy), CaptureView (copy), GetFFlagMomentsCreationTextOverlayResolutionScale (copy), MusicChip (copy), PlaybackControls (copy), EditCTABar (copy), GallerySourceView (copy), GalleryView (copy), v56 (copy), PreviewView (copy), DescriptionView (copy), CreationMediaProvider (copy)
	local v67 = useCreationController()
	local v68 = useDeviceInsets()
	local v69 = useTokens()
	local v70 = useFormFactor()
	local v71 = useToggleState(false)
	local v72, v73 = useAutoDismissState()
	local v74 = useSignalState(v67.getStep)
	local v75 = useSignalState(v67.getSelectedCapture)
	local v76 = useSignalState(v67.getComposedEdits)
	local v77 = useSignalState(v67.getAvailableTools)
	local v78 = useSignalState(v67.getActiveTool)
	local v79 = useSignalState(v67.getActiveModal)
	local v80 = useSignalState(v67.getIsGenerating)
	local music = v76.music
	local v82, v83 = useDescriptionKeyboardInset(GetFFlagMomentsDescriptionKeyboardAvoidance() and v74 == CreationFlowState.Description)
	local captureSource = p1.captureSource
	local v85 = useCallback(function(p2) -- line: 169
		-- upvalues: v67 (copy), v73 (copy)
		v67.selectCapture(p2)
		v73()
	end, {
		v67,
		v73
	})

	local function withCreationSession(t3: {[any]: any}) -- line: 178
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v115 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t3, makeCreationEventFields.makeCreationBaseFields(v115))
	end
	local function flowStepFields() -- line: 188
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy), withCreationSession (copy), makeCreationEventFields (copy), v67 (copy)
		if GetFFlagMomentsAnalyticsProducerPrereqs() then
			return withCreationSession(makeCreationEventFields.makeStepFieldFromState((v67.getStep(false))))
		end

		return {
			step = v67.getStep(false)
		}
	end

	local v88 = useCallback(function() -- line: 198
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v67 (copy), CreationFlowState (copy), v73 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v67.navigate(CreationFlowState.Preview)
		v73()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToEditButtonPressed)))
	end, {
		v67,
		v73
	})
	local v89 = useCallback(function() -- line: 211
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v67 (copy), CreationFlowState (copy), v71 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v67.navigate(CreationFlowState.Description)
		v71.disable()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)))
	end, {
		v67,
		v71.disable
	})
	local v90 = useCallback(function() -- line: 224
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v67 (copy), CreationFlowState (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v67.navigate(CreationFlowState.Preview)
	end, { v67 })
	local v91 = useCallback(function(s1: string) -- line: 229
		-- upvalues: v67 (copy)
		v67.beginTool(s1)
	end, { v67 })
	local v92 = useCallback(function() -- line: 233
		-- upvalues: v67 (copy)
		v67.beginTool("music")
	end, { v67 })
	local v93 = useCallback(function() -- line: 237
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v67 (copy), DialogType (copy), v71 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v67.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v67.dismissModal,
				onConfirm = function() -- line: 243
					-- upvalues: v67 (copy), v71 (copy)
					v67.dismissModal()
					v67.returnToGallery()
					v71.disable()
				end
			}
		})
	end, {
		v67,
		v71.disable
	})
	local v94 = useCallback(function() -- line: 252
		-- upvalues: v67 (copy)
		v67.publish()
	end, { v67 })
	local v95 = useCallback(function() -- line: 256
		-- upvalues: v75 (copy), v67 (copy), DialogType (copy)
		if v75 then
			v67.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = v67.dismissModal,
					onConfirm = v67.exit
				}
			})

			return
		end

		v67.exit()
	end, {
		v67,
		v75
	})
	local v96 = useRef(nil)

	useEffect(function() -- line: 271
		-- upvalues: v96 (copy), v74 (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy), GetFFlagMomentsStickerButton (copy)
		local current = v96.current

		v96.current = v74

		if v74 == CreationFlowState.Gallery then
			fireAnalyticsEvent(EventNames.EditingFlowGalleryPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowGalleryPageAppear)))

			return
		end

		if v74 == CreationFlowState.Preview then
			if current ~= CreationFlowState.Trimming and (current ~= CreationFlowState.Music and (current ~= CreationFlowState.TextOverlay and (not GetFFlagMomentsStickerButton() or current ~= CreationFlowState.StickerOverlay))) then
				fireAnalyticsEvent(EventNames.EditingFlowEditPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowEditPageAppear)))

				return
			end
		elseif v74 == CreationFlowState.Description then
			fireAnalyticsEvent(EventNames.EditingFlowPreviewPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowPreviewPageAppear)))
		end
	end, { v74 })
	useEffect(function() -- line: 303
		-- upvalues: v74 (copy), CreationFlowState (copy), v71 (copy)
		if v74 == CreationFlowState.Gallery or (v74 == CreationFlowState.Music or v74 == CreationFlowState.Description) then
			v71.disable()
		end
	end, {
		v74,
		v71.disable
	})

	local v97 = useCallback(function() -- line: 313
		-- upvalues: v79 (copy), DialogType (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy)
		if not v79 or not v79.modalType then
			return nil
		end

		if v79.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v79.modalProps)
		end

		if v79.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v79.modalProps)
		end

		return nil
	end, { v79 })
	local v98 = useCallback(function(s2: string) -- line: 327
		-- upvalues: v78 (copy), v74 (copy), v67 (copy), React (copy), StepStub (copy)
		if v78 == nil or (s2 ~= v78.presentation or v74 ~= v78.step) then
			return nil
		end

		if v78.renderEditor ~= nil then
			local v119 = v78.renderEditor(v67)

			if v119 ~= nil then
				return v119
			end
		end

		return React.createElement(StepStub(v78.kind), {})
	end, {
		v78,
		v74,
		v67
	})
	local v99 = useMemo(function() -- line: 345
		-- upvalues: Signals (copy)
		local v120, v121 = Signals.createSignal(Vector2.zero)

		return {
			getItemSize = v120,
			setItemSize = v121
		}
	end, {})
	local v100 = useMemo(function() -- line: 353
		-- upvalues: Signals (copy)
		local v122, v123 = Signals.createSignal(Vector2.zero)

		return {
			getItemResolution = v122,
			setItemResolution = v123
		}
	end, {})
	local v101 = useMemo(function() -- line: 358
		-- upvalues: v99 (copy), v100 (copy)
		return {
			getItemSize = v99.getItemSize,
			getItemResolution = v100.getItemResolution
		}
	end, {
		v99,
		v100
	})
	local v102 = useCallback(function(p3) -- line: 362
		-- upvalues: v99 (copy)
		v99.setItemSize(p3.AbsoluteSize)
	end, { v99 })
	local v103 = useCallback(function(vector2: Vector2) -- line: 366
		-- upvalues: v100 (copy)
		v100.setItemResolution(vector2)
	end, { v100 })
	local v104 = useMemo(function() -- line: 370
		-- upvalues: v77 (copy), v67 (copy), v101 (copy)
		local t4 = {}

		for _, v128 in v77 do
			if v128.renderPreviewLayer ~= nil then
				t4[v128.kind .. "PreviewLayer"] = v128.renderPreviewLayer(v67, v101)
			end
		end

		return t4
	end, {
		v77,
		v67,
		v101
	})
	local v105 = if not v71.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit
	local v106 = GetFFlagMomentsCreationBlockBackgroundInteraction()
	local v107 = React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full",
		backgroundStyle = v69.Color.Common.Scrim,
		onActivated = if not v106 then nil else v95,
		stateLayer = if not v106 then nil else t1,
		testId = if not v106 then nil else "moments-creation-background-scrim"
	}, {
		CreationFlowView = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = {
				MaxSize = if v70 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
			},
			onActivated = if not v106 then nil else noopActivated,
			stateLayer = if not v106 then nil else t1,
			testId = if not v106 then nil else "moments-creation-panel"
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "position-top-right anchor-top-right auto-xy",
				padding = {
					top = UDim.new(0, v68.top + v69.Padding.Medium),
					right = UDim.new(0, v68.right + v69.Padding.Medium)
				}
			}, {
				CloseButton = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0",
					onActivated = v95
				}, {
					CloseIcon = React.createElement(Icon, {
						name = "icons/navigation/close_small",
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = Foundation.Enums.IconSize.Small,
						style = v69.Color.ActionEmphasis.Foreground
					})
				})
			}),
			MainViewContainer = React.createElement(View, {
				tag = "size-full",
				onAbsoluteSizeChanged = v83
			}, {
				MainView = React.createElement(View, {
					tag = "col align-x-center",
					Size = if not GetFFlagMomentsDescriptionKeyboardAvoidanceFix() then UDim2.new(1, 0, 1, -v82) else v82:map(function(n1: number) -- line: 441
						return UDim2.new(1, 0, 1, -n1)
					end)
				}, {
					PreviewContainer = React.createElement("CanvasGroup", {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = v69.Color.None.Transparency
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Custom,
							ShrinkRatio = not v75 and 2 or 1
						}),
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v69.Radius.Large)
						}),
						ClickCapture = React.createElement(View, {
							tag = "size-full",
							ZIndex = 0,
							onActivated = v73,
							stateLayer = {
								affordance = Foundation.Enums.StateLayerAffordance.None
							}
						}),
						CaptureView = React.createElement(CaptureView, {
							preview = v67.preview,
							scaleType = v105,
							onAbsoluteSizeChanged = v102,
							onResolutionChanged = if not GetFFlagMomentsCreationTextOverlayResolutionScale() then nil else v103
						}, v104),
						PreviewMediaOverlay = React.createElement(View, {
							tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
							ZIndex = 5
						}, {
							OtherControls = React.createElement(View, {
								tag = "size-full-0 auto-y",
								LayoutOrder = 1,
								padding = {
									bottom = UDim.new(0, v69.Padding.Large),
									left = UDim.new(0, (math.max(v68.left, v69.Padding.Large))),
									right = UDim.new(0, (math.max(v68.right, v69.Padding.Large)))
								}
							}, {
								MusicIndicator = if not music or v74 ~= CreationFlowState.Preview and v74 ~= CreationFlowState.Description then nil else React.createElement(View, {
									tag = "position-bottom-left anchor-bottom-left auto-xy"
								}, {
									MusicChip = React.createElement(MusicChip, {
										musicAssetId = music.assetId,
										onActivated = v92
									})
								})
							}),
							PlaybackControls = if not v75 or (v75.CaptureType ~= Enum.CaptureType.Video or (not v72 or v74 ~= CreationFlowState.Gallery and v74 ~= CreationFlowState.Preview)) then nil else React.createElement(PlaybackControls, {
								layoutOrder = 2,
								preview = v67.preview,
								toggleFitMode = v71.toggle,
								isFitMode = v71.enabled
							})
						}),
						EditCTABar = if v74 ~= CreationFlowState.Preview then nil else React.createElement(EditCTABar, {
							zIndex = 4,
							tools = v77,
							onToolSelected = v91,
							showText = v72,
							isLoadingMap = if not v80 then nil else {
								generateText = true
							}
						})
					}),
					GalleryView = if v74 == CreationFlowState.Gallery then if captureSource == nil then React.createElement(GalleryView, {
						layoutOrder = 2,
						hasMoreCaptures = false,
						onShowMore = nil,
						captures = v56,
						onCaptureSelected = v85,
						onNextCallback = v88,
						selectedCapture = v75
					}) else React.createElement(GallerySourceView, {
						layoutOrder = 2,
						captureSource = captureSource,
						onCaptureSelected = v85,
						onNextCallback = v88,
						selectedCapture = v75
					}) else nil,
					PreviewView = if v74 ~= CreationFlowState.Preview then nil else React.createElement(PreviewView, {
						layoutOrder = 2,
						onContinueCallback = v89,
						onReturnToGalleryCallback = if p1.excludeGallery then nil else v93
					}),
					ActiveStepEditor = v98("Step"),
					DescriptionView = if v74 ~= CreationFlowState.Description then nil else React.createElement(DescriptionView, {
						layoutOrder = 2,
						onPublish = v94,
						onReturnToEditing = v90
					})
				}),
				MusicView = v98("Overlay")
			})
		}),
		Modal = v97()
	})

	return React.createElement(CreationMediaProvider, {
		preview = v67.preview,
		getSelectedCapture = v67.getSelectedCapture
	}, v107)
end
local function CreationFlowScreen(t5: {[any]: any}) -- line: 593
	-- upvalues: React (copy), isTextFiltered (copy), v55 (copy), publishMoment (copy), FoundationProvider (copy), Theme (copy), CreationControllerProvider (copy), CreationFlowContent (copy)
	local onExit = t5.onExit
	local host = t5.host
	local captureSource = t5.captureSource
	local v112 = React.useMemo(function() -- line: 598
		-- upvalues: host (copy), onExit (copy), captureSource (copy), isTextFiltered (copy), v55 (copy), publishMoment (copy)
		if host ~= nil then
			return host
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			isTextFiltered = isTextFiltered,
			createMoment = if not v55 then publishMoment else function(_, _, s3: string) -- line: 607
				print(`[moments-creation] dev publish (not uploaded): "{ s3 }"`)
			end
		}
	end, {
		host,
		onExit,
		captureSource
	})

	return React.createElement(FoundationProvider, {
		theme = Theme.Dark
	}, {
		Root = React.createElement(CreationControllerProvider, {
			host = v112,
			excludeGallery = t5.excludeGallery
		}, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = t5.excludeGallery,
				captureSource = v112.captureSource
			})
		})
	})
end

return CreationFlowScreen
