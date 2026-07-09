local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local FFlagLuaAppDefaultHttpRetry = require(AppChatParent.SharedFlags).FFlagLuaAppDefaultHttpRetry
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local memo = React.memo
local useCallback = React.useCallback
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local v11 = require(AppChatParent.Loggers).Logger:new("PlaceIdContainer")
local ApiFetchPlaceInfos = require(AppChatParent.PlaceInfoRodux).Thunks.ApiFetchPlaceInfos
local GameCardGroupable = require(script.Parent.GameCardGroupable)
local GameCardContainer = require(script.Parent.GameCardContainer)
local GameCardError = require(script.Parent.GameCardError)
local FFlagAppChatInvalidGameLinkCard = require(AppChat.Flags.FFlagAppChatInvalidGameLinkCard)
local HttpRequest = require(AppChatParent.HttpRequest)
local t1 = {
	networkImpl = HttpRequest.config({
		requestFunction = function(p1, p2, p3) -- line: 32
			-- upvalues: v11 (copy), HttpRequest (copy)
			v11:info("Fetching: {}", string.format("[ requestMethod = %q, url = %q ]", p2, p1))

			return HttpRequest.requestFunctions.HttpRbxApi(p1, p2, p3)
		end,
		maxRetryCount = if not FFlagLuaAppDefaultHttpRetry then nil else game:DefineFastInt("PlaceIdContainerHttpRetryCount", 4)
	})
}

local function getPlaceInfo(p4, p5) -- line: 52
	return p4.ChatAppReducer.PlaceInfos[p5] or {}
end

function PlaceIdContainer(p6) -- line: 56
	-- upvalues: Cryo (copy), t1 (copy), useDispatch (copy), useCallback (copy), ApiFetchPlaceInfos (copy), useSelector (copy), FFlagAppChatInvalidGameLinkCard (copy), React (copy), useEffect (copy), GameCardError (copy), GameCardGroupable (copy), GameCardContainer (copy)
	local v26 = Cryo.Dictionary.join(t1, p6)
	local v27 = useDispatch()
	local v28 = useCallback(function(p7, p8) -- line: 60
		-- upvalues: v27 (copy), ApiFetchPlaceInfos (copy)
		return v27(ApiFetchPlaceInfos(p7, { p8 }))
	end, { v27 })
	local v29 = useSelector(function(p9) -- line: 64
		-- upvalues: v26 (copy)
		local placeId = v26.placeId
		local universeId = (p9.ChatAppReducer.PlaceInfos[placeId] or {}).universeId

		return universeId and tostring(universeId) or nil
	end)
	local v30 = if not FFlagAppChatInvalidGameLinkCard then {
		current = nil
	} else React.useRef(nil)
	local v31 = nil
	local u32 = nil

	if FFlagAppChatInvalidGameLinkCard then
		local v33

		v31, v33 = React.useState(false)
		u32 = v33
	end

	useEffect(function() -- line: 78
		-- upvalues: v26 (copy), v28 (copy), FFlagAppChatInvalidGameLinkCard (copy), Cryo (copy), v29 (copy), v30 (copy), u32 (ref)
		local networkImpl = v26.networkImpl
		local u40 = false

		v28(networkImpl, v26.placeId):andThen(function(p10) -- line: 82
			-- upvalues: FFlagAppChatInvalidGameLinkCard (copy), u40 (ref), Cryo (copy)
			if FFlagAppChatInvalidGameLinkCard then
				u40 = not Cryo.isEmpty(p10)
			end
		end)

		if FFlagAppChatInvalidGameLinkCard then
			if not v29 then
				if v30.current then
					task.cancel(v30.current)
				end

				v30.current = task.delay(1, function() -- line: 94
					-- upvalues: u40 (ref), u32 (ref), v30 (copy)
					if not u40 then
						u32(true)
					end

					v30.current = nil
				end)
			end

			return function() -- line: 102
				-- upvalues: v30 (copy)
				if v30.current then
					task.cancel(v30.current)
					v30.current = nil
				end
			end
		end
	end, {})

	if FFlagAppChatInvalidGameLinkCard then
		useEffect(function() -- line: 114
			-- upvalues: v29 (copy), v30 (copy)
			if v29 and v30.current then
				task.cancel(v30.current)
				v30.current = nil
			end
		end, { v29 })
	end

	if not v29 then
		if FFlagAppChatInvalidGameLinkCard and v31 then
			return React.createElement(GameCardError, {})
		end

		return React.createElement(GameCardGroupable, {
			isLoading = true,
			gameName = "",
			gameThumbnail = ""
		})
	end

	return React.createElement(GameCardContainer, Cryo.Dictionary.join(v26, {
		universeId = v29
	}))
end

return memo(PlaceIdContainer)
