local fFlagLuaAppDefaultHttpRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagLuaAppDefaultHttpRetry
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local getPlaceDetailsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration/PlaceDetails").getPlaceDetailsStore
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger
local v5 = logger.new(logger, "PlaceIdContainer")

local apiFetchPlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/PlaceInfoRodux").Thunks.ApiFetchPlaceInfos

local GameCardGroupable = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardGroupable")
local GameCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardContainer")
local GameCardError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameCardError")
local GameAssetCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ShareLinkComponents/GameCardComponents/GameAssetCard")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Grouping/MessageGroupShape")

local FFlagAppChatInvalidGameLinkCard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatInvalidGameLinkCard")
local FFlagAppChatUseDataHydrationForPlaceInfos = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseDataHydrationForPlaceInfos")

local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/HttpRequest")
local config = HttpRequest.config
local v6 = {
	requestFunction = function(p2, p3, p4)
		v5:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p3, p2))
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end,
	maxRetryCount = 0
}

local v7 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt("PlaceIdContainerHttpRetryCount", 4) else nil
v6.maxRetryCount = v7
local v8 = { networkImpl = config(v6) }

local function getPlaceInfo(p2, p3)
	return p2.ChatAppReducer.PlaceInfos[p3] or {}
end

local function useDataHydrationUniverseId(p2, p3)
	local placeDetailsStore = getPlaceDetailsStore(false)
	local v9 = React.useMemo(function()
		return placeDetailsStore.getAndFetchPlaceDetails(p2)
	end, { placeDetailsStore, p2 })
	local v10 = useSignalState(v9.data)
	local v11 = useSignalState(v9.status)

	local universeId = if v10 then v10.universeId else nil
	local v12 = v11 == dataStatus.Failed or v11 == dataStatus.Ready and universeId == nil
	return universeId, v12
end

local function useRoduxUniverseId(p2, p3)
	local v9 = useDispatch()
	local v10 = useCallback(function(p4, p5)
		return v9(apiFetchPlaceInfos(p4, { p5 }))
	end, { v9 })

	local v11 = useSelector(function(p4)
		local universeId = (p4.ChatAppReducer.PlaceInfos[p2] or {}).universeId

		return universeId and tostring(universeId) or nil
	end)

	local v12 = not FFlagAppChatInvalidGameLinkCard and { current = nil } or React.useRef(nil)
	local state, setState

	if FFlagAppChatInvalidGameLinkCard then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	useEffect(function()
		local v13 = false
		v10(p3, p2):andThen(function(p4)
			if FFlagAppChatInvalidGameLinkCard then
				v13 = not Cryo.isEmpty(p4)
			end
		end)

		if not FFlagAppChatInvalidGameLinkCard then
			return
		end

		if not v11 then
			if v12.current then
				task.cancel(v12.current)
			end

			v12.current = task.delay(1, function()
				if not v13 then
					setState(true)
				end

				v12.current = nil
			end)
		end

		return function()
			if v12.current then
				task.cancel(v12.current)
				v12.current = nil
			end
		end
	end, {})

	if FFlagAppChatInvalidGameLinkCard then
		useEffect(function()
			if v11 and v12.current then
				task.cancel(v12.current)
				v12.current = nil
			end
		end, { v11 })
	end

	return v11, state
end

if FFlagAppChatUseDataHydrationForPlaceInfos then
	useRoduxUniverseId = useDataHydrationUniverseId
end

function LUAUFORGE_MODULE_GLOBALS_hwi_PlaceIdContainer(p2)
	local joined = Cryo.Dictionary.join(v8, p2)

	local v9, v10 = useRoduxUniverseId(joined.placeId, joined.networkImpl)

	if not v9 and joined.groupShape then
		return React.createElement(GameAssetCard, {
			isLoading = true,
			isError = FFlagAppChatInvalidGameLinkCard and v10,
			groupShape = joined.groupShape,
			mediaRef = joined.mediaRef
		})
	end

	if v9 then
		return React.createElement(GameCardContainer, Cryo.Dictionary.join(joined, {
			universeId = v9
		}))
	end

	if FFlagAppChatInvalidGameLinkCard and v10 then
		return React.createElement(GameCardError, {})
	end

	return React.createElement(GameCardGroupable, {
		isLoading = true,
		gameName = "",
		gameThumbnail = ""
	})
end

return memo(LUAUFORGE_MODULE_GLOBALS_hwi_PlaceIdContainer)
