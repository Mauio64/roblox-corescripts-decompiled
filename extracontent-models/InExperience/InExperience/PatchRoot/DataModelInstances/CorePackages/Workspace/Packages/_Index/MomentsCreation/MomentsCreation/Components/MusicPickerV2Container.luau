local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local MusicPicker = require(parent.MusicPicker)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)

local useAudioPlayback = require(MomentsCreation.Hooks.useAudioPlayback)
local MusicEditor = require(MomentsCreation.Components.MusicEditor)
local GetMusicStore = require(MomentsCreation.Stores.GetMusicStore)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
require(MomentsCreation.Types.CreationFlowTypes)
require(MomentsCreation.Types.Music)
require(parent.MomentsTypes)
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)
local FFlagMomentsCreationMusicPickerTabs = require(MomentsCreation.Flags.FFlagMomentsCreationMusicPickerTabs)
local FFlagMomentsAudioSaveButton = MomentsCommon.Flags.FFlagMomentsAudioSaveButton

local EventNames = MomentsCommon.Analytics.EventNames
local SessionManager = MomentsCommon.Analytics.SessionManager
local FunnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets

local musicPicker = MusicPicker.MusicPicker
local MusicPickerContext = MusicPicker.MusicPickerContext

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState

local function toItem(data) -- 1 equivalent call inferred from this helper
	return {
		id = data.AssetId,
		title = data.Title,
		artist = data.Artist,
		thumbnailAssetId = data.AssetId
	}
end

local function mapStatus(state: string): string -- 1 equivalent call inferred from this helper
	if state == "loading" then
		return "loading"
	elseif state == "error" then
		return "error"
	end

	return "success"
end

local function useStoreContent()
	local musicStore = GetMusicStore()
	local v = useCreationFlowStrings()

	local state, setState = useState(musicStore.getResults(false))
	local state2, setState2 = useState(musicStore.getSearchStatus(false))
	local state3, setState3 = useState(false)

	useEffect(function()
		return Signals.createEffect(function(p)
			setState(musicStore.getResults(p))
			setState2(musicStore.getSearchStatus(p))
			setState3(musicStore.getIsLoadingMore(p))
		end)
	end, {})

	return useMemo(function()
		local items = {}

		for k, v2 in state do
			items[k] = toItem(v2) -- inferred equivalent call
		end

		return {
			items = items,
			status = mapStatus(state2), -- inferred equivalent call
			emptyText = v.MusicNoResults,
			errorText = v.MusicSearchError,
			retryText = v.GeneralCtaRetry,
			onRetry = musicStore.retry,
			onLoadMore = musicStore.loadMore,
			isLoadingMore = state3
		}
	end, { state, state2, v, musicStore, state3 })
end

local function useSavedContent() -- 1 equivalent call inferred from this helper
	local v = useCreationFlowStrings()
	return useMemo(function()
		return {
			items = {},
			status = "success",
			emptyState = {
				title = v.MusicSavedEmptyTitle,
				subtitle = v.MusicSavedEmptySubtitle,
				icon = BuilderIcons.Icon.Bookmark
			}
		}
	end, { v })
end

local function MusicPickerV2Container(p)
	local controller = p.controller
	local playback = controller.preview.playback
	local v = useCreationFlowStrings()
	local musicStore = GetMusicStore()
	local v2 = useDeviceInsets()
	local v3 = useStoreContent()
	local content = useSavedContent() -- inferred equivalent call
	local state, setState = useState(nil)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState({})

	local state4, setState4 = useState("")

	local state5, setState5 = useState(playback.getTimeLength(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState5(playback.getTimeLength(p2))
		end)
	end, { playback })

	local state6, setState6 = useState(nil)
	useEffect(function()
		return Signals.createEffect(function(p2)
			local activeSession = controller.getActiveSession(p2)
			local v4

			if activeSession ~= nil then
				v4 = activeSession.getDraft(p2)
			end

			setState6(v4)
		end)
	end, { controller })

	local v4 = useAudioPlayback(state ~= nil, state, { autoplay = true, looping = false })

	useEffect(function()
		playback.pause()
		musicStore.search("", state5)
	end, { state5 })

	useEffect(function()
		if not v4.playback.isPlaying then
			setState(nil)
		end
	end, { v4.playback.isPlaying })

	local onClose = useCallback(function()
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, { controller, playback })

	local onSelect = useCallback(function(assetId: number)
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update({ assetId = assetId, startTime = 0 })
		end

		setState(nil)
		setState2(true)

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

		setState2(false)
		playback.pause()
	end, { controller, playback })

	local onDone = useCallback(function()
		setState2(false)
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

	local togglePreview = useCallback(function(p2: number)
		if state == p2 then
			setState(nil)
			return
		end

		setState(p2)
		v4.playback.play()
	end, { state or 0 })

	local toggleSaved = useCallback(function(p2: number)
		setState3(function(items)
			local result = {}

			for k, item in items do
				if k ~= p2 then
					result[k] = item
				end
			end

			if not items[p2] then
				result[p2] = true
			end

			return result
		end)
	end, {})

	local onQueryChanged = useCallback(function(p2: string)
		setState(nil)
		setState4(p2)
		musicStore.search(p2, state5)
	end, { musicStore, state5 })

	local onTabChanged = useCallback(function(_: string)
		setState(nil)
	end, {})

	local tabs = useMemo(function()
		local v5 = {
			{ id = "trending", label = v.MusicTabTrending, content = v3 }
		}

		if FFlagMomentsAudioSaveButton then
			table.insert(v5, { id = "saved", label = "Saved", content = content })
		end

		return v5
	end, { v, v3, content })

	local v5 = useMemo(function()
		return {
			previewingId = state,
			togglePreview = togglePreview,
			savedIds = state3,
			toggleSaved = toggleSaved,
			showSaveButton = FFlagMomentsAudioSaveButton
		}
	end, {
		state or 0,
		state3,
		togglePreview,
		toggleSaved
	})

	if state2 and state6 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = state6,
			onBack = onBack,
			onDone = onDone,
			onStartTimeChanged = onStartTimeChanged
		})
	end

	return React.createElement(MusicPickerContext.Provider, { value = v5 }, {
		Picker = React.createElement(musicPicker, {
			titleText = v.EditingCtaMusic,
			searchPlaceholder = v.GeneralSearchPlaceholder,
			showTabs = FFlagMomentsCreationMusicPickerTabs and FFlagMomentsAudioSaveButton,
			tabs = tabs,
			searchContent = v3,
			onQueryChanged = onQueryChanged,
			initialQuery = state4,
			onTabChanged = onTabChanged,
			onSelect = onSelect,
			onClose = onClose,
			safeAreaInsets = { left = v2.left, right = v2.right },
			source = "moments"
		})
	})
end

return MusicPickerV2Container
