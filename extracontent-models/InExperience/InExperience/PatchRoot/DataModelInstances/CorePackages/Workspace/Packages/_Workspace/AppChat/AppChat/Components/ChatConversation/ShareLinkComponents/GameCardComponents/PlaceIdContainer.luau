local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDefaultHttpRetry = SharedFlags.FFlagLuaAppDefaultHttpRetry
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local useCallback = React.useCallback
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local PlaceDetails = require(parent.DataHydration.PlaceDetails)
local getPlaceDetailsStore = PlaceDetails.getPlaceDetailsStore
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local v = Logger.new(Logger, "PlaceIdContainer")

local PlaceInfoRodux = require(parent.PlaceInfoRodux)
local ApiFetchPlaceInfos = PlaceInfoRodux.Thunks.ApiFetchPlaceInfos

local GameCardGroupable = require(script.Parent.GameCardGroupable)
local GameCardContainer = require(script.Parent.GameCardContainer)
local GameCardError = require(script.Parent.GameCardError)
local GameAssetCard = require(script.Parent.GameAssetCard)
require(AppChat.Components.ChatConversation.Grouping.MessageGroupShape)

local FFlagAppChatInvalidGameLinkCard = require(AppChat.Flags.FFlagAppChatInvalidGameLinkCard)
local FFlagAppChatUseDataHydrationForPlaceInfos = require(AppChat.Flags.FFlagAppChatUseDataHydrationForPlaceInfos)

local HttpRequest = require(parent.HttpRequest)
local config = HttpRequest.config
local v2 = {
	requestFunction = function(p, p2, p3)
		v:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p))
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end,
	maxRetryCount = 0
}
local maxRetryCount

if FFlagLuaAppDefaultHttpRetry then
	maxRetryCount = game:DefineFastInt("PlaceIdContainerHttpRetryCount", 4)
end

v2.maxRetryCount = maxRetryCount
local v3 = { networkImpl = config(v2) }

local function getPlaceInfo(p, p2) -- 1 equivalent call inferred from this helper
	return p.ChatAppReducer.PlaceInfos[p2] or {}
end

local function useDataHydrationUniverseId(p: string, _)
	local placeDetailsStore = getPlaceDetailsStore(false)
	local v4 = React.useMemo(function()
		return placeDetailsStore.getAndFetchPlaceDetails(p)
	end, { placeDetailsStore, p })
	local v5 = useSignalState(v4.data)
	local v6 = useSignalState(v4.status)
	local universeId

	if v5 then
		universeId = v5.universeId
	end

	local v7

	if v6 == DataStatus.Failed then
		v7 = true
	elseif v6 == DataStatus.Ready then
		v7 = universeId == nil
	else
		v7 = false
	end

	return universeId, v7
end

local function useRoduxUniverseId(p: string, p2)
	local v4 = useDispatch()
	local v5 = useCallback(function(p3, p4)
		return v4(ApiFetchPlaceInfos(p3, { p4 }))
	end, { v4 })

	local v6 = useSelector(function(p3)
		local universeId = getPlaceInfo(p3, p).universeId -- inferred equivalent call

		return universeId and tostring(universeId) or nil
	end)

	local v7 = not FFlagAppChatInvalidGameLinkCard and { current = nil } or React.useRef(nil)
	local state, setState

	if FFlagAppChatInvalidGameLinkCard then
		state, setState = React.useState(false)
	else
		setState = nil
	end

	useEffect(function()
		local v8 = false
		v5(p2, p):andThen(function(p3)
			if FFlagAppChatInvalidGameLinkCard then
				v8 = not Cryo.isEmpty(p3)
			end
		end)

		if not FFlagAppChatInvalidGameLinkCard then
			return
		end

		if not v6 then
			if v7.current then
				task.cancel(v7.current)
			end

			v7.current = task.delay(1, function()
				if not v8 then
					setState(true)
				end

				v7.current = nil
			end)
		end

		return function()
			if v7.current then
				task.cancel(v7.current)
				v7.current = nil
			end
		end
	end, {})

	if FFlagAppChatInvalidGameLinkCard then
		useEffect(function()
			if v6 and v7.current then
				task.cancel(v7.current)
				v7.current = nil
			end
		end, { v6 })
	end

	return v6, state
end

if FFlagAppChatUseDataHydrationForPlaceInfos then
	useRoduxUniverseId = useDataHydrationUniverseId
end

function PlaceIdContainer(p)
	local joined = Cryo.Dictionary.join(v3, p)

	local universeId, v4 = useRoduxUniverseId(joined.placeId, joined.networkImpl)

	if not universeId and joined.groupShape then
		return React.createElement(GameAssetCard, {
			isLoading = true,
			isError = FFlagAppChatInvalidGameLinkCard and v4,
			groupShape = joined.groupShape,
			mediaRef = joined.mediaRef
		})
	end

	if universeId then
		return React.createElement(GameCardContainer, Cryo.Dictionary.join(joined, {
			universeId = universeId
		}))
	end

	if FFlagAppChatInvalidGameLinkCard and v4 then
		return React.createElement(GameCardError, {})
	end

	return React.createElement(GameCardGroupable, {
		isLoading = true,
		gameName = "",
		gameThumbnail = ""
	})
end

return memo(PlaceIdContainer)
