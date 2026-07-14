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
local v53 = require(MomentsCreationParent.MomentsCommon.isStudio)()
local v54 = if not v53 then {} else sampleCaptures

local function noopActivated() -- line: 105
end

local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function GallerySourceView(t2: {[any]: any}) -- line: 112
	-- upvalues: useSignalState (copy), React (copy), GalleryView (copy)
	local captureSource = t2.captureSource
	local v62 = useSignalState(captureSource.getCaptures)
	local v63 = useSignalState(captureSource.getIsFinished)

	return React.createElement(GalleryView, {
		captures = v62,
		layoutOrder = t2.layoutOrder,
		onCaptureSelected = t2.onCaptureSelected,
		onNextCallback = t2.onNextCallback,
		selectedCapture = t2.selectedCapture,
		hasMoreCaptures = not v63,
		onShowMore = captureSource.fetchMore
	})
end
local function CreationFlowContent(p1) -- line: 134
	-- upvalues: useCreationController (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), useToggleState (copy), useAutoDismissState (copy), useSignalState (copy), useDescriptionKeyboardInset (copy), GetFFlagMomentsDescriptionKeyboardAvoidance (copy), CreationFlowState (copy), useCallback (copy), SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy), GetFFlagMomentsAnalyticsProducerPrereqs (copy), fireAnalyticsEvent (copy), EventNames (copy), DialogType (copy), useRef (copy), useEffect (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy), StepStub (copy), useMemo (copy), Signals (copy), GetFFlagMomentsCreationBlockBackgroundInteraction (copy), View (copy), t1 (copy), FormFactor (copy), noopActivated (copy), Icon (copy), Foundation (copy), GetFFlagMomentsDescriptionKeyboardAvoidanceFix (copy), CaptureView (copy), MusicChip (copy), PlaybackControls (copy), EditCTABar (copy), GallerySourceView (copy), GalleryView (copy), v54 (copy), PreviewView (copy), DescriptionView (copy), CreationMediaProvider (copy)
	local v65 = useCreationController()
	local v66 = useDeviceInsets()
	local v67 = useTokens()
	local v68 = useFormFactor()
	local v69 = useToggleState(false)
	local v70, v71 = useAutoDismissState()
	local v72 = useSignalState(v65.getStep)
	local v73 = useSignalState(v65.getSelectedCapture)
	local v74 = useSignalState(v65.getComposedEdits)
	local v75 = useSignalState(v65.getAvailableTools)
	local v76 = useSignalState(v65.getActiveTool)
	local v77 = useSignalState(v65.getActiveModal)
	local music = v74.music
	local v79, v80 = useDescriptionKeyboardInset(GetFFlagMomentsDescriptionKeyboardAvoidance() and v72 == CreationFlowState.Description)
	local captureSource = p1.captureSource
	local v82 = useCallback(function(p2) -- line: 165
		-- upvalues: v65 (copy), v71 (copy)
		v65.selectCapture(p2)
		v71()
	end, {
		v65,
		v71
	})

	local function withCreationSession(t3: {[any]: any}) -- line: 174
		-- upvalues: SessionManager (copy), FunnelEventNames (copy), Cryo (copy), makeCreationEventFields (copy)
		local v110 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		return Cryo.Dictionary.join(t3, makeCreationEventFields.makeCreationBaseFields(v110))
	end
	local function flowStepFields() -- line: 184
		-- upvalues: GetFFlagMomentsAnalyticsProducerPrereqs (copy), withCreationSession (copy), makeCreationEventFields (copy), v65 (copy)
		if GetFFlagMomentsAnalyticsProducerPrereqs() then
			return withCreationSession(makeCreationEventFields.makeStepFieldFromState((v65.getStep(false))))
		end

		return {
			step = v65.getStep(false)
		}
	end

	local v85 = useCallback(function() -- line: 194
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v65 (copy), CreationFlowState (copy), v71 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v65.navigate(CreationFlowState.Preview)
		v71()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToEditButtonPressed)))
	end, {
		v65,
		v71
	})
	local v86 = useCallback(function() -- line: 207
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v65 (copy), CreationFlowState (copy), v69 (copy), withCreationSession (copy), makeCreationEventFields (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, flowStepFields())
		v65.navigate(CreationFlowState.Description)
		v69.disable()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed, withCreationSession(makeCreationEventFields.makeStepField(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)))
	end, {
		v65,
		v69.disable
	})
	local v87 = useCallback(function() -- line: 220
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v65 (copy), CreationFlowState (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v65.navigate(CreationFlowState.Preview)
	end, { v65 })
	local v88 = useCallback(function(s1: string) -- line: 225
		-- upvalues: v65 (copy)
		v65.beginTool(s1)
	end, { v65 })
	local v89 = useCallback(function() -- line: 229
		-- upvalues: v65 (copy)
		v65.beginTool("music")
	end, { v65 })
	local v90 = useCallback(function() -- line: 233
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), flowStepFields (copy), v65 (copy), DialogType (copy), v69 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, flowStepFields())
		v65.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v65.dismissModal,
				onConfirm = function() -- line: 239
					-- upvalues: v65 (copy), v69 (copy)
					v65.dismissModal()
					v65.returnToGallery()
					v69.disable()
				end
			}
		})
	end, {
		v65,
		v69.disable
	})
	local v91 = useCallback(function() -- line: 248
		-- upvalues: v65 (copy)
		v65.publish()
	end, { v65 })
	local v92 = useCallback(function() -- line: 252
		-- upvalues: v73 (copy), v65 (copy), DialogType (copy)
		if v73 then
			v65.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = v65.dismissModal,
					onConfirm = v65.exit
				}
			})

			return
		end

		v65.exit()
	end, {
		v65,
		v73
	})
	local v93 = useRef(nil)

	useEffect(function() -- line: 267
		-- upvalues: v93 (copy), v72 (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy), withCreationSession (copy), makeCreationEventFields (copy)
		local current = v93.current

		v93.current = v72

		if v72 == CreationFlowState.Gallery then
			fireAnalyticsEvent(EventNames.EditingFlowGalleryPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowGalleryPageAppear)))

			return
		end

		if v72 == CreationFlowState.Preview then
			if current ~= CreationFlowState.Trimming and (current ~= CreationFlowState.Music and current ~= CreationFlowState.TextOverlay) then
				fireAnalyticsEvent(EventNames.EditingFlowEditPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowEditPageAppear)))

				return
			end
		elseif v72 == CreationFlowState.Description then
			fireAnalyticsEvent(EventNames.EditingFlowPreviewPageAppear, withCreationSession(makeCreationEventFields.makeStepField(EventNames.EditingFlowPreviewPageAppear)))
		end
	end, { v72 })
	useEffect(function() -- line: 298
		-- upvalues: v72 (copy), CreationFlowState (copy), v69 (copy)
		if v72 == CreationFlowState.Gallery or (v72 == CreationFlowState.Music or v72 == CreationFlowState.Description) then
			v69.disable()
		end
	end, {
		v72,
		v69.disable
	})

	local v94 = useCallback(function() -- line: 308
		-- upvalues: v77 (copy), DialogType (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy)
		if not v77 or not v77.modalType then
			return nil
		end

		if v77.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v77.modalProps)
		end

		if v77.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v77.modalProps)
		end

		return nil
	end, { v77 })
	local v95 = useCallback(function(s2: string) -- line: 322
		-- upvalues: v76 (copy), v72 (copy), v65 (copy), React (copy), StepStub (copy)
		if v76 == nil or (s2 ~= v76.presentation or v72 ~= v76.step) then
			return nil
		end

		if v76.renderEditor ~= nil then
			local v114 = v76.renderEditor(v65)

			if v114 ~= nil then
				return v114
			end
		end

		return React.createElement(StepStub(v76.kind), {})
	end, {
		v76,
		v72,
		v65
	})
	local v96 = useMemo(function() -- line: 340
		-- upvalues: Signals (copy)
		local v115, v116 = Signals.createSignal(Vector2.zero)

		return {
			getItemSize = v115,
			setItemSize = v116
		}
	end, {})
	local v97 = useMemo(function() -- line: 345
		-- upvalues: v96 (copy)
		return {
			getItemSize = v96.getItemSize
		}
	end, { v96 })
	local v98 = useCallback(function(p3) -- line: 349
		-- upvalues: v96 (copy)
		v96.setItemSize(p3.AbsoluteSize)
	end, { v96 })
	local v99 = useMemo(function() -- line: 353
		-- upvalues: v75 (copy), v65 (copy), v97 (copy)
		local t4 = {}

		for _, v120 in v75 do
			if v120.renderPreviewLayer ~= nil then
				t4[v120.kind .. "PreviewLayer"] = v120.renderPreviewLayer(v65, v97)
			end
		end

		return t4
	end, {
		v75,
		v65,
		v97
	})
	local v100 = if not v69.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit
	local v101 = GetFFlagMomentsCreationBlockBackgroundInteraction()
	local v102 = React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full",
		backgroundStyle = v67.Color.Common.Scrim,
		onActivated = if not v101 then nil else v92,
		stateLayer = if not v101 then nil else t1,
		testId = if not v101 then nil else "moments-creation-background-scrim"
	}, {
		CreationFlowView = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = {
				MaxSize = if v68 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
			},
			onActivated = if not v101 then nil else noopActivated,
			stateLayer = if not v101 then nil else t1,
			testId = if not v101 then nil else "moments-creation-panel"
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "position-top-right anchor-top-right auto-xy",
				padding = {
					top = UDim.new(0, v66.top + v67.Padding.Medium),
					right = UDim.new(0, v66.right + v67.Padding.Medium)
				}
			}, {
				CloseButton = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0",
					onActivated = v92
				}, {
					CloseIcon = React.createElement(Icon, {
						name = "icons/navigation/close_small",
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = Foundation.Enums.IconSize.Small,
						style = v67.Color.ActionEmphasis.Foreground
					})
				})
			}),
			MainViewContainer = React.createElement(View, {
				tag = "size-full",
				onAbsoluteSizeChanged = v80
			}, {
				MainView = React.createElement(View, {
					tag = "col align-x-center",
					Size = if not GetFFlagMomentsDescriptionKeyboardAvoidanceFix() then UDim2.new(1, 0, 1, -v79) else v79:map(function(n1: number) -- line: 424
						return UDim2.new(1, 0, 1, -n1)
					end)
				}, {
					PreviewContainer = React.createElement("CanvasGroup", {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = v67.Color.None.Transparency
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Custom,
							ShrinkRatio = not v73 and 2 or 1
						}),
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v67.Radius.Large)
						}),
						ClickCapture = React.createElement(View, {
							tag = "size-full",
							ZIndex = 0,
							onActivated = v71,
							stateLayer = {
								affordance = Foundation.Enums.StateLayerAffordance.None
							}
						}),
						CaptureView = React.createElement(CaptureView, {
							preview = v65.preview,
							scaleType = v100,
							onAbsoluteSizeChanged = v98
						}, v99),
						PreviewMediaOverlay = React.createElement(View, {
							tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
							ZIndex = 5
						}, {
							OtherControls = React.createElement(View, {
								tag = "size-full-0 auto-y",
								LayoutOrder = 1,
								padding = {
									bottom = UDim.new(0, v67.Padding.Large),
									left = UDim.new(0, (math.max(v66.left, v67.Padding.Large))),
									right = UDim.new(0, (math.max(v66.right, v67.Padding.Large)))
								}
							}, {
								MusicIndicator = if not music or v72 ~= CreationFlowState.Preview and v72 ~= CreationFlowState.Description then nil else React.createElement(View, {
									tag = "position-bottom-left anchor-bottom-left auto-xy"
								}, {
									MusicChip = React.createElement(MusicChip, {
										musicAssetId = music.assetId,
										onActivated = v89
									})
								})
							}),
							PlaybackControls = if not v73 or (v73.CaptureType ~= Enum.CaptureType.Video or (not v70 or v72 ~= CreationFlowState.Gallery and v72 ~= CreationFlowState.Preview)) then nil else React.createElement(PlaybackControls, {
								layoutOrder = 2,
								preview = v65.preview,
								toggleFitMode = v69.toggle,
								isFitMode = v69.enabled
							})
						}),
						EditCTABar = if v72 ~= CreationFlowState.Preview then nil else React.createElement(EditCTABar, {
							zIndex = 4,
							tools = v75,
							onToolSelected = v88,
							showText = v70
						})
					}),
					GalleryView = if v72 == CreationFlowState.Gallery then if captureSource == nil then React.createElement(GalleryView, {
						layoutOrder = 2,
						hasMoreCaptures = false,
						onShowMore = nil,
						captures = v54,
						onCaptureSelected = v82,
						onNextCallback = v85,
						selectedCapture = v73
					}) else React.createElement(GallerySourceView, {
						layoutOrder = 2,
						captureSource = captureSource,
						onCaptureSelected = v82,
						onNextCallback = v85,
						selectedCapture = v73
					}) else nil,
					PreviewView = if v72 ~= CreationFlowState.Preview then nil else React.createElement(PreviewView, {
						layoutOrder = 2,
						onContinueCallback = v86,
						onReturnToGalleryCallback = if p1.excludeGallery then nil else v90
					}),
					ActiveStepEditor = v95("Step"),
					DescriptionView = if v72 ~= CreationFlowState.Description then nil else React.createElement(DescriptionView, {
						layoutOrder = 2,
						onPublish = v91,
						onReturnToEditing = v87
					})
				}),
				MusicView = v95("Overlay")
			})
		}),
		Modal = v94()
	})

	return React.createElement(CreationMediaProvider, {
		preview = v65.preview,
		getSelectedCapture = v65.getSelectedCapture
	}, v102)
end
local function CreationFlowScreen(t5: {[any]: any}) -- line: 572
	-- upvalues: React (copy), isTextFiltered (copy), v53 (copy), publishMoment (copy), FoundationProvider (copy), Theme (copy), CreationControllerProvider (copy), CreationFlowContent (copy)
	local onExit = t5.onExit
	local host = t5.host
	local captureSource = t5.captureSource
	local v107 = React.useMemo(function() -- line: 577
		-- upvalues: host (copy), onExit (copy), captureSource (copy), isTextFiltered (copy), v53 (copy), publishMoment (copy)
		if host ~= nil then
			return host
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			isTextFiltered = isTextFiltered,
			createMoment = if not v53 then publishMoment else function(_, _, s3: string) -- line: 586
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
			host = v107,
			excludeGallery = t5.excludeGallery
		}, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = t5.excludeGallery,
				captureSource = v107.captureSource
			})
		})
	})
end

return CreationFlowScreen
