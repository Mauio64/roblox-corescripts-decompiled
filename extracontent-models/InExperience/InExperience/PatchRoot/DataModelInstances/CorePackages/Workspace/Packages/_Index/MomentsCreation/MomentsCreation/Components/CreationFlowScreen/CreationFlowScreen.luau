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
local v54 = require(MomentsCreationParent.MomentsCommon.isStudio)()
local v55 = if not v54 then {} else sampleCaptures

local function noopActivated() -- line: 107
end

local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function GallerySourceView(t2: {[any]: any}) -- line: 114
	-- upvalues: useSignalState (copy), React (copy), GalleryView (copy)
	local captureSource = t2.captureSource
	local v63 = useSignalState(captureSource.getCaptures)
	local v64 = useSignalState(captureSource.getIsFinished)

	return React.createElement(GalleryView, {
		captures = v63,
		layoutOrder = t2.layoutOrder,
		onCaptureSelected = t2.onCaptureSelected,
		onNextCallback = t2.onNextCallback,
		selectedCapture = t2.selectedCapture,
		hasMoreCaptures = not v64,
		onShowMore = captureSource.fetchMore
	})
end
local function CreationFlowContent(p1) -- line: 136
	-- upvalues: useCreationController (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), useToggleState (copy), useAutoDismissState (copy), useSignalState (copy), useDescriptionKeyboardInset (copy), GetFFlagMomentsDescriptionKeyboardAvoidance (copy), CreationFlowState (copy), useCallback (copy), SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), DialogType (copy), useRef (copy), useEffect (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy), StepStub (copy), useMemo (copy), Signals (copy), GetFFlagMomentsCreationBlockBackgroundInteraction (copy), View (copy), t1 (copy), FormFactor (copy), noopActivated (copy), Icon (copy), Foundation (copy), GetFFlagMomentsDescriptionKeyboardAvoidanceFix (copy), CaptureView (copy), GetFFlagMomentsCreationTextOverlayResolutionScale (copy), MusicChip (copy), PlaybackControls (copy), EditCTABar (copy), GallerySourceView (copy), GalleryView (copy), v55 (copy), PreviewView (copy), DescriptionView (copy), CreationMediaProvider (copy)
	local v66 = useCreationController()
	local v67 = useDeviceInsets()
	local v68 = useTokens()
	local v69 = useFormFactor()
	local v70 = useToggleState(false)
	local v71, v72 = useAutoDismissState()
	local v73 = useSignalState(v66.getStep)
	local v74 = useSignalState(v66.getSelectedCapture)
	local v75 = useSignalState(v66.getComposedEdits)
	local v76 = useSignalState(v66.getAvailableTools)
	local v77 = useSignalState(v66.getActiveTool)
	local v78 = useSignalState(v66.getActiveModal)
	local music = v75.music
	local v80, v81 = useDescriptionKeyboardInset(GetFFlagMomentsDescriptionKeyboardAvoidance() and v73 == CreationFlowState.Description)
	local captureSource = p1.captureSource
	local v83 = useCallback(function(p2) -- line: 167
		-- upvalues: v66 (copy), v72 (copy)
		v66.selectCapture(p2)
		v72()
	end, {
		v66,
		v72
	})

	local function withCreationSession(t3: {[any]: any}) -- line: 176
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v113 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t3, makeCreationEventFields.makeCreationBaseFields(v113))
	end
	local function flowStepFields() -- line: 186
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy), withCreationSession (copy), makeCreationEventFields (copy), v66 (copy)
		if GetFFlagMomentsAnalyticsProducerPrereqs() then
			return withCreationSession(makeCreationEventFields.makeStepFieldFromState((v66.getStep(false))))
		end

		return {
			step = v66.getStep(false)
		}
	end

	local v86 = useCallback(function() -- line: 196
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v66 (copy), CreationFlowState (copy), v72 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v66.navigate(CreationFlowState.Preview)
		v72()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToEditButtonPressed)))
	end, {
		v66,
		v72
	})
	local v87 = useCallback(function() -- line: 209
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v66 (copy), CreationFlowState (copy), v70 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v66.navigate(CreationFlowState.Description)
		v70.disable()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)))
	end, {
		v66,
		v70.disable
	})
	local v88 = useCallback(function() -- line: 222
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v66 (copy), CreationFlowState (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v66.navigate(CreationFlowState.Preview)
	end, { v66 })
	local v89 = useCallback(function(s1: string) -- line: 227
		-- upvalues: v66 (copy)
		v66.beginTool(s1)
	end, { v66 })
	local v90 = useCallback(function() -- line: 231
		-- upvalues: v66 (copy)
		v66.beginTool("music")
	end, { v66 })
	local v91 = useCallback(function() -- line: 235
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v66 (copy), DialogType (copy), v70 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v66.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v66.dismissModal,
				onConfirm = function() -- line: 241
					-- upvalues: v66 (copy), v70 (copy)
					v66.dismissModal()
					v66.returnToGallery()
					v70.disable()
				end
			}
		})
	end, {
		v66,
		v70.disable
	})
	local v92 = useCallback(function() -- line: 250
		-- upvalues: v66 (copy)
		v66.publish()
	end, { v66 })
	local v93 = useCallback(function() -- line: 254
		-- upvalues: v74 (copy), v66 (copy), DialogType (copy)
		if v74 then
			v66.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = v66.dismissModal,
					onConfirm = v66.exit
				}
			})

			return
		end

		v66.exit()
	end, {
		v66,
		v74
	})
	local v94 = useRef(nil)

	useEffect(function() -- line: 269
		-- upvalues: v94 (copy), v73 (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy)
		local current = v94.current

		v94.current = v73

		if v73 == CreationFlowState.Gallery then
			fireAnalyticsEvent(EventNames.EditingFlowGalleryPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowGalleryPageAppear)))

			return
		end

		if v73 == CreationFlowState.Preview then
			if current ~= CreationFlowState.Trimming and (current ~= CreationFlowState.Music and current ~= CreationFlowState.TextOverlay) then
				fireAnalyticsEvent(EventNames.EditingFlowEditPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowEditPageAppear)))

				return
			end
		elseif v73 == CreationFlowState.Description then
			fireAnalyticsEvent(EventNames.EditingFlowPreviewPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowPreviewPageAppear)))
		end
	end, { v73 })
	useEffect(function() -- line: 300
		-- upvalues: v73 (copy), CreationFlowState (copy), v70 (copy)
		if v73 == CreationFlowState.Gallery or (v73 == CreationFlowState.Music or v73 == CreationFlowState.Description) then
			v70.disable()
		end
	end, {
		v73,
		v70.disable
	})

	local v95 = useCallback(function() -- line: 310
		-- upvalues: v78 (copy), DialogType (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy)
		if not v78 or not v78.modalType then
			return nil
		end

		if v78.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v78.modalProps)
		end

		if v78.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v78.modalProps)
		end

		return nil
	end, { v78 })
	local v96 = useCallback(function(s2: string) -- line: 324
		-- upvalues: v77 (copy), v73 (copy), v66 (copy), React (copy), StepStub (copy)
		if v77 == nil or (s2 ~= v77.presentation or v73 ~= v77.step) then
			return nil
		end

		if v77.renderEditor ~= nil then
			local v117 = v77.renderEditor(v66)

			if v117 ~= nil then
				return v117
			end
		end

		return React.createElement(StepStub(v77.kind), {})
	end, {
		v77,
		v73,
		v66
	})
	local v97 = useMemo(function() -- line: 342
		-- upvalues: Signals (copy)
		local v118, v119 = Signals.createSignal(Vector2.zero)

		return {
			getItemSize = v118,
			setItemSize = v119
		}
	end, {})
	local v98 = useMemo(function() -- line: 350
		-- upvalues: Signals (copy)
		local v120, v121 = Signals.createSignal(Vector2.zero)

		return {
			getItemResolution = v120,
			setItemResolution = v121
		}
	end, {})
	local v99 = useMemo(function() -- line: 355
		-- upvalues: v97 (copy), v98 (copy)
		return {
			getItemSize = v97.getItemSize,
			getItemResolution = v98.getItemResolution
		}
	end, {
		v97,
		v98
	})
	local v100 = useCallback(function(p3) -- line: 359
		-- upvalues: v97 (copy)
		v97.setItemSize(p3.AbsoluteSize)
	end, { v97 })
	local v101 = useCallback(function(vector2: Vector2) -- line: 363
		-- upvalues: v98 (copy)
		v98.setItemResolution(vector2)
	end, { v98 })
	local v102 = useMemo(function() -- line: 367
		-- upvalues: v76 (copy), v66 (copy), v99 (copy)
		local t4 = {}

		for _, v126 in v76 do
			if v126.renderPreviewLayer ~= nil then
				t4[v126.kind .. "PreviewLayer"] = v126.renderPreviewLayer(v66, v99)
			end
		end

		return t4
	end, {
		v76,
		v66,
		v99
	})
	local v103 = if not v70.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit
	local v104 = GetFFlagMomentsCreationBlockBackgroundInteraction()
	local v105 = React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full",
		backgroundStyle = v68.Color.Common.Scrim,
		onActivated = if not v104 then nil else v93,
		stateLayer = if not v104 then nil else t1,
		testId = if not v104 then nil else "moments-creation-background-scrim"
	}, {
		CreationFlowView = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = {
				MaxSize = if v69 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
			},
			onActivated = if not v104 then nil else noopActivated,
			stateLayer = if not v104 then nil else t1,
			testId = if not v104 then nil else "moments-creation-panel"
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "position-top-right anchor-top-right auto-xy",
				padding = {
					top = UDim.new(0, v67.top + v68.Padding.Medium),
					right = UDim.new(0, v67.right + v68.Padding.Medium)
				}
			}, {
				CloseButton = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0",
					onActivated = v93
				}, {
					CloseIcon = React.createElement(Icon, {
						name = "icons/navigation/close_small",
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = Foundation.Enums.IconSize.Small,
						style = v68.Color.ActionEmphasis.Foreground
					})
				})
			}),
			MainViewContainer = React.createElement(View, {
				tag = "size-full",
				onAbsoluteSizeChanged = v81
			}, {
				MainView = React.createElement(View, {
					tag = "col align-x-center",
					Size = if not GetFFlagMomentsDescriptionKeyboardAvoidanceFix() then UDim2.new(1, 0, 1, -v80) else v80:map(function(n1: number) -- line: 438
						return UDim2.new(1, 0, 1, -n1)
					end)
				}, {
					PreviewContainer = React.createElement("CanvasGroup", {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = v68.Color.None.Transparency
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Custom,
							ShrinkRatio = not v74 and 2 or 1
						}),
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v68.Radius.Large)
						}),
						ClickCapture = React.createElement(View, {
							tag = "size-full",
							ZIndex = 0,
							onActivated = v72,
							stateLayer = {
								affordance = Foundation.Enums.StateLayerAffordance.None
							}
						}),
						CaptureView = React.createElement(CaptureView, {
							preview = v66.preview,
							scaleType = v103,
							onAbsoluteSizeChanged = v100,
							onResolutionChanged = if not GetFFlagMomentsCreationTextOverlayResolutionScale() then nil else v101
						}, v102),
						PreviewMediaOverlay = React.createElement(View, {
							tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
							ZIndex = 5
						}, {
							OtherControls = React.createElement(View, {
								tag = "size-full-0 auto-y",
								LayoutOrder = 1,
								padding = {
									bottom = UDim.new(0, v68.Padding.Large),
									left = UDim.new(0, (math.max(v67.left, v68.Padding.Large))),
									right = UDim.new(0, (math.max(v67.right, v68.Padding.Large)))
								}
							}, {
								MusicIndicator = if not music or v73 ~= CreationFlowState.Preview and v73 ~= CreationFlowState.Description then nil else React.createElement(View, {
									tag = "position-bottom-left anchor-bottom-left auto-xy"
								}, {
									MusicChip = React.createElement(MusicChip, {
										musicAssetId = music.assetId,
										onActivated = v90
									})
								})
							}),
							PlaybackControls = if not v74 or (v74.CaptureType ~= Enum.CaptureType.Video or (not v71 or v73 ~= CreationFlowState.Gallery and v73 ~= CreationFlowState.Preview)) then nil else React.createElement(PlaybackControls, {
								layoutOrder = 2,
								preview = v66.preview,
								toggleFitMode = v70.toggle,
								isFitMode = v70.enabled
							})
						}),
						EditCTABar = if v73 ~= CreationFlowState.Preview then nil else React.createElement(EditCTABar, {
							zIndex = 4,
							tools = v76,
							onToolSelected = v89,
							showText = v71
						})
					}),
					GalleryView = if v73 == CreationFlowState.Gallery then if captureSource == nil then React.createElement(GalleryView, {
						layoutOrder = 2,
						hasMoreCaptures = false,
						onShowMore = nil,
						captures = v55,
						onCaptureSelected = v83,
						onNextCallback = v86,
						selectedCapture = v74
					}) else React.createElement(GallerySourceView, {
						layoutOrder = 2,
						captureSource = captureSource,
						onCaptureSelected = v83,
						onNextCallback = v86,
						selectedCapture = v74
					}) else nil,
					PreviewView = if v73 ~= CreationFlowState.Preview then nil else React.createElement(PreviewView, {
						layoutOrder = 2,
						onContinueCallback = v87,
						onReturnToGalleryCallback = if p1.excludeGallery then nil else v91
					}),
					ActiveStepEditor = v96("Step"),
					DescriptionView = if v73 ~= CreationFlowState.Description then nil else React.createElement(DescriptionView, {
						layoutOrder = 2,
						onPublish = v92,
						onReturnToEditing = v88
					})
				}),
				MusicView = v96("Overlay")
			})
		}),
		Modal = v95()
	})

	return React.createElement(CreationMediaProvider, {
		preview = v66.preview,
		getSelectedCapture = v66.getSelectedCapture
	}, v105)
end
local function CreationFlowScreen(t5: {[any]: any}) -- line: 589
	-- upvalues: React (copy), isTextFiltered (copy), v54 (copy), publishMoment (copy), FoundationProvider (copy), Theme (copy), CreationControllerProvider (copy), CreationFlowContent (copy)
	local onExit = t5.onExit
	local host = t5.host
	local captureSource = t5.captureSource
	local v110 = React.useMemo(function() -- line: 594
		-- upvalues: host (copy), onExit (copy), captureSource (copy), isTextFiltered (copy), v54 (copy), publishMoment (copy)
		if host ~= nil then
			return host
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			isTextFiltered = isTextFiltered,
			createMoment = if not v54 then publishMoment else function(_, _, s3: string) -- line: 603
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
			host = v110,
			excludeGallery = t5.excludeGallery
		}, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = t5.excludeGallery,
				captureSource = v110.captureSource
			})
		})
	})
end

return CreationFlowScreen
