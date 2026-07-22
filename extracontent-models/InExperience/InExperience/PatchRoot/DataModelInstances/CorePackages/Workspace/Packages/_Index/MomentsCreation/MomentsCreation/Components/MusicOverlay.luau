local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Dash = require(MomentsCreationParent.Dash)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local Button = Foundation.Button
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
require(MomentsCreationParent.MomentsTypes)

local function MusicOverlay(t1: {[any]: any}) -- line: 64
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), GetMusicStore (copy), useState (copy), useEffect (copy), Signals (copy), useAudioPlayback (copy), useCallback (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy), React (copy), MusicEditor (copy), GetFFlagMomentsCreationMusicSearchStateFix (copy), Dash (copy), MusicPreviewItem (copy), FoundationText (copy), Button (copy), Foundation (copy), View (copy), Icon (copy), TextInput (copy), MagnifyingGlass (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local controller = t1.controller
	local playback = controller.preview.playback
	local v37 = useDeviceInsets()
	local v38 = useTokens()
	local v39 = useCreationFlowStrings()
	local v40 = GetMusicStore()
	local v41, v42 = useState("")
	local v43, v44 = useState(nil)
	local v45, v46 = useState(false)
	local v47, v48 = useState(playback.getTimeLength(false))
	local v49, v50 = useState(v40.getResults(false))
	local v51, v52 = useState(v40.getSearchStatus(false))

	useEffect(function() -- line: 81
		-- upvalues: Signals (copy), v48 (copy), playback (copy), v50 (copy), v40 (copy), v52 (copy)
		return Signals.createEffect(function(p1) -- line: 82
			-- upvalues: v48 (copy), playback (copy), v50 (copy), v40 (copy), v52 (copy)
			v48(playback.getTimeLength(p1))
			v50(v40.getResults(p1))
			v52(v40.getSearchStatus(p1))
		end)
	end, {
		playback,
		v40
	})

	local v53, v54 = useState(nil)

	useEffect(function() -- line: 91
		-- upvalues: Signals (copy), controller (copy), v54 (copy)
		return Signals.createEffect(function(p2) -- line: 92
			-- upvalues: controller (copy), v54 (copy)
			local v85 = controller.getActiveSession(p2)

			v54(if v85 == nil then nil else v85.getDraft(p2))
		end)
	end, { controller })

	local v55 = useAudioPlayback(v43 ~= nil, v43, {
		autoplay = true,
		looping = false
	})

	useEffect(function() -- line: 105
		-- upvalues: playback (copy), v40 (copy), v47 (copy)
		playback.pause()
		v40.search("", v47)
	end, { v47 })
	useEffect(function() -- line: 111
		-- upvalues: v55 (copy), v44 (copy)
		if not v55.playback.isPlaying then
			v44(nil)
		end
	end, { v55.playback.isPlaying })

	local v56 = useCallback(function() -- line: 117
		-- upvalues: playback (copy), controller (copy)
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, {
		controller,
		playback
	})
	local v57 = useCallback(function(n1: number) -- line: 123
		-- upvalues: controller (copy), v44 (copy), v46 (copy), makeCreationEventFields (copy), SessionManager (copy), FunnelEventNames (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local v69 = controller.getActiveSession(false)

		if v69 ~= nil then
			v69.update({
				startTime = 0,
				assetId = n1
			})
		end

		v44(nil)
		v46(true)

		local t2 = {
			musicAssetId = tostring(n1)
		}

		for v71, v72 in makeCreationEventFields.makeToolFieldFromKind("music") do
			t2[v71] = v72
		end

		local v73 = SessionManager.getSessionId(FunnelEventNames.FunnelTypes.CreationFlow)

		for v74, v75 in makeCreationEventFields.makeCreationBaseFields(v73) do
			t2[v74] = v75
		end

		fireAnalyticsEvent(EventNames.EditingFlowMusicSelected, t2)
	end, { controller })
	local v58 = useCallback(function() -- line: 148
		-- upvalues: controller (copy), v46 (copy), playback (copy)
		local v76 = controller.getActiveSession(false)

		if v76 ~= nil then
			v76.update(nil)
		end

		v46(false)
		playback.pause()
	end, {
		controller,
		playback
	})
	local v59 = useCallback(function() -- line: 157
		-- upvalues: v46 (copy), playback (copy), controller (copy)
		v46(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, {
		controller,
		playback
	})
	local v60 = useCallback(function(n2: number) -- line: 164
		-- upvalues: controller (copy)
		local v78 = controller.getActiveSession(false)
		local v79 = if v78 == nil then nil else v78.getDraft(false)

		if v78 ~= nil and v79 ~= nil then
			v78.update({
				assetId = v79.assetId,
				startTime = n2
			})
		end
	end, { controller })
	local v61 = useCallback(function(n3: number) -- line: 174
		-- upvalues: v43 (copy), v44 (copy), v55 (copy)
		if n3 == v43 then
			v44(nil)

			return
		end

		v44(n3)
		v55.playback.play()
	end, { v43 })
	local v62 = useCallback(function() -- line: 184
		-- upvalues: v43 (copy), v44 (copy), v40 (copy), v41 (copy), v47 (copy)
		if v43 ~= nil then
			v44(nil)
		end

		v40.search(v41, v47)
	end, {
		v43,
		v41,
		v47
	})
	local v63 = useCallback(function() -- line: 191
		-- upvalues: v40 (copy), v41 (copy), v47 (copy)
		v40.search(v41, v47)
	end, {
		v40,
		v41,
		v47
	})

	if v45 and v53 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = v53,
			onBack = v58,
			onDone = v59,
			onStartTimeChanged = v60
		})
	end

	local duration = v55.timeline.duration
	local v65 = not (duration > 0) and 0 or v55.timeline.elapsed / duration
	local v66 = GetFFlagMomentsCreationMusicSearchStateFix()
	local v67 = if not (#v49 > 0) then if not v66 or v51 ~= "loading" then if not v66 or v51 ~= "error" then {
		NoResults = React.createElement(FoundationText, {
			tag = "text-body-medium text-align-x-center content-action-emphasis",
			Text = v39.MusicNoResults
		})
	} else {
		SearchError = React.createElement(FoundationText, {
			LayoutOrder = 1,
			tag = "auto-y text-body-medium text-align-x-center content-action-emphasis",
			Text = v39.MusicSearchError
		}),
		Retry = React.createElement(Button, {
			LayoutOrder = 2,
			onActivated = v63,
			size = Foundation.Enums.InputSize.Small,
			text = v39.GeneralCtaRetry,
			variant = Foundation.Enums.ButtonVariant.Standard
		})
	} else nil else Dash.map(v49, function(p3, p4) -- line: 214
		-- upvalues: React (copy), MusicPreviewItem (copy), v57 (copy), v61 (copy), v43 (copy), v65 (copy)
		return React.createElement(MusicPreviewItem, {
			key = p3.AssetId,
			layoutOrder = p4,
			musicAssetId = p3.AssetId,
			onMusicSelected = v57,
			togglePreviewMusic = v61,
			progress = if v43 ~= p3.AssetId then nil else v65,
			isPreviewing = v43 == p3.AssetId
		})
	end)

	return React.createElement(View, {
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		onActivated = function() -- line: 253
		end,
		Size = UDim2.fromScale(1, 0.6666666666666666),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		padding = {
			top = UDim.new(0, v38.Padding.Medium),
			left = UDim.new(0, (math.max(v37.left, v38.Padding.XLarge))),
			right = UDim.new(0, (math.max(v37.right, v38.Padding.XLarge)))
		}
	}, {
		ModalHeaderBar = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-action-emphasis",
				Text = v39.EditingCtaMusic
			}),
			CloseButton = React.createElement(View, {
				tag = "auto-xy padding-medium radius-medium",
				LayoutOrder = 2,
				onActivated = v56
			}, {
				CloseIcon = React.createElement(Icon, {
					name = "icons/navigation/close",
					ZIndex = 2,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					style = v38.Color.ActionEmphasis.Foreground
				})
			})
		}),
		SearchBar = React.createElement(TextInput, {
			label = "",
			LayoutOrder = 2,
			iconLeading = MagnifyingGlass,
			text = v41,
			placeholder = v39.GeneralSearchPlaceholder,
			onChanged = v42,
			onReturnPressed = v62,
			onFocusLost = v62,
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
				Padding = UDim.new(0, v38.Gap.Small)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, v67)
	})
end

return MusicOverlay
