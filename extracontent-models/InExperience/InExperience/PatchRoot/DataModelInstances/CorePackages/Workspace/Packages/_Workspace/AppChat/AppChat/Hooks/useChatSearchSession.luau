local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)

local ChatActiveFilter = require(AppChat.Analytics.Enums.ChatActiveFilter)
local ChatLandingTelemetryEvents = require(AppChat.Components.ChatLanding.ChatLandingTelemetryEvents)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local function useChatSearchSession(flag: boolean, flag2: boolean)
	local v = ChatLandingTelemetryState.useMergeState()
	local v2 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(v2.emit)
	ref3.current = v2.emit

	local v3 = React.useCallback(function()
		if ref.current == nil then
			return
		end

		ref.current = nil
		v({ searchSessionId = Cryo.None, activeFilters = Cryo.None })
	end, { v })

	if flag and ref.current == nil then
		ref.current = HttpService:GenerateGUID(false)

		local v4 = { searchSessionId = ref.current, activeFilters = 0 }
		local v5

		if flag2 then
			v5 = ChatActiveFilter.SearchServer
		else
			v5 = ChatActiveFilter.SearchClient
		end

		v4.activeFilters = { v5 }
		v(v4)
	elseif not flag then
		v3()
	end

	React.useEffect(function()
		if not flag then
			return
		end

		local current = ref.current

		if current == nil or ref2.current == current then
			return
		end

		ref2.current = current
		ref3.current(ChatLandingTelemetryEvents.SearchStarted, {})
	end, { flag, flag2, v, v3 })

	React.useEffect(function()
		return v3
	end, {})
end

return useChatSearchSession
