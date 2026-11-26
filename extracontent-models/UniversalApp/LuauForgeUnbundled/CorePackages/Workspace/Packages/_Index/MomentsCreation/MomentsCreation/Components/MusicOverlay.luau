local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local button = Foundation.Button
local icon = Foundation.Icon
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local scrollView = Foundation.ScrollView
local text = Foundation.Text
local textInput = Foundation.TextInput
local view = Foundation.View

local magnifyingGlass = BuilderIcons.Icon.MagnifyingGlass

local useAudioPlayback = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useAudioPlayback")
local MusicEditor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicEditor")
local MusicPreviewItem = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicPreviewItem")
local GetMusicStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetMusicStore")

local GetFFlagMomentsCreationMusicSearchStateFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsCreationMusicSearchStateFix")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames

local useCallback = React.useCallback
local useEffect = React.useEffect

local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens

local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local function MusicOverlay(p2)
	local controller = p2.controller
	local playback = controller.preview.playback

	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()
	local v8 = GetMusicStore()

	local state, setState = useState("")
	local state2, setState2 = useState(nil)
	local state3, setState3 = useState(false)

	local state4, setState4 = useState(playback.getTimeLength(false))
	local state5, setState5 = useState(v8.getResults(false))
	local state6, setState6 = useState(v8.getSearchStatus(false))

	useEffect(function()
		return Signals.createEffect(function(p3)
			setState4(playback.getTimeLength(p3))
			setState5(v8.getResults(p3))
			setState6(v8.getSearchStatus(p3))
		end)
	end, { playback, v8 })

	local state7, setState7 = useState(nil)
	useEffect(function()
		return Signals.createEffect(function(p3)
			local activeSession = controller.getActiveSession(p3)
			local v10 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			setState7(v10)
		end)
	end, { controller })

	local v9 = useAudioPlayback(state2 ~= nil, state2, { autoplay = true, looping = false })

	useEffect(function()
		playback.pause()
		v8.search("", state4)
	end, { state4 })

	useEffect(function()
		if not v9.playback.isPlaying then
			setState2(nil)
		end
	end, { v9.playback.isPlaying })

	local v10 = useCallback(function()
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, { controller, playback })

	local v11 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update({ assetId = p3, startTime = 0 })
		end

		setState2(nil)
		setState3(true)

		local v12 = { musicAssetId = tostring(p3) }

		for k, v13 in makeCreationEventFields.makeToolFieldFromKind("music") do
			v12[k] = v13
		end

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)

		for k, v13 in makeCreationEventFields.makeCreationBaseFields(sessionId) do
			v12[k] = v13
		end

		fireAnalyticsEvent(eventNames.EditingFlowMusicSelected, v12)
	end, { controller })

	local v12 = useCallback(function()
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update(nil)
		end

		setState3(false)
		playback.pause()
	end, { controller, playback })

	local v13 = useCallback(function()
		setState3(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, { controller, playback })

	local v14 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)
		local v15 = if activeSession ~= nil then activeSession.getDraft(false) else nil

		if activeSession ~= nil and v15 ~= nil then
			activeSession.update({ assetId = v15.assetId, startTime = p3 })
		end
	end, { controller })

	local v15 = useCallback(function(p3)
		if state2 == p3 then
			setState2(nil)
			return
		end

		setState2(p3)
		v9.playback.play()
	end, { state2 })

	local v16 = useCallback(function()
		if state2 ~= nil then
			setState2(nil)
		end

		v8.search(state, state4)
	end, { state2, state, state4 })

	local v17 = useCallback(function()
		v8.search(state, state4)
	end, { v8, state, state4 })

	if state3 and state7 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = state7,
			onBack = v12,
			onDone = v13,
			onStartTimeChanged = v14
		})
	end

	local duration = v9.timeline.duration
	local v18 = not (duration > 0) and 0 or v9.timeline.elapsed / duration

	local v19 = GetFFlagMomentsCreationMusicSearchStateFix()
	local v20

	if #state5 > 0 then
		v20 = Dash.map(state5, function(p3, p4)
			local createElement = React.createElement
			local v22 = {
				key = p3.AssetId,
				layoutOrder = p4,
				musicAssetId = p3.AssetId,
				onMusicSelected = v11,
				togglePreviewMusic = v15,
				progress = 0,
				isPreviewing = 0
			}

			local v23 = if state2 == p3.AssetId then v18 else nil
			v22.progress = v23
			v22.isPreviewing = state2 == p3.AssetId
			return createElement(MusicPreviewItem, v22)
		end)
	elseif not (v19 and state6 == "loading") then
		if v19 and state6 == "error" then
			v20 = {
				SearchError = React.createElement(text, {
					LayoutOrder = 1,
					Text = v7.MusicSearchError,
					tag = "auto-y text-body-medium text-align-x-center content-action-emphasis"
				}),
				Retry = React.createElement(button, {
					LayoutOrder = 2,
					onActivated = v17,
					size = Foundation.Enums.InputSize.Small,
					text = v7.GeneralCtaRetry,
					variant = Foundation.Enums.ButtonVariant.Standard
				})
			}
		else
			v20 = {
				NoResults = React.createElement(text, {
					LayoutOrder = v19 and 1 or nil,
					Text = v7.MusicNoResults,
					tag = {
						["auto-y padding-top-large text-body-medium text-align-x-center content-action-emphasis"] = v19,
						["text-body-medium text-align-x-center content-action-emphasis"] = not v19
					}
				})
			}
		end
	end

	return React.createElement(view, {
		onActivated = function() end,
		Size = UDim2.fromScale(1, 2 / 3),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v6.Padding.Medium),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}, {
		ModalHeaderBar = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
			},
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-action-emphasis",
					Text = v7.EditingCtaMusic
				}),
				CloseButton = React.createElement(
					view,
					{
						onActivated = v10,
						tag = "auto-xy padding-medium radius-medium",
						LayoutOrder = 2
					},
					{
						CloseIcon = React.createElement(icon, {
							AnchorPoint = Vector2.new(0.5, 0.5),
							name = "icons/navigation/close",
							Position = UDim2.fromScale(0.5, 0.5),
							style = v6.Color.ActionEmphasis.Foreground,
							ZIndex = 2
						})
					}
				)
			}
		),
		SearchBar = React.createElement(textInput, {
			iconLeading = magnifyingGlass,
			text = state,
			placeholder = v7.GeneralSearchPlaceholder,
			label = "",
			onChanged = setState,
			onReturnPressed = v16,
			onFocusLost = v16,
			LayoutOrder = 2,
			width = UDim.new(1, 0)
		}),
		ScrollView = React.createElement(scrollView, {
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v6.Gap.Small)
			},
			LayoutOrder = 3,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = scrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			tag = "col align-x-left align-y-top size-full"
		}, v20)
	})
end

return MusicOverlay
