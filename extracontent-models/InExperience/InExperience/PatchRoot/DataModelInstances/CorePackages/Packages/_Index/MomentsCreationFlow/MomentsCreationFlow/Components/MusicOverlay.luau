local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Icon = Foundation.Icon
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
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

return function(props)
	local v = useDeviceInsets()
	local v2 = useDispatch()
	local v3 = useTokens()
	local state, setState = React.useState("")
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(nil)
	local v4 = React.useContext(CreationFlowContext)

	local v5 = useSelector(function(p)
		return p[Constants.RoduxKey].CreationFlow.musicList
	end)

	local v6 = useMemo(function()
		if state3 then
			return (tostring(state3))
		end

		return nil
	end, { state3 })

	local v7 = useAudioPlayback(state3 ~= nil, v6, { autoplay = true, looping = false })

	useEffect(function()
		props.playbackController.playback.pause()
		v2(SearchMusic("", props.playbackController.timeline.timeLength))
	end, { props.playbackController.timeline.timeLength })

	useEffect(function()
		if not v7.playback.isPlaying then
			setState3(nil)
		end
	end, { v7.playback.isPlaying })

	local onMusicSelected = useCallback(function(assetId: number)
		props.onMusicUpdate({ assetId = assetId, startTime = 0 })
		props.playbackController.timeline.seek(0)
		setState3(nil)
		setState2(true)

		v4.fireEvent(EventNames.EditingFlowMusicSelected, { musicAssetId = tostring(assetId) })
	end, { props.onMusicUpdate })

	local onActivated = useCallback(function()
		props.onMusicDiscard()
		props.playbackController.playback.play()
		props.playbackController.volume.unmute()
	end, { props.onMusicDiscard })

	local onBack = useCallback(function()
		props.onMusicUpdate(nil)
		setState2(false)
		props.playbackController.playback.pause()
	end, { props.onMusicUpdate })

	local onDone = useCallback(function()
		props.onMusicSave()
		setState2(false)
		props.playbackController.playback.play()
		props.playbackController.volume.unmute()
	end, { props.onMusicSave })

	local togglePreviewMusic = useCallback(function(p: number)
		if state3 and state3 == p then
			setState3(nil)
			return
		end

		setState3(p)
		v7.playback.play()
	end, { state3 })

	local v8 = useCallback(function()
		if state3 then
			setState3(nil)
		end

		v2(SearchMusic(state, props.playbackController.timeline.timeLength))
	end, { state3, state, props.playbackController.timeline.timeLength })

	local onStartTimeChanged = useCallback(function(startTime: number)
		if not props.musicEdit then
			return
		end

		props.onMusicUpdate({ assetId = props.musicEdit.assetId, startTime = startTime })
	end, { props.musicEdit, props.onMusicUpdate })

	if state2 then
		return React.createElement(MusicEditor, {
			playbackController = props.playbackController,
			musicEdit = props.musicEdit,
			onBack = onBack,
			onStartTimeChanged = onStartTimeChanged,
			onDone = onDone
		})
	end

	local createElement = React.createElement
	local v9 = {
		onActivated = function() end,
		Size = UDim2.fromScale(1, 2 / 3),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "align-x-center align-y-top anchor-bottom-center bg-surface-100 col gap-small position-bottom-center radius-medium size-full-0",
		ZIndex = 5
	}

	local v10 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v3.Padding.Medium),
			PaddingLeft = UDim.new(0, (math.max(v.left, v3.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v.right, v3.Padding.XLarge)))
		}),
		ModalHeaderBar = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "align-x-center align-y-center auto-y flex-between row size-full-0"
			},
			{
				InspectTitle = React.createElement(Text, {
					LayoutOrder = 1,
					tag = "text-heading-small content-action-emphasis text-truncate-end text-align-x-left text-align-y-top auto-xy",
					Text = v4.getLocalization(CreationFlowLocalization.EditingCtaMusic)
				}),
				CloseButton = React.createElement(View, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					onActivated = onActivated,
					Position = UDim2.fromScale(0.5, 0.5),
					tag = "auto-xy padding-medium radius-medium",
					LayoutOrder = 2
				}, {
					CloseIcon = React.createElement(Icon, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						name = "icons/navigation/close",
						Position = UDim2.fromScale(0.5, 0.5),
						style = v3.Color.ActionEmphasis.Foreground,
						ZIndex = 2
					})
				})
			}
		),
		SearchBar = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "align-x-center align-y-center col gap-small size-full-0 auto-y"
			},
			{
				Input = React.createElement(TextInput, {
					iconLeading = MagnifyingGlass,
					text = state,
					placeholder = v4.getLocalization(CreationFlowLocalization.GeneralSearchPlaceholder),
					label = "",
					onChanged = setState,
					onReturnPressed = v8,
					onFocusLost = v8,
					LayoutOrder = 1,
					width = UDim.new(1, 0)
				})
			}
		),
		ScrollView = 0
	}

	local createElement2 = React.createElement

	local v11 = {
		flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, v3.Gap.Small)
		},
		LayoutOrder = 3,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			scrollBarVisibility = ScrollBarVisibility.None,
			ScrollingDirection = Enum.ScrollingDirection.Y
		},
		tag = "align-x-left align-y-top col size-full"
	}
	local v12

	if v5 and #v5 > 0 then
		v12 = Dash.map(v5, function(musicAssetId, layoutOrder)
			local createElement3 = React.createElement
			local v13 = {
				key = musicAssetId,
				layoutOrder = layoutOrder,
				musicAssetId = musicAssetId,
				onMusicSelected = onMusicSelected,
				togglePreviewMusic = togglePreviewMusic,
				progress = 0,
				isPreviewing = 0
			}
			local progress

			if state3 == musicAssetId then
				progress = v7.timeline.elapsed / v7.timeline.duration
			end

			v13.progress = progress

			v13.isPreviewing = state3 == musicAssetId
			return createElement3(MusicPreviewItem, v13)
		end)
	else
		v12 = {
			NoResults = React.createElement(Text, {
				Text = v4.getLocalization(CreationFlowLocalization.MusicNoResults),
				tag = "text-body-medium content-action-emphasis text-align-x-center"
			})
		}
	end

	v10.ScrollView = createElement2(ScrollView, v11, v12)
	return createElement(View, v9, v10)
end
