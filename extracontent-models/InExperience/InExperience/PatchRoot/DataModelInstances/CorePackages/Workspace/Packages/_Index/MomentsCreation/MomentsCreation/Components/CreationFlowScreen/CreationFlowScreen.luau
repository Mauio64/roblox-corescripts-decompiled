local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
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
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
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
local v48 = require(MomentsCreationParent.MomentsCommon.isStudio)()
local v49 = if not v48 then {} else sampleCaptures

local function noopActivated() -- line: 100
end

local t1 = {
	affordance = Foundation.Enums.StateLayerAffordance.None
}

local function GallerySourceView(t2: {[any]: any}) -- line: 107
	-- upvalues: useSignalState (copy), React (copy), GalleryView (copy)
	local captureSource = t2.captureSource
	local v57 = useSignalState(captureSource.getCaptures)
	local v58 = useSignalState(captureSource.getIsFinished)

	return React.createElement(GalleryView, {
		captures = v57,
		layoutOrder = t2.layoutOrder,
		onCaptureSelected = t2.onCaptureSelected,
		onNextCallback = t2.onNextCallback,
		selectedCapture = t2.selectedCapture,
		hasMoreCaptures = not v58,
		onShowMore = captureSource.fetchMore
	})
end
local function CreationFlowContent(p1) -- line: 129
	-- upvalues: useCreationController (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), useToggleState (copy), useAutoDismissState (copy), useSignalState (copy), useDescriptionKeyboardInset (copy), GetFFlagMomentsDescriptionKeyboardAvoidance (copy), CreationFlowState (copy), useCallback (copy), fireAnalyticsEvent (copy), EventNames (copy), DialogType (copy), useRef (copy), useEffect (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy), StepStub (copy), useMemo (copy), Signals (copy), GetFFlagMomentsCreationBlockBackgroundInteraction (copy), View (copy), t1 (copy), FormFactor (copy), noopActivated (copy), Icon (copy), Foundation (copy), GetFFlagMomentsDescriptionKeyboardAvoidanceFix (copy), CaptureView (copy), MusicChip (copy), PlaybackControls (copy), EditCTABar (copy), GallerySourceView (copy), GalleryView (copy), v49 (copy), PreviewView (copy), DescriptionView (copy), CreationMediaProvider (copy)
	local v60 = useCreationController()
	local v61 = useDeviceInsets()
	local v62 = useTokens()
	local v63 = useFormFactor()
	local v64 = useToggleState(false)
	local v65, v66 = useAutoDismissState()
	local v67 = useSignalState(v60.getStep)
	local v68 = useSignalState(v60.getSelectedCapture)
	local v69 = useSignalState(v60.getComposedEdits)
	local v70 = useSignalState(v60.getAvailableTools)
	local v71 = useSignalState(v60.getActiveTool)
	local v72 = useSignalState(v60.getActiveModal)
	local music = v69.music
	local v74, v75 = useDescriptionKeyboardInset(GetFFlagMomentsDescriptionKeyboardAvoidance() and v67 == CreationFlowState.Description)
	local captureSource = p1.captureSource
	local v77 = useCallback(function(p2) -- line: 160
		-- upvalues: v60 (copy), v66 (copy)
		v60.selectCapture(p2)
		v66()
	end, {
		v60,
		v66
	})
	local v78 = useCallback(function() -- line: 166
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v60 (copy), CreationFlowState (copy), v66 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, {
			step = v60.getStep(false)
		})
		v60.navigate(CreationFlowState.Preview)
		v66()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed)
	end, {
		v60,
		v66
	})
	local v79 = useCallback(function() -- line: 176
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v60 (copy), CreationFlowState (copy), v64 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowNextButtonPressed, {
			step = v60.getStep(false)
		})
		v60.navigate(CreationFlowState.Description)
		v64.disable()
		fireAnalyticsEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)
	end, {
		v60,
		v64.disable
	})
	local v80 = useCallback(function() -- line: 186
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v60 (copy), CreationFlowState (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, {
			step = v60.getStep(false)
		})
		v60.navigate(CreationFlowState.Preview)
	end, { v60 })
	local v81 = useCallback(function(s1: string) -- line: 193
		-- upvalues: v60 (copy)
		v60.beginTool(s1)
	end, { v60 })
	local v82 = useCallback(function() -- line: 197
		-- upvalues: v60 (copy)
		v60.beginTool("music")
	end, { v60 })
	local v83 = useCallback(function() -- line: 201
		-- upvalues: fireAnalyticsEvent (copy), EventNames (copy), v60 (copy), DialogType (copy), v64 (copy)
		fireAnalyticsEvent(EventNames.EditingFlowReturnButtonPressed, {
			step = v60.getStep(false)
		})
		v60.showModal({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = v60.dismissModal,
				onConfirm = function() -- line: 209
					-- upvalues: v60 (copy), v64 (copy)
					v60.dismissModal()
					v60.returnToGallery()
					v64.disable()
				end
			}
		})
	end, {
		v60,
		v64.disable
	})
	local v84 = useCallback(function() -- line: 218
		-- upvalues: v60 (copy)
		v60.publish()
	end, { v60 })
	local v85 = useCallback(function() -- line: 222
		-- upvalues: v68 (copy), v60 (copy), DialogType (copy)
		if v68 then
			v60.showModal({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = v60.dismissModal,
					onConfirm = v60.exit
				}
			})

			return
		end

		v60.exit()
	end, {
		v60,
		v68
	})
	local v86 = useRef(nil)

	useEffect(function() -- line: 237
		-- upvalues: v86 (copy), v67 (copy), CreationFlowState (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local current = v86.current

		v86.current = v67

		if v67 == CreationFlowState.Gallery then
			fireAnalyticsEvent(EventNames.EditingFlowGalleryPageAppear)

			return
		end

		if v67 == CreationFlowState.Preview then
			if current ~= CreationFlowState.Trimming and (current ~= CreationFlowState.Music and current ~= CreationFlowState.TextOverlay) then
				fireAnalyticsEvent(EventNames.EditingFlowEditPageAppear)

				return
			end
		elseif v67 == CreationFlowState.Description then
			fireAnalyticsEvent(EventNames.EditingFlowPreviewPageAppear)
		end
	end, { v67 })
	useEffect(function() -- line: 257
		-- upvalues: v67 (copy), CreationFlowState (copy), v64 (copy)
		if v67 == CreationFlowState.Gallery or (v67 == CreationFlowState.Music or v67 == CreationFlowState.Description) then
			v64.disable()
		end
	end, {
		v67,
		v64.disable
	})

	local v87 = useCallback(function() -- line: 267
		-- upvalues: v72 (copy), DialogType (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy)
		if not v72 or not v72.modalType then
			return nil
		end

		if v72.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v72.modalProps)
		end

		if v72.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v72.modalProps)
		end

		return nil
	end, { v72 })
	local v88 = useCallback(function(s2: string) -- line: 281
		-- upvalues: v71 (copy), v67 (copy), v60 (copy), React (copy), StepStub (copy)
		if v71 == nil or (s2 ~= v71.presentation or v67 ~= v71.step) then
			return nil
		end

		if v71.renderEditor ~= nil then
			local v105 = v71.renderEditor(v60)

			if v105 ~= nil then
				return v105
			end
		end

		return React.createElement(StepStub(v71.kind), {})
	end, {
		v71,
		v67,
		v60
	})
	local v89 = useMemo(function() -- line: 299
		-- upvalues: Signals (copy)
		local v106, v107 = Signals.createSignal(Vector2.zero)

		return {
			getItemSize = v106,
			setItemSize = v107
		}
	end, {})
	local v90 = useMemo(function() -- line: 304
		-- upvalues: v89 (copy)
		return {
			getItemSize = v89.getItemSize
		}
	end, { v89 })
	local v91 = useCallback(function(p3) -- line: 308
		-- upvalues: v89 (copy)
		v89.setItemSize(p3.AbsoluteSize)
	end, { v89 })
	local v92 = useMemo(function() -- line: 312
		-- upvalues: v70 (copy), v60 (copy), v90 (copy)
		local t3 = {}

		for _, v111 in v70 do
			if v111.renderPreviewLayer ~= nil then
				t3[v111.kind .. "PreviewLayer"] = v111.renderPreviewLayer(v60, v90)
			end
		end

		return t3
	end, {
		v70,
		v60,
		v90
	})
	local v93 = if not v64.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit
	local v94 = GetFFlagMomentsCreationBlockBackgroundInteraction()
	local v95 = React.createElement(View, {
		tag = "position-center-center anchor-center-center size-full-full",
		backgroundStyle = v62.Color.Common.Scrim,
		onActivated = if not v94 then nil else v85,
		stateLayer = if not v94 then nil else t1,
		testId = if not v94 then nil else "moments-creation-background-scrim"
	}, {
		CreationFlowView = React.createElement(View, {
			tag = "position-center-center anchor-center-center size-full-full radius-large bg-surface-0",
			sizeConstraint = {
				MaxSize = if v63 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
			},
			onActivated = if not v94 then nil else noopActivated,
			stateLayer = if not v94 then nil else t1,
			testId = if not v94 then nil else "moments-creation-panel"
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "position-top-right anchor-top-right auto-xy",
				padding = {
					top = UDim.new(0, v61.top + v62.Padding.Medium),
					right = UDim.new(0, v61.right + v62.Padding.Medium)
				}
			}, {
				CloseButton = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-1100-1100 padding-medium radius-circle bg-over-media-0",
					onActivated = v85
				}, {
					CloseIcon = React.createElement(Icon, {
						name = "icons/navigation/close_small",
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = Foundation.Enums.IconSize.Small,
						style = v62.Color.ActionEmphasis.Foreground
					})
				})
			}),
			MainViewContainer = React.createElement(View, {
				tag = "size-full",
				onAbsoluteSizeChanged = v75
			}, {
				MainView = React.createElement(View, {
					tag = "col align-x-center",
					Size = if not GetFFlagMomentsDescriptionKeyboardAvoidanceFix() then UDim2.new(1, 0, 1, -v74) else v74:map(function(n1: number) -- line: 383
						return UDim2.new(1, 0, 1, -n1)
					end)
				}, {
					PreviewContainer = React.createElement("CanvasGroup", {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = v62.Color.None.Transparency
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Custom,
							ShrinkRatio = not v68 and 2 or 1
						}),
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v62.Radius.Large)
						}),
						ClickCapture = React.createElement(View, {
							tag = "size-full",
							ZIndex = 0,
							onActivated = v66,
							stateLayer = {
								affordance = Foundation.Enums.StateLayerAffordance.None
							}
						}),
						CaptureView = React.createElement(CaptureView, {
							preview = v60.preview,
							scaleType = v93,
							onAbsoluteSizeChanged = v91
						}, v92),
						PreviewMediaOverlay = React.createElement(View, {
							tag = "col position-bottom-center anchor-bottom-center size-full-0 auto-y",
							ZIndex = 5
						}, {
							OtherControls = React.createElement(View, {
								tag = "size-full-0 auto-y",
								LayoutOrder = 1,
								padding = {
									bottom = UDim.new(0, v62.Padding.Large),
									left = UDim.new(0, (math.max(v61.left, v62.Padding.Large))),
									right = UDim.new(0, (math.max(v61.right, v62.Padding.Large)))
								}
							}, {
								MusicIndicator = if not music or v67 ~= CreationFlowState.Preview and v67 ~= CreationFlowState.Description then nil else React.createElement(View, {
									tag = "position-bottom-left anchor-bottom-left auto-xy"
								}, {
									MusicChip = React.createElement(MusicChip, {
										musicAssetId = music.assetId,
										onActivated = v82
									})
								})
							}),
							PlaybackControls = if not v68 or (v68.CaptureType ~= Enum.CaptureType.Video or (not v65 or v67 ~= CreationFlowState.Gallery and v67 ~= CreationFlowState.Preview)) then nil else React.createElement(PlaybackControls, {
								layoutOrder = 2,
								preview = v60.preview,
								toggleFitMode = v64.toggle,
								isFitMode = v64.enabled
							})
						}),
						EditCTABar = if v67 ~= CreationFlowState.Preview then nil else React.createElement(EditCTABar, {
							zIndex = 4,
							tools = v70,
							onToolSelected = v81,
							showText = v65
						})
					}),
					GalleryView = if v67 == CreationFlowState.Gallery then if captureSource == nil then React.createElement(GalleryView, {
						layoutOrder = 2,
						hasMoreCaptures = false,
						onShowMore = nil,
						captures = v49,
						onCaptureSelected = v77,
						onNextCallback = v78,
						selectedCapture = v68
					}) else React.createElement(GallerySourceView, {
						layoutOrder = 2,
						captureSource = captureSource,
						onCaptureSelected = v77,
						onNextCallback = v78,
						selectedCapture = v68
					}) else nil,
					PreviewView = if v67 ~= CreationFlowState.Preview then nil else React.createElement(PreviewView, {
						layoutOrder = 2,
						onContinueCallback = v79,
						onReturnToGalleryCallback = if p1.excludeGallery then nil else v83
					}),
					ActiveStepEditor = v88("Step"),
					DescriptionView = if v67 ~= CreationFlowState.Description then nil else React.createElement(DescriptionView, {
						layoutOrder = 2,
						onPublish = v84,
						onReturnToEditing = v80
					})
				}),
				MusicView = v88("Overlay")
			})
		}),
		Modal = v87()
	})

	return React.createElement(CreationMediaProvider, {
		preview = v60.preview,
		getSelectedCapture = v60.getSelectedCapture
	}, v95)
end
local function CreationFlowScreen(t4: {[any]: any}) -- line: 531
	-- upvalues: React (copy), isTextFiltered (copy), v48 (copy), publishMoment (copy), FoundationProvider (copy), Theme (copy), CreationControllerProvider (copy), CreationFlowContent (copy)
	local onExit = t4.onExit
	local host = t4.host
	local captureSource = t4.captureSource
	local v100 = React.useMemo(function() -- line: 536
		-- upvalues: host (copy), onExit (copy), captureSource (copy), isTextFiltered (copy), v48 (copy), publishMoment (copy)
		if host ~= nil then
			return host
		end

		return {
			exitCreationFlow = onExit,
			captureSource = captureSource,
			isTextFiltered = isTextFiltered,
			createMoment = if not v48 then publishMoment else function(_, _, s3: string) -- line: 545
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
			host = v100,
			excludeGallery = t4.excludeGallery
		}, {
			Content = React.createElement(CreationFlowContent, {
				excludeGallery = t4.excludeGallery,
				captureSource = v100.captureSource
			})
		})
	})
end

return CreationFlowScreen
