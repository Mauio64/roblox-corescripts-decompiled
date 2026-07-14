local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local Icon = Foundation.Icon
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local ScrollView = Foundation.ScrollView
local FoundationText = Foundation.Text
local TextInput = Foundation.TextInput
local View = Foundation.View
local MagnifyingGlass = BuilderIcons.Icon.MagnifyingGlass
local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)
local MusicEditor = require(MomentsCreation.Components.MusicEditor)
local MusicPreviewItem = require(MomentsCreation.Components.MusicPreviewItem)
local GetMusicStore = require(MomentsCreation.Stores.GetMusicStore)
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
require(MomentsCreationParent.MomentsTypes)

local function MusicOverlay(t1: {[any]: any}) -- line: 61
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), GetMusicStore (copy), useState (copy), useEffect (copy), Signals (copy), useAudioPlayback (copy), useCallback (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), React (copy), MusicEditor (copy), View (copy), Foundation (copy), FoundationText (copy), Icon (copy), TextInput (copy), MagnifyingGlass (copy), ScrollView (copy), ScrollBarVisibility (copy), Dash (copy), MusicPreviewItem (copy)
	local controller = t1.controller
	local playback = controller.preview.playback
	local v35 = useDeviceInsets()
	local v36 = useTokens()
	local v37 = useCreationFlowStrings()
	local v38 = GetMusicStore()
	local v39, v40 = useState("")
	local v41, v42 = useState(nil)
	local v43, v44 = useState(false)
	local v45, v46 = useState(playback.getTimeLength(false))
	local v47, v48 = useState(v38.getResults(false))

	useEffect(function() -- line: 77
		-- upvalues: Signals (copy), v46 (copy), playback (copy), v48 (copy), v38 (copy)
		return Signals.createEffect(function(p1) -- line: 78
			-- upvalues: v46 (copy), playback (copy), v48 (copy), v38 (copy)
			v46(playback.getTimeLength(p1))
			v48(v38.getResults(p1))
		end)
	end, {
		playback,
		v38
	})

	local v49, v50 = useState(nil)

	useEffect(function() -- line: 86
		-- upvalues: Signals (copy), controller (copy), v50 (copy)
		return Signals.createEffect(function(p2) -- line: 87
			-- upvalues: controller (copy), v50 (copy)
			local v78 = controller.getActiveSession(p2)

			v50(if v78 == nil then nil else v78.getDraft(p2))
		end)
	end, { controller })

	local v51 = useAudioPlayback(v41 ~= nil, v41, {
		autoplay = true,
		looping = false
	})

	useEffect(function() -- line: 100
		-- upvalues: playback (copy), v38 (copy), v45 (copy)
		playback.pause()
		v38.search("", v45)
	end, { v45 })
	useEffect(function() -- line: 106
		-- upvalues: v51 (copy), v42 (copy)
		if not v51.playback.isPlaying then
			v42(nil)
		end
	end, { v51.playback.isPlaying })

	local v52 = useCallback(function() -- line: 112
		-- upvalues: playback (copy), controller (copy)
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, {
		controller,
		playback
	})
	local v53 = useCallback(function(n1: number) -- line: 118
		-- upvalues: controller (copy), v42 (copy), v44 (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local v62 = controller.getActiveSession(false)

		if v62 ~= nil then
			v62.update({
				startTime = 0,
				assetId = n1
			})
		end

		v42(nil)
		v44(true)

		local t2 = {
			musicAssetId = tostring(n1)
		}

		for v64, v65 in makeCreationEventFields.makeToolFieldFromKind("music") do
			t2[v64] = v65
		end

		local v66 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		for v67, v68 in makeCreationEventFields.makeCreationBaseFields(v66) do
			t2[v67] = v68
		end

		fireAnalyticsEvent(EventNames.EditingFlowMusicSelected, t2)
	end, { controller })
	local v54 = useCallback(function() -- line: 143
		-- upvalues: controller (copy), v44 (copy), playback (copy)
		local v69 = controller.getActiveSession(false)

		if v69 ~= nil then
			v69.update(nil)
		end

		v44(false)
		playback.pause()
	end, {
		controller,
		playback
	})
	local v55 = useCallback(function() -- line: 152
		-- upvalues: v44 (copy), playback (copy), controller (copy)
		v44(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, {
		controller,
		playback
	})
	local v56 = useCallback(function(n2: number) -- line: 159
		-- upvalues: controller (copy)
		local v71 = controller.getActiveSession(false)
		local v72 = if v71 == nil then nil else v71.getDraft(false)

		if v71 ~= nil and v72 ~= nil then
			v71.update({
				assetId = v72.assetId,
				startTime = n2
			})
		end
	end, { controller })
	local v57 = useCallback(function(n3: number) -- line: 169
		-- upvalues: v41 (copy), v42 (copy), v51 (copy)
		if n3 == v41 then
			v42(nil)

			return
		end

		v42(n3)
		v51.playback.play()
	end, { v41 })
	local v58 = useCallback(function() -- line: 179
		-- upvalues: v41 (copy), v42 (copy), v38 (copy), v39 (copy), v45 (copy)
		if v41 ~= nil then
			v42(nil)
		end

		v38.search(v39, v45)
	end, {
		v41,
		v39,
		v45
	})

	if v43 and v49 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = v49,
			onBack = v54,
			onDone = v55,
			onStartTimeChanged = v56
		})
	end

	local duration = v51.timeline.duration
	local v60 = not (duration > 0) and 0 or v51.timeline.elapsed / duration

	return React.createElement(View, {
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		onActivated = function() -- line: 200
		end,
		Size = UDim2.fromScale(1, 0.6666666666666666),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		padding = {
			top = UDim.new(0, v36.Padding.Medium),
			left = UDim.new(0, (math.max(v35.left, v36.Padding.XLarge))),
			right = UDim.new(0, (math.max(v35.right, v36.Padding.XLarge)))
		}
	}, {
		ModalHeaderBar = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-action-emphasis",
				Text = v37.EditingCtaMusic
			}),
			CloseButton = React.createElement(View, {
				tag = "auto-xy padding-medium radius-medium",
				LayoutOrder = 2,
				onActivated = v52
			}, {
				CloseIcon = React.createElement(Icon, {
					name = "icons/navigation/close",
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					style = v36.Color.ActionEmphasis.Foreground
				})
			})
		}),
		SearchBar = React.createElement(TextInput, {
			label = "",
			LayoutOrder = 2,
			iconLeading = MagnifyingGlass,
			text = v39,
			placeholder = v37.GeneralSearchPlaceholder,
			onChanged = v40,
			onReturnPressed = v58,
			onFocusLost = v58,
			width = UDim.new(1, 0)
		}),
		ScrollView = React.createElement(ScrollView, {
			LayoutOrder = 3,
			tag = "col align-x-left align-y-top size-full",
			flexItem = {
				FlexMode = Enum.UIFlexMode.Shrink
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, v36.Gap.Small)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, if not (#v47 > 0) then {
			NoResults = React.createElement(FoundationText, {
				tag = "text-body-medium text-align-x-center content-action-emphasis",
				Text = v37.MusicNoResults
			})
		} else Dash.map(v47, function(p3, p4) -- line: 267
			-- upvalues: React (copy), MusicPreviewItem (copy), v53 (copy), v57 (copy), v41 (copy), v60 (copy)
			return React.createElement(MusicPreviewItem, {
				key = p3.AssetId,
				layoutOrder = p4,
				musicAssetId = p3.AssetId,
				onMusicSelected = v53,
				togglePreviewMusic = v57,
				progress = if v41 ~= p3.AssetId then nil else v60,
				isPreviewing = v41 == p3.AssetId
			})
		end))
	})
end

return MusicOverlay
