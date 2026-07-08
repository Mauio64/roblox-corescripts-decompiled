local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Dash = require(MomentsCreationFlowParent.Dash)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Icon = Foundation.Icon
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local View = Foundation.View
local MagnifyingGlass = BuilderIcons.Icon.MagnifyingGlass
local MusicEditor = require(MomentsCreationFlow.Components.MusicEditor)
local MusicPreviewItem = require(MomentsCreationFlow.Components.MusicPreviewItem)
local SearchMusic = require(MomentsCreationFlow.Thunks.SearchMusic)
local useAudioPlayback = MomentsCommon.Hooks.useAudioPlayback
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useDispatch = MomentsCommon.Hooks.useDispatch
local useEffect = React.useEffect
local useMemo = React.useMemo
local useSelector = MomentsCommon.Hooks.useSelector
local useTokens = Foundation.Hooks.useTokens
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local Constants = require(MomentsCreationFlow.Constants)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)
local EventNames = require(MomentsCreationFlow.Analytics.EventNames)

return function(t1: {[any]: any}) -- line: 53
	-- upvalues: useDeviceInsets (copy), useDispatch (copy), useTokens (copy), React (copy), CreationFlowContext (copy), useSelector (copy), Constants (copy), useMemo (copy), useAudioPlayback (copy), useEffect (copy), SearchMusic (copy), useCallback (copy), EventNames (copy), MusicEditor (copy), View (copy), Foundation (copy), FoundationText (copy), CreationFlowLocalization (copy), Icon (copy), TextInput (copy), MagnifyingGlass (copy), ScrollView (copy), ScrollBarVisibility (copy), Dash (copy), MusicPreviewItem (copy)
	local v31 = useDeviceInsets()
	local v32 = useDispatch()
	local v33 = useTokens()
	local v34, v35 = React.useState("")
	local v36, v37 = React.useState(false)
	local v38, v39 = React.useState(nil)
	local v40 = React.useContext(CreationFlowContext)
	local v41 = useSelector(function(p1) -- line: 62
		-- upvalues: Constants (copy)
		return p1[Constants.RoduxKey].CreationFlow.musicList
	end)
	local v42 = useMemo(function() -- line: 66
		-- upvalues: v38 (copy)
		if v38 then
			return (tostring(v38))
		end

		return nil
	end, { v38 })
	local v43 = useAudioPlayback(v38 ~= nil, v42, {
		autoplay = true,
		looping = false
	})

	useEffect(function() -- line: 79
		-- upvalues: t1 (copy), v32 (copy), SearchMusic (copy)
		t1.playbackController.playback.pause()
		v32(SearchMusic("", t1.playbackController.timeline.timeLength))
	end, { t1.playbackController.timeline.timeLength })
	useEffect(function() -- line: 84
		-- upvalues: v43 (copy), v39 (copy)
		if not v43.playback.isPlaying then
			v39(nil)
		end
	end, { v43.playback.isPlaying })

	local v44 = useCallback(function(n1: number) -- line: 90
		-- upvalues: t1 (copy), v39 (copy), v37 (copy), v40 (copy), EventNames (copy)
		t1.onMusicUpdate({
			startTime = 0,
			assetId = n1
		})
		t1.playbackController.timeline.seek(0)
		v39(nil)
		v37(true)
		v40.fireEvent(EventNames.EditingFlowMusicSelected, {
			musicAssetId = tostring(n1)
		})
	end, { t1.onMusicUpdate })
	local v45 = useCallback(function() -- line: 101
		-- upvalues: t1 (copy)
		t1.onMusicDiscard()
		t1.playbackController.playback.play()
		t1.playbackController.volume.unmute()
	end, { t1.onMusicDiscard })
	local v46 = useCallback(function() -- line: 107
		-- upvalues: t1 (copy), v37 (copy)
		t1.onMusicUpdate(nil)
		v37(false)
		t1.playbackController.playback.pause()
	end, { t1.onMusicUpdate })
	local v47 = useCallback(function() -- line: 113
		-- upvalues: t1 (copy), v37 (copy)
		t1.onMusicSave()
		v37(false)
		t1.playbackController.playback.play()
		t1.playbackController.volume.unmute()
	end, { t1.onMusicSave })
	local v48 = useCallback(function(n2: number) -- line: 120
		-- upvalues: v38 (copy), v39 (copy), v43 (copy)
		if v38 and n2 == v38 then
			v39(nil)

			return
		end

		v39(n2)
		v43.playback.play()
	end, { v38 })
	local v49 = useCallback(function() -- line: 129
		-- upvalues: v38 (copy), v39 (copy), v32 (copy), SearchMusic (copy), v34 (copy), t1 (copy)
		if v38 then
			v39(nil)
		end

		v32(SearchMusic(v34, t1.playbackController.timeline.timeLength))
	end, {
		v38,
		v34,
		t1.playbackController.timeline.timeLength
	})
	local v50 = useCallback(function(n3: number) -- line: 136
		-- upvalues: t1 (copy)
		if not t1.musicEdit then
			return
		end

		t1.onMusicUpdate({
			assetId = t1.musicEdit.assetId,
			startTime = n3
		})
	end, {
		t1.musicEdit,
		t1.onMusicUpdate
	})

	if v36 then
		return React.createElement(MusicEditor, {
			playbackController = t1.playbackController,
			musicEdit = t1.musicEdit,
			onBack = v46,
			onStartTimeChanged = v50,
			onDone = v47
		})
	end

	return React.createElement(View, {
		tag = "align-x-center align-y-top anchor-bottom-center bg-surface-100 col gap-small position-bottom-center radius-medium size-full-0",
		ZIndex = 5,
		onActivated = function() -- line: 155
		end,
		Size = UDim2.fromScale(1, 0.6666666666666666),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v33.Padding.Medium),
			PaddingLeft = UDim.new(0, (math.max(v31.left, v33.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v31.right, v33.Padding.XLarge)))
		}),
		ModalHeaderBar = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center align-y-center auto-y flex-between row size-full-0"
		}, {
			InspectTitle = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "text-heading-small content-action-emphasis text-truncate-end text-align-x-left text-align-y-top auto-xy",
				Text = v40.getLocalization(CreationFlowLocalization.EditingCtaMusic)
			}),
			CloseButton = React.createElement(View, {
				tag = "auto-xy padding-medium radius-medium",
				LayoutOrder = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				onActivated = v45,
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				CloseIcon = React.createElement(Icon, {
					name = "icons/navigation/close",
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					style = v33.Color.ActionEmphasis.Foreground
				})
			})
		}),
		SearchBar = React.createElement(View, {
			LayoutOrder = 2,
			tag = "align-x-center align-y-center col gap-small size-full-0 auto-y"
		}, {
			Input = React.createElement(TextInput, {
				label = "",
				LayoutOrder = 1,
				iconLeading = MagnifyingGlass,
				text = v34,
				placeholder = v40.getLocalization(CreationFlowLocalization.GeneralSearchPlaceholder),
				onChanged = v35,
				onReturnPressed = v49,
				onFocusLost = v49,
				width = UDim.new(1, 0)
			})
		}),
		ScrollView = React.createElement(ScrollView, {
			LayoutOrder = 3,
			tag = "align-x-left align-y-top col size-full",
			flexItem = {
				FlexMode = Enum.UIFlexMode.Shrink
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v33.Gap.Small)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, if not v41 or not (#v41 > 0) then {
			NoResults = React.createElement(FoundationText, {
				tag = "text-body-medium content-action-emphasis text-align-x-center",
				Text = v40.getLocalization(CreationFlowLocalization.MusicNoResults)
			})
		} else Dash.map(v41, function(p2, p3) -- line: 232
			-- upvalues: React (copy), MusicPreviewItem (copy), v44 (copy), v48 (copy), v38 (copy), v43 (copy)
			return React.createElement(MusicPreviewItem, {
				key = p2,
				layoutOrder = p3,
				musicAssetId = p2,
				onMusicSelected = v44,
				togglePreviewMusic = v48,
				progress = if p2 ~= v38 then nil else v43.timeline.elapsed / v43.timeline.duration,
				isPreviewing = p2 == v38
			})
		end))
	})
end
