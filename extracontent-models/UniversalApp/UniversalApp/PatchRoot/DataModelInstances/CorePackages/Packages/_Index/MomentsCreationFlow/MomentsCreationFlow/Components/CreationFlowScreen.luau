local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
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
local t1 = {
	rotation = 0,
	scale = 1,
	text = "",
	zIndex = 1,
	position = UDim2.fromScale(0.5, 0.5),
	textOverlayStyle = {
		fontSize = 16,
		font = Enum.Font.BuilderSansMedium,
		fontColor = Color3.new(0, 0, 0),
		textXAlignment = Enum.TextXAlignment.Center
	}
}

return function(t2: {[any]: any}) -- line: 86
	-- upvalues: useDispatch (copy), useDeviceInsets (copy), useTokens (copy), useFormFactor (copy), useToggleState (copy), useAutoDismissState (copy), React (copy), CreationFlowContext (copy), useCallback (copy), useRef (copy), useSelector (copy), Constants (copy), useMemo (copy), useUnifiedPlayback (copy), getContentFromCapture (copy), EventNames (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), DialogType (copy), makeMomentMetadata (copy), makeRegistrationInfo (copy), ClearEdits (copy), TrimEditUpdated (copy), MusicEditUpdated (copy), TextOverlayEditsUpdated (copy), t1 (copy), SelectedCaptureUpdated (copy), View (copy), Foundation (copy), CreationFlowLocalization (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy), FormFactor (copy), Icon (copy), MusicChip (copy), PlaybackControls (copy), TextOverlayEditor (copy), CaptureView (copy), TextOverlayDisplay (copy), EditCTABar (copy), GalleryView (copy), PreviewView (copy), TrimmingView (copy), TextOverlayView (copy), DescriptionView (copy), MusicOverlay (copy)
	local v51 = useDispatch()
	local v52 = useDeviceInsets()
	local v53 = useTokens()
	local v54 = useFormFactor()
	local v55 = useToggleState(false)
	local v56, v57 = useAutoDismissState()
	local v58 = React.useContext(CreationFlowContext)
	local v59, v60 = React.useState(Vector2.new(0, 0))
	local v61, v62 = React.useState(Vector2.new(0, 0))
	local v63, v64 = React.useState({
		modalType = nil,
		modalProps = nil
	})
	local v65 = useCallback(function(p1) -- line: 99
		-- upvalues: v62 (copy)
		v62(p1.AbsoluteSize)
	end, {})
	local captures = v58.captures
	local v67 = useRef(0)
	local v68 = useSelector(function(p2) -- line: 107
		-- upvalues: Constants (copy)
		return p2[Constants.RoduxKey].CreationFlow.currentState
	end)
	local v69 = useSelector(function(p3) -- line: 111
		-- upvalues: Constants (copy)
		return p3[Constants.RoduxKey].CreationFlow.capture
	end)
	local v70 = useSelector(function(p4) -- line: 115
		-- upvalues: Constants (copy)
		return p4[Constants.RoduxKey].CreationFlow.textOverlayEdits
	end)
	local v71 = useSelector(function(p5) -- line: 119
		-- upvalues: Constants (copy)
		return p5[Constants.RoduxKey].CreationFlow.trimEdit
	end)
	local v72 = useSelector(function(p6) -- line: 123
		-- upvalues: Constants (copy)
		return p6[Constants.RoduxKey].CreationFlow.musicEdit
	end)
	local v73 = useSelector(function(p7) -- line: 127
		-- upvalues: Constants (copy)
		return p7[Constants.RoduxKey].CreationFlow.description
	end)
	local v74, v75 = React.useState(nil)
	local v76, v77 = React.useState(nil)
	local v78, v79 = React.useState(nil)
	local v80 = useMemo(function() -- line: 136
		-- upvalues: v78 (copy), v72 (copy)
		return v78 or v72
	end, {
		v78,
		v72
	})
	local v81 = useMemo(function() -- line: 140
		-- upvalues: v76 (copy), v71 (copy)
		return v76 or v71
	end, {
		v76,
		v71
	})
	local v82 = useUnifiedPlayback(true, {
		autoplay = true,
		looping = true,
		edits = {
			trim = v81,
			music = v80
		},
		content = if not v69 then nil else getContentFromCapture(v69),
		captureType = if not v69 then nil else v69.CaptureType
	})
	local v83 = useCallback(function() -- line: 155
		-- upvalues: v58 (copy), EventNames (copy), v68 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v57 (copy)
		v58.fireEvent(EventNames.EditingFlowNextButtonPressed, {
			editFlowState = v68
		})
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v57()
		v58.fireEvent(EventNames.MomentsEditingFlowContinueToEditButtonPressed)
	end, {
		v57,
		v68
	})
	local v84 = useCallback(function() -- line: 164
		-- upvalues: v58 (copy), EventNames (copy), v68 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v55 (copy)
		v58.fireEvent(EventNames.EditingFlowNextButtonPressed, {
			editFlowState = v68
		})
		v51(CreationFlowStateUpdated(CreationFlowState.Description))
		v55.disable()
		v58.fireEvent(EventNames.MomentsEditingFlowContinueToDescriptionButtonPressed)
	end, { v68 })
	local v85 = useCallback(function(s1: string) -- line: 174
		-- upvalues: v58 (copy), v64 (copy), DialogType (copy)
		local v113 = v58.isTextFiltered(s1)

		if v113 then
			v64({
				modalType = DialogType.TextFiltered,
				modalProps = {
					onConfirm = function() -- line: 180
						-- upvalues: v64 (copy)
						v64(nil)
					end
				}
			})
		end

		return v113
	end, {})
	local v86 = useCallback(function() -- line: 189
		-- upvalues: v85 (copy), v73 (copy), v67 (copy), v71 (copy), v72 (copy), v70 (copy), makeMomentMetadata (copy), v69 (copy), makeRegistrationInfo (copy), v58 (copy), t2 (copy), v51 (copy), ClearEdits (copy), CreationFlowState (copy), EventNames (copy)
		if v85(v73) then
			return
		end

		local elapsed = os.clock()

		if elapsed - v67.current < 0.5 then
			return
		end

		v67.current = elapsed

		local t3 = {
			trim = v71,
			music = v72,
			textOverlays = v70
		}
		local v116 = makeMomentMetadata(v69, v73, t3)
		local v117 = makeRegistrationInfo(v69, v116)

		v58.createMoment(v69, v116, v117)

		if t2.excludeGallery then
			v51(ClearEdits(CreationFlowState.Preview))
		else
			v51(ClearEdits(CreationFlowState.Gallery))
		end

		v58.fireEvent(EventNames.MomentsEditingFlowPublished)
		v58.exitCreationFlow()
	end, {
		v69,
		v73,
		v72,
		v58,
		v70,
		v71,
		t2.excludeGallery
	})
	local v87 = useCallback(function() -- line: 227
		-- upvalues: v58 (copy), EventNames (copy), v68 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy)
		v58.fireEvent(EventNames.EditingFlowReturnButtonPressed, {
			editFlowState = v68
		})
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
	end, { v68 })
	local v88 = useCallback(function() -- line: 235
		-- upvalues: v58 (copy), EventNames (copy), v68 (copy), v64 (copy), v51 (copy), ClearEdits (copy), CreationFlowState (copy), v55 (copy), DialogType (copy)
		v58.fireEvent(EventNames.EditingFlowReturnButtonPressed, {
			editFlowState = v68
		})

		local function onExitCreation() -- line: 240
			-- upvalues: v64 (copy), v51 (copy), ClearEdits (copy), CreationFlowState (copy), v55 (copy)
			v64(nil)
			v51(ClearEdits(CreationFlowState.Gallery))
			v55.disable()
		end

		v64({
			modalType = DialogType.ExitCreationConfirmation,
			modalProps = {
				onCancel = function() -- line: 249
					-- upvalues: v64 (copy)
					v64(nil)
				end,
				onConfirm = onExitCreation
			}
		})
	end, { v68 })
	local v89 = useCallback(function() -- line: 257
		-- upvalues: v77 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v77(nil)
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowTrimBackButtonPressed)
	end, { v58 })
	local v90 = useCallback(function() -- line: 263
		-- upvalues: v51 (copy), TrimEditUpdated (copy), v76 (copy), v77 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v51(TrimEditUpdated(v76))
		v77(nil)
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowTrimDoneButtonPressed)
	end, {
		v76,
		v58
	})
	local v91 = useCallback(function(p8) -- line: 270
		-- upvalues: v77 (copy)
		v77(p8)
	end, {})
	local v92 = useCallback(function() -- line: 274
		-- upvalues: v79 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v79(nil)
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowMusicBackButtonPressed)
	end, {})
	local v93 = useCallback(function() -- line: 280
		-- upvalues: v51 (copy), MusicEditUpdated (copy), v78 (copy), v79 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v51(MusicEditUpdated(v78))
		v79(nil)
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowMusicDoneButtonPressed)
	end, { v78 })
	local v94 = useCallback(function(p9) -- line: 287
		-- upvalues: v79 (copy)
		v79(p9)
	end, {})
	local v95 = useCallback(function() -- line: 291
		-- upvalues: v75 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v75(nil)
		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowTextOverlayBackButtonPressed)
	end, {
		v74,
		v58
	})
	local v96 = useCallback(function() -- line: 297
		-- upvalues: v74 (copy), v51 (copy), TextOverlayEditsUpdated (copy), v85 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy), v75 (copy)
		local v121 = v74 and (v74[1] and v74[1].text)

		if v121 == "" then
			v51(TextOverlayEditsUpdated(nil))
		else
			if v85(v121) then
				return
			end

			v51(TextOverlayEditsUpdated(v74))
		end

		v51(CreationFlowStateUpdated(CreationFlowState.Preview))
		v58.fireEvent(EventNames.EditingFlowTextOverlayDoneButtonPressed)
		v75(nil)
	end, {
		v74,
		v58,
		v85
	})
	local v97 = useCallback(function(t4: {[any]: any}?) -- line: 312
		-- upvalues: v75 (copy)
		v75(t4)
	end, {})
	local v98 = useCallback(function(t5: {[any]: any}?) -- line: 316
		-- upvalues: v51 (copy), TextOverlayEditsUpdated (copy)
		v51(TextOverlayEditsUpdated(t5))
	end, {})
	local v99 = useCallback(function() -- line: 320
		-- upvalues: v75 (copy), v70 (copy), v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy)
		v75(v70)
		v51(CreationFlowStateUpdated(CreationFlowState.TextOverlay))
	end, { v70 })

	React.useEffect(function() -- line: 325
		-- upvalues: v68 (copy), CreationFlowState (copy), v75 (copy), v70 (copy), t1 (copy)
		if v68 == CreationFlowState.TextOverlay then
			v75(v70 or { t1 })
		end
	end, {
		v70,
		v68
	})

	local v100 = useCallback(function() -- line: 331
		-- upvalues: v51 (copy), CreationFlowStateUpdated (copy), CreationFlowState (copy), v58 (copy), EventNames (copy)
		v51(CreationFlowStateUpdated(CreationFlowState.Music))
		v58.fireEvent(EventNames.EditingFlowMusicButtonPressed)
	end, {})
	local v101 = useCallback(function(p10) -- line: 336
		-- upvalues: v51 (copy), SelectedCaptureUpdated (copy), v57 (copy), v58 (copy), EventNames (copy)
		v51(SelectedCaptureUpdated(p10))
		v57()
		v58.fireEvent(EventNames.EditingFlowGalleryItemSelected)
	end, {
		v57,
		v58
	})
	local v102 = React.useCallback(function() -- line: 342
		-- upvalues: React (copy), View (copy), Foundation (copy), v58 (copy), CreationFlowLocalization (copy), v53 (copy)
		return (React.createElement(View, {
			Size = UDim2.fromScale(1, 1),
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			}
		}, {
			ModeratedText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(1, 1),
				Text = v58.getLocalization(CreationFlowLocalization.PostRemovedTitle),
				TextColor3 = v53.Color.Extended.White.White_70
			})
		}))
	end, {})
	local v103 = useCallback(function() -- line: 358
		-- upvalues: v58 (copy), EventNames (copy), v64 (copy), t2 (copy), v51 (copy), ClearEdits (copy), CreationFlowState (copy), v69 (copy), DialogType (copy)
		local function onExitCreation() -- line: 359
			-- upvalues: v58 (copy), EventNames (copy), v64 (copy), t2 (copy), v51 (copy), ClearEdits (copy), CreationFlowState (copy)
			v58.fireEvent(EventNames.MomentsEditingFlowExited)
			v64(nil)

			if t2.excludeGallery then
				v51(ClearEdits(CreationFlowState.Preview))
			else
				v51(ClearEdits(CreationFlowState.Gallery))
			end

			v58.exitCreationFlow()
		end

		if v69 then
			v64({
				modalType = DialogType.ExitCreationConfirmation,
				modalProps = {
					onCancel = function() -- line: 374
						-- upvalues: v64 (copy)
						v64(nil)
					end,
					onConfirm = onExitCreation
				}
			})

			return
		end

		onExitCreation()
	end, {
		v69,
		v58,
		t2.excludeGallery
	})

	React.useEffect(function() -- line: 385
		-- upvalues: v58 (copy)
		v58.setScreenOrientation(Enum.ScreenOrientation.Portrait)

		return function() -- line: 388
			-- upvalues: v58 (copy)
			v58.setScreenOrientation(Enum.ScreenOrientation.Sensor)
		end
	end, {})
	React.useEffect(function() -- line: 393
		-- upvalues: v68 (copy), CreationFlowState (copy), v55 (copy)
		if v68 == CreationFlowState.Gallery or (v68 == CreationFlowState.Music or v68 == CreationFlowState.Description) then
			v55.disable()
		end
	end, { v68 })

	local v104 = React.useCallback(function() -- line: 403
		-- upvalues: v63 (copy), DialogType (copy), React (copy), ExitConfirmationDialog (copy), TextFilteredDialog (copy)
		if not v63 then
			return nil
		end

		if v63.modalType == DialogType.ExitCreationConfirmation then
			return React.createElement(ExitConfirmationDialog, v63.modalProps)
		end

		if v63.modalType == DialogType.TextFiltered then
			return React.createElement(TextFilteredDialog, v63.modalProps)
		end

		return nil
	end, { v63 })

	return React.createElement(View, {
		tag = "anchor-center-center position-center-center size-full-full",
		backgroundStyle = v53.Color.Common.Scrim
	}, {
		CreationFlowView = React.createElement(View, {
			tag = "anchor-center-center bg-surface-0 position-center-center radius-large size-full-full",
			sizeConstraint = {
				MaxSize = if v54 ~= FormFactor.Wide then nil else Vector2.new(600, 700)
			}
		}, {
			CloseButtonContainer = React.createElement(View, {
				tag = "auto-xy anchor-top-right position-top-right"
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v52.top + v53.Padding.Medium),
					PaddingRight = UDim.new(0, v52.right + v53.Padding.Medium)
				}),
				CloseButton = React.createElement(View, {
					LayoutOrder = 1,
					tag = "size-1100-1100 bg-over-media-0 padding-medium radius-circle",
					onActivated = v103
				}, {
					CloseIcon = React.createElement(Icon, {
						name = "icons/navigation/close_small",
						ZIndex = 2,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = Foundation.Enums.IconSize.Small,
						style = v53.Color.ActionEmphasis.Foreground
					})
				})
			}),
			MainViewContainer = React.createElement(View, {
				tag = "size-full"
			}, {
				MainView = React.createElement(View, {
					tag = "size-full col align-x-center"
				}, {
					PreviewContainer = React.createElement("CanvasGroup", {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = v53.Color.None.Transparency
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Custom,
							ShrinkRatio = not v69 and 2 or 1
						}),
						UICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v53.Radius.Large)
						}),
						ClickCapture = React.createElement(View, {
							tag = "size-full",
							ZIndex = 0,
							onActivated = v57,
							stateLayer = {
								affordance = Foundation.Enums.StateLayerAffordance.None
							}
						}),
						PreviewMediaOverlay = React.createElement(View, {
							tag = "auto-y anchor-bottom-center col position-bottom-center size-full-0",
							ZIndex = 5
						}, {
							OtherControls = React.createElement(View, {
								tag = "auto-y padding-x-large padding-bottom-large size-full-0",
								LayoutOrder = 1
							}, {
								Padding = React.createElement("UIPadding", {
									PaddingLeft = UDim.new(0, (math.max(v52.right, v53.Padding.Large))),
									PaddingRight = UDim.new(0, (math.max(v52.right, v53.Padding.Large)))
								}),
								MusicIndicator = if not v72 or v68 ~= CreationFlowState.Preview and v68 ~= CreationFlowState.Description then nil else React.createElement(View, {
									tag = "anchor-bottom-left auto-xy position-bottom-left"
								}, {
									MusicChip = React.createElement(MusicChip, {
										musicAssetId = v72.assetId,
										onActivated = v100
									})
								})
							}),
							PlaybackControls = if not v69 or (v69.CaptureType ~= Enum.CaptureType.Video or (not v56 or v68 ~= CreationFlowState.Gallery and v68 ~= CreationFlowState.Preview)) then nil else React.createElement(PlaybackControls, {
								layoutOrder = 2,
								playbackController = v82,
								toggleFitMode = v55.toggle,
								isFitMode = v55.enabled
							})
						}),
						TextOverlayEditor = if v68 ~= CreationFlowState.TextOverlay then nil else React.createElement(TextOverlayEditor, {
							layoutOrder = 2,
							onTextOverlayDiscard = v95,
							onTextOverlaySave = v96,
							onTextOverlayUpdated = v97,
							textOverlayEdits = v74
						}),
						CaptureView = React.createElement(CaptureView, {
							capture = v69,
							playbackController = v82,
							onAbsoluteSizeChanged = v65,
							onRenderFailed = v102,
							onResolutionChanged = v60,
							scaleType = if not v55.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit
						}, {
							TextOverlayDisplay = React.createElement(TextOverlayDisplay, {
								zIndex = 3,
								draggable = v68 == CreationFlowState.Preview,
								editable = v68 == CreationFlowState.TextOverlay,
								itemResolution = v59,
								itemSize = v61,
								scaleType = if not v55.enabled then Enum.ScaleType.Crop else Enum.ScaleType.Fit,
								onTextOverlayActivated = v99,
								onTextOverlayDragEnd = v98,
								textOverlayEdits = v70
							})
						}),
						EditCTABar = if v68 ~= CreationFlowState.Preview then nil else React.createElement(EditCTABar, {
							zIndex = 4,
							captureType = if not v69 then nil else v69.CaptureType,
							showText = v56
						})
					}),
					GalleryView = if v68 ~= CreationFlowState.Gallery then nil else React.createElement(GalleryView, {
						layoutOrder = 2,
						captures = captures,
						selectedCapture = v69,
						onCaptureSelected = v101,
						onNextCallback = v83
					}),
					PreviewView = if v68 ~= CreationFlowState.Preview then nil else React.createElement(PreviewView, {
						layoutOrder = 2,
						onContinueCallback = v84,
						onReturnToGalleryCallback = if t2.excludeGallery then nil else v88
					}),
					TrimmingView = if v68 ~= CreationFlowState.Trimming then nil else React.createElement(TrimmingView, {
						layoutOrder = 2,
						playbackController = v82,
						onTrimDiscard = v89,
						onTrimSave = v90,
						onTrimUpdate = v91,
						selectedCapture = v69,
						trimEdit = v81
					}),
					TextOverlayView = if v68 ~= CreationFlowState.TextOverlay then nil else React.createElement(TextOverlayView, {
						layoutOrder = 2,
						onTextOverlayDiscard = v95,
						onTextOverlaySave = v96
					}),
					DescriptionView = if v68 ~= CreationFlowState.Description then nil else React.createElement(DescriptionView, {
						layoutOrder = 2,
						onPublish = v86,
						onReturnToEditing = v87
					})
				}),
				MusicView = if v68 ~= CreationFlowState.Music then nil else React.createElement(View, {
					LayoutOrder = 2,
					Size = UDim2.fromScale(1, 1)
				}, {
					MusicOverlay = React.createElement(MusicOverlay, {
						musicEdit = v80,
						playbackController = v82,
						onMusicDiscard = v92,
						onMusicSave = v93,
						onMusicUpdate = v94
					})
				})
			})
		}),
		Modal = v104()
	})
end
