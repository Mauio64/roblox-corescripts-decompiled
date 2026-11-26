local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local MusicPicker = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MusicPicker")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local useAudioPlayback = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useAudioPlayback")
local MusicEditor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicEditor")
local GetMusicStore = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/GetMusicStore")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/Music")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")
local FFlagMomentsCreationMusicPickerTabs = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicPickerTabs")
local fFlagMomentsAudioSaveButton = MomentsCommon.Flags.FFlagMomentsAudioSaveButton

local eventNames = MomentsCommon.Analytics.EventNames
local sessionManager = MomentsCommon.Analytics.SessionManager
local funnelEventNames = MomentsCommon.Analytics.FunnelEventNames
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets

local musicPicker = MusicPicker.MusicPicker
local musicPickerContext = MusicPicker.MusicPickerContext

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState

local function toItem(data)
	return {
		id = data.AssetId,
		title = data.Title,
		artist = data.Artist,
		thumbnailAssetId = data.AssetId
	}
end

local function mapStatus(p2): string
	if p2 == "loading" then
		return "loading"
	elseif p2 == "error" then
		return "error"
	end

	return "success"
end

local function useStoreContent()
	local v5 = GetMusicStore()
	local v6 = useCreationFlowStrings()

	local state, setState = useState(v5.getResults(false))
	local state2, setState2 = useState(v5.getSearchStatus(false))
	local state3, setState3 = useState(false)

	useEffect(function()
		return Signals.createEffect(function(p2)
			setState(v5.getResults(p2))
			setState2(v5.getSearchStatus(p2))
			setState3(v5.getIsLoadingMore(p2))
		end)
	end, {})

	return useMemo(function()
		local v7 = {}

		for k, v8 in state do
			v7[k] = {
				id = v8.AssetId,
				title = v8.Title,
				artist = v8.Artist,
				thumbnailAssetId = v8.AssetId
			}
		end

		return {
			items = v7,
			status = state2 == "loading" and "loading" or state2 == "error" and "error" or "success",
			emptyText = v6.MusicNoResults,
			errorText = v6.MusicSearchError,
			retryText = v6.GeneralCtaRetry,
			onRetry = v5.retry,
			onLoadMore = v5.loadMore,
			isLoadingMore = state3
		}
	end, { state, state2, v6, v5, state3 })
end

local function useSavedContent()
	local v5 = useCreationFlowStrings()
	return useMemo(function()
		return {
			items = {},
			status = "success",
			emptyState = {
				title = v5.MusicSavedEmptyTitle,
				subtitle = v5.MusicSavedEmptySubtitle,
				icon = BuilderIcons.Icon.Bookmark
			}
		}
	end, { v5 })
end

local function MusicPickerV2Container(p2)
	local controller = p2.controller
	local playback = controller.preview.playback
	local v5 = useCreationFlowStrings()
	local v6 = GetMusicStore()
	local v7 = useDeviceInsets()
	local v8 = useStoreContent()
	local v9 = useCreationFlowStrings()
	local v10 = useMemo(function()
		return {
			items = {},
			status = "success",
			emptyState = {
				title = v9.MusicSavedEmptyTitle,
				subtitle = v9.MusicSavedEmptySubtitle,
				icon = BuilderIcons.Icon.Bookmark
			}
		}
	end, { v9 })

	local state, setState = useState(nil)
	local state2, setState2 = useState(false)
	local state3, setState3 = useState({})

	local state4, setState4 = useState("")

	local state5, setState5 = useState(playback.getTimeLength(false))
	useEffect(function()
		return Signals.createEffect(function(p3)
			setState5(playback.getTimeLength(p3))
		end)
	end, { playback })

	local state6, setState6 = useState(nil)
	useEffect(function()
		return Signals.createEffect(function(p3)
			local activeSession = controller.getActiveSession(p3)
			local v12 = if activeSession ~= nil then activeSession.getDraft(p3) else nil
			setState6(v12)
		end)
	end, { controller })

	local v11 = useAudioPlayback(state ~= nil, state, { autoplay = true, looping = false })

	useEffect(function()
		playback.pause()
		v6.search("", state5)
	end, { state5 })

	useEffect(function()
		if not v11.playback.isPlaying then
			setState(nil)
		end
	end, { v11.playback.isPlaying })

	local v12 = useCallback(function()
		playback.play()
		playback.setMuted(false)
		controller.discardActiveTool()
	end, { controller, playback })

	local v13 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update({ assetId = p3, startTime = 0 })
		end

		setState(nil)
		setState2(true)

		local v14 = { musicAssetId = tostring(p3) }

		for k, v15 in makeCreationEventFields.makeToolFieldFromKind("music") do
			v14[k] = v15
		end

		local sessionId = sessionManager.getSessionId(funnelEventNames.FunnelTypes.CreationFlow)

		for k, v15 in makeCreationEventFields.makeCreationBaseFields(sessionId) do
			v14[k] = v15
		end

		fireAnalyticsEvent(eventNames.EditingFlowMusicSelected, v14)
	end, { controller })

	local v14 = useCallback(function()
		local activeSession = controller.getActiveSession(false)

		if activeSession ~= nil then
			activeSession.update(nil)
		end

		setState2(false)
		playback.pause()
	end, { controller, playback })

	local v15 = useCallback(function()
		setState2(false)
		playback.play()
		playback.setMuted(false)
		controller.commitActiveTool()
	end, { controller, playback })

	local v16 = useCallback(function(p3)
		local activeSession = controller.getActiveSession(false)
		local v17 = if activeSession ~= nil then activeSession.getDraft(false) else nil

		if activeSession ~= nil and v17 ~= nil then
			activeSession.update({ assetId = v17.assetId, startTime = p3 })
		end
	end, { controller })

	local v17 = useCallback(function(p3)
		if state == p3 then
			setState(nil)
			return
		end

		setState(p3)
		v11.playback.play()
	end, { state or 0 })

	local v18 = useCallback(function(p3)
		setState3(function(items)
			local result = {}

			for k, item in items do
				if k ~= p3 then
					result[k] = item
				end
			end

			if not items[p3] then
				result[p3] = true
			end

			return result
		end)
	end, {})

	local v19 = useCallback(function(p3)
		setState(nil)
		setState4(p3)
		v6.search(p3, state5)
	end, { v6, state5 })

	local v20 = useCallback(function(p3)
		setState(nil)
	end, {})

	local v21 = useMemo(function()
		local v22 = {
			{ id = "trending", label = v5.MusicTabTrending, content = v8 }
		}

		if fFlagMomentsAudioSaveButton then
			table.insert(v22, { id = "saved", label = "Saved", content = v10 })
		end

		return v22
	end, { v5, v8, v10 })

	local v22 = useMemo(function()
		return {
			previewingId = state,
			togglePreview = v17,
			savedIds = state3,
			toggleSaved = v18,
			showSaveButton = fFlagMomentsAudioSaveButton
		}
	end, {
		state or 0,
		state3,
		v17,
		v18
	})

	if state2 and state6 ~= nil then
		return React.createElement(MusicEditor, {
			controller = controller,
			musicEdit = state6,
			onBack = v14,
			onDone = v15,
			onStartTimeChanged = v16
		})
	end

	return React.createElement(musicPickerContext.Provider, { value = v22 }, {
		Picker = React.createElement(musicPicker, {
			titleText = v5.EditingCtaMusic,
			searchPlaceholder = v5.GeneralSearchPlaceholder,
			showTabs = FFlagMomentsCreationMusicPickerTabs and fFlagMomentsAudioSaveButton,
			tabs = v21,
			searchContent = v8,
			onQueryChanged = v19,
			initialQuery = state4,
			onTabChanged = v20,
			onSelect = v13,
			onClose = v12,
			safeAreaInsets = { left = v7.left, right = v7.right },
			source = "moments"
		})
	})
end

return MusicPickerV2Container
