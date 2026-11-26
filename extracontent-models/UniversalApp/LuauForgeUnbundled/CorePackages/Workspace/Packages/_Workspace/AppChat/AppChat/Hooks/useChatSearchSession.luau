local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local ChatActiveFilter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ChatActiveFilter")
local ChatLandingTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")
local ChatLandingTelemetryState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/TelemetryState/ChatLandingTelemetryState")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local function useChatSearchSession(p2, p3)
	local v5 = ChatLandingTelemetryState.useMergeState()
	local v6 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local ref3 = React.useRef(v6.emit)
	ref3.current = v6.emit

	local v7 = React.useCallback(function()
		if ref.current == nil then
			return
		end

		ref.current = nil
		v5({ searchSessionId = Cryo.None, activeFilters = Cryo.None })
	end, { v5 })

	if p2 and ref.current == nil then
		ref.current = HttpService:GenerateGUID(false)

		v5({
			searchSessionId = ref.current,
			activeFilters = { if p3 then ChatActiveFilter.SearchServer else ChatActiveFilter.SearchClient }
		})
	elseif not p2 then
		v7()
	end

	React.useEffect(function()
		if not p2 then
			return
		end

		local current = ref.current

		if current == nil or ref2.current == current then
			return
		end

		ref2.current = current
		ref3.current(ChatLandingTelemetryEvents.SearchStarted, {})
	end, { p2, p3, v5, v7 })

	React.useEffect(function()
		return v7
	end, {})
end

return useChatSearchSession
