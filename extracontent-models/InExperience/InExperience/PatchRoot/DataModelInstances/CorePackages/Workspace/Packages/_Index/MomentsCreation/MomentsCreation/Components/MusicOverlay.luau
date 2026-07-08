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
local EventNames = MomentsCommon.Analytics.EventNames
local useCallback = React.useCallback
local useEffect = React.useEffect
local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreationParent.MomentsTypes)

local function MusicOverlay(t1: {[any]: any}) -- line: 58
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), GetMusicStore (copy), useState (copy), useEffect (copy), Signals (copy), useAudioPlayback (copy), useCallback (copy), fireAnalyticsEvent (copy), EventNames (copy), React (copy), MusicEditor (copy), View (copy), Foundation (copy), FoundationText (copy), Icon (copy), TextInput (copy), MagnifyingGlass (copy), ScrollView (copy), ScrollBarVisibility (copy), Dash (copy), MusicPreviewItem (copy)
	local controller = t1.controller
	local playback = controller.preview.playback
	local v32 = useDeviceInsets()
	local v33 = useTokens()
	local v34 = useCreationFlowStrings()
	local v35 = GetMusicStore()
	local v36, v37 = useState("")
	local v38, v39 = useState(nil)
	local v40, v41 = useState(false)
	local v42, v43 = useState(playback.getTimeLength(false))
	local v44, v45 = useState(v35.getResults(false))

	useEffect(function() -- line: 74
		-- upvalues: Signals (copy), v43 (copy), playback (copy), v45 (copy), v35 (copy)
		return Signals.createEffect(function(p1) -- line: 75
			-- upvalues: v43 (copy), playback (copy), v45 (copy), v35 (copy)
			v43(playback.getTimeLength(p1))
			v45(v35.getResults(p1))
		end)
	end, {
		playback,
		v35
	})

	local v46, v47 = useState(nil)

	useEffect(function() -- line: 83
		-- upvalues: Signals (copy), controller (copy), v47 (copy)
		return Signals.createEffect(function(p2) -- line: 84
			-- upvalues: controller (copy), v47 (copy)
			local v69 = controller.getActiveSession(p2)

			v47(if v69 == nil then nil else v69.getDraft(p2))
		end)
	end, { controller })

	local v48 = useAudioPlayback(v38 ~= nil, v38, {
		autoplay = true,
		looping = false
	})

	useEffect(function() -- line: 97
		-- upvalues: playback (copy), v35 (copy), v42 (copy)
		playback.pause()
		v35.search("", v42)
	end, { v42 })
	useEffect(function() -- line: 103
		-- upvalues: v48 (copy), v39 (copy)
		if not v48.playback.isPlaying then
			v39(nil)
		end
	end, { v48.playback.isPlaying })

	local v49 = useCallback(function() -- line: 109
		-- upvalues: playback (copy), controller (copy)
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, {
		controller,
		playback
	})
	local v50 = useCallback(function(n1: number) -- line: 115
		-- upvalues: controller (copy), v39 (copy), v41 (copy), fireAnalyticsEvent (copy), EventNames (copy)
		local v59 = controller.getActiveSession(false)

		if v59 ~= nil then
			v59.update({
				startTime = 0,
				assetId = n1
			})
		end

		v39(nil)
		v41(true)
		fireAnalyticsEvent(EventNames.EditingFlowMusicSelected, {
			musicAssetId = tostring(n1)
		})
	end, { controller })
	local v51 = useCallback(function() -- line: 131
		-- upvalues: controller (copy), v41 (copy), playback (copy)
		local v60 = controller.getActiveSession(false)

		if v60 ~= nil then
			v60.update(nil)
		end

		v41(false)
		playback.pause()
	end, {
		controller,
		playback
	})
	local v52 = useCallback(function() -- line: 140
		-- upvalues: v41 (copy), playback (copy), controller (copy)
		v41(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, {
		controller,
		playback
	})
	local v53 = useCallback(function(n2: number) -- line: 147
		-- upvalues: controller (copy)
		local v62 = controller.getActiveSession(false)
		local v63 = if v62 == nil then nil else v62.getDraft(false)

		if v62 ~= nil and v63 ~= nil then
			v62.update({
				assetId = v63.assetId,
				startTime = n2
			})
		end
	end, { controller })
	local v54 = useCallback(function(n3: number) -- line: 157
		-- upvalues: v38 (copy), v39 (copy), v48 (copy)
		if n3 == v38 then
			v39(nil)

			return
		end

		v39(n3)
		v48.playback.play()
	end, { v38 })
	local v55 = useCallback(function() -- line: 167
		-- upvalues: v38 (copy), v39 (copy), v35 (copy), v36 (copy), v42 (copy)
		if v38 ~= nil then
			v39(nil)
		end

		v35.search(v36, v42)
	end, {
		v38,
		v36,
		v42
	})

	if v40 and v46 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = v46,
			onBack = v51,
			onDone = v52,
			onStartTimeChanged = v53
		})
	end

	local duration = v48.timeline.duration
	local v57 = not (duration > 0) and 0 or v48.timeline.elapsed / duration

	return React.createElement(View, {
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		onActivated = function() -- line: 188
		end,
		Size = UDim2.fromScale(1, 0.6666666666666666),
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		padding = {
			top = UDim.new(0, v33.Padding.Medium),
			left = UDim.new(0, (math.max(v32.left, v33.Padding.XLarge))),
			right = UDim.new(0, (math.max(v32.right, v33.Padding.XLarge)))
		}
	}, {
		ModalHeaderBar = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-action-emphasis",
				Text = v34.EditingCtaMusic
			}),
			CloseButton = React.createElement(View, {
				tag = "auto-xy padding-medium radius-medium",
				LayoutOrder = 2,
				onActivated = v49
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
		SearchBar = React.createElement(TextInput, {
			label = "",
			LayoutOrder = 2,
			iconLeading = MagnifyingGlass,
			text = v36,
			placeholder = v34.GeneralSearchPlaceholder,
			onChanged = v37,
			onReturnPressed = v55,
			onFocusLost = v55,
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
				Padding = UDim.new(0, v33.Gap.Small)
			},
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				scrollBarVisibility = ScrollBarVisibility.None,
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, if not (#v44 > 0) then {
			NoResults = React.createElement(FoundationText, {
				tag = "text-body-medium text-align-x-center content-action-emphasis",
				Text = v34.MusicNoResults
			})
		} else Dash.map(v44, function(p3, p4) -- line: 255
			-- upvalues: React (copy), MusicPreviewItem (copy), v50 (copy), v54 (copy), v38 (copy), v57 (copy)
			return React.createElement(MusicPreviewItem, {
				key = p3.AssetId,
				layoutOrder = p4,
				musicAssetId = p3.AssetId,
				onMusicSelected = v50,
				togglePreviewMusic = v54,
				progress = if v38 ~= p3.AssetId then nil else v57,
				isPreviewing = v38 == p3.AssetId
			})
		end))
	})
end

return MusicOverlay
