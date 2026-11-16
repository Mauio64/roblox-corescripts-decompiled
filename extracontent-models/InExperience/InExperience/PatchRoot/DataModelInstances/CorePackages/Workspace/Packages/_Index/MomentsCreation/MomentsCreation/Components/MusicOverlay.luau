local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local Button = Foundation.Button
local Icon = Foundation.Icon
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local TextInput = Foundation.TextInput
local View = Foundation.View

local MagnifyingGlass = BuilderIcons.Icon.MagnifyingGlass

local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)
local MusicEditor = require(MomentsCreation.Components.MusicEditor)
local MusicPreviewItem = require(MomentsCreation.Components.MusicPreviewItem)
local GetMusicStore = require(MomentsCreation.Stores.GetMusicStore)

local GetFFlagMomentsCreationMusicSearchStateFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationMusicSearchStateFix)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local useCallback = React.useCallback
local useEffect = React.useEffect

local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local function MusicOverlay(p)
	local controller = p.controller
	local playback = controller.preview.playback

	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()
	local musicStore = GetMusicStore()

	local state, setState = useState("")
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(false)

	local state4, setState4 = useState(playback.getTimeLength(false))
	local state5, setState5 = useState(musicStore.getResults(false))
	local state6, setState6 = useState(musicStore.getSearchStatus(false))

	useEffect(function()
		return Signals.createEffect(function(p2)
			setState4(playback.getTimeLength(p2))
			setState5(musicStore.getResults(p2))
			setState6(musicStore.getSearchStatus(p2))
		end)
	end, { playback, musicStore })

	local state7, setState7 = useState(nil)
	useEffect(function()
		return Signals.createEffect(function(p2)
			local activeSession = controller.getActiveSession(p2)
			local v4

			if activeSession ~= nil then
				v4 = activeSession.getDraft(p2)
			end

			setState7(v4)
		end)
	end, { controller })

	local v4 = useAudioPlayback(state2 ~= nil, state2, { autoplay = true, looping = false })

	useEffect(function()
		playback.pause()
		musicStore.search("", state4)
	end, { state4 })

	useEffect(function()
		if not v4.playback.isPlaying then
			setState2(nil)
		end
	end, { v4.playback.isPlaying })

	local onActivated = useCallback(function()
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, { controller, playback })

	local onMusicSelected = useCallback(function(assetId: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update({ assetId = assetId, startTime = 0 })
		end

		setState2(nil)
		setState3(true)

		local v5 = { musicAssetId = tostring(assetId) }

		for k, v6 in makeCreationEventFields.makeToolFieldFromKind("music") do
			v5[k] = v6
		end

		local sessionId = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		for k, v6 in makeCreationEventFields.makeCreationBaseFields(sessionId) do
			v5[k] = v6
		end

		fireAnalyticsEvent(EventNames.EditingFlowMusicSelected, v5)
	end, { controller })

	local onBack = useCallback(function()
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update(nil)
		end

		setState3(false)
		playback.pause()
	end, { controller, playback })

	local onDone = useCallback(function()
		setState3(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, { controller, playback })

	local onStartTimeChanged = useCallback(function(startTime: number)
		local activeSession = controller.getActiveSession(false)
		local v5

		if activeSession ~= nil then
			v5 = activeSession.getDraft(false)
		end

		if activeSession ~= nil and v5 ~= nil then
			activeSession.update({ assetId = v5.assetId, startTime = startTime })
		end
	end, { controller })

	local togglePreviewMusic = useCallback(function(p2: number)
		if state2 == p2 then
			setState2(nil)
			return
		end

		setState2(p2)
		v4.playback.play()
	end, { state2 })

	local v5 = useCallback(function()
		if state2 ~= nil then
			setState2(nil)
		end

		musicStore.search(state, state4)
	end, { state2, state, state4 })

	local onActivated2 = useCallback(function()
		musicStore.search(state, state4)
	end, { musicStore, state, state4 })

	if state3 and state7 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = state7,
			onBack = onBack,
			onDone = onDone,
			onStartTimeChanged = onStartTimeChanged
		})
	end

	local duration = v4.timeline.duration
	local v6 = not (duration > 0) and 0 or v4.timeline.elapsed / duration

	local fFlagMomentsCreationMusicSearchStateFix = GetFFlagMomentsCreationMusicSearchStateFix()
	local v7

	if #state5 > 0 then
		v7 = Dash.map(state5, function(p2, layoutOrder)
			local createElement = React.createElement
			local v8 = {
				key = p2.AssetId,
				layoutOrder = layoutOrder,
				musicAssetId = p2.AssetId,
				onMusicSelected = onMusicSelected,
				togglePreviewMusic = togglePreviewMusic,
				progress = 0,
				isPreviewing = 0
			}
			local progress

			if state2 == p2.AssetId then
				progress = v6
			end

			v8.progress = progress
			v8.isPreviewing = state2 == p2.AssetId
			return createElement(MusicPreviewItem, v8)
		end)
	elseif not (fFlagMomentsCreationMusicSearchStateFix and state6 == "loading") then
		if fFlagMomentsCreationMusicSearchStateFix and state6 == "error" then
			v7 = {
				SearchError = React.createElement(Text, {
					LayoutOrder = 1,
					Text = v3.MusicSearchError,
					tag = "auto-y text-body-medium text-align-x-center content-action-emphasis"
				}),
				Retry = React.createElement(Button, {
					LayoutOrder = 2,
					onActivated = onActivated2,
					size = Foundation.Enums.InputSize.Small,
					text = v3.GeneralCtaRetry,
					variant = Foundation.Enums.ButtonVariant.Standard
				})
			}
		else
			v7 = {
				NoResults = React.createElement(Text, {
					LayoutOrder = fFlagMomentsCreationMusicSearchStateFix and 1 or nil,
					Text = v3.MusicNoResults,
					tag = {
						["auto-y padding-top-large text-body-medium text-align-x-center content-action-emphasis"] = fFlagMomentsCreationMusicSearchStateFix,
						["text-body-medium text-align-x-center content-action-emphasis"] = not fFlagMomentsCreationMusicSearchStateFix
					}
				})
			}
		end
	end

	return React.createElement(View, {
		onActivated = function() end,
		Size = UDim2.fromScale(1, 2 / 3),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v2.Padding.Medium),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}, {
		ModalHeaderBar = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-action-emphasis",
					Text = v3.EditingCtaMusic
				}),
				CloseButton = React.createElement(
					View,
					{
						onActivated = onActivated,
						tag = "auto-xy padding-medium radius-medium",
						LayoutOrder = 2
					},
					{
						CloseIcon = React.createElement(Icon, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							name = "icons/navigation/close",
							Position = UDim2.fromScale(0.5, 0.5),
							style = v2.Color.ActionEmphasis.Foreground,
							ZIndex = 2
						})
					}
				)
			}
		),
		SearchBar = React.createElement(TextInput, {
			iconLeading = MagnifyingGlass,
			text = state,
			placeholder = v3.GeneralSearchPlaceholder,
			label = "",
			onChanged = setState,
			onReturnPressed = v5,
			onFocusLost = v5,
			LayoutOrder = 2,
			width = UDim.new(1, 0)
		}),
		ScrollView = React.createElement(ScrollView, {
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v2.Gap.Small)
			},
			LayoutOrder = 3,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			tag = "col align-x-left align-y-top size-full"
		}, v7)
	})
end

return MusicOverlay
