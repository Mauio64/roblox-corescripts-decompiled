local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

require(script.Parent.MessageFtuxTooltipVariant)
local MessageFtuxTooltipDismissSignal = require(script.Parent.MessageFtuxTooltipDismissSignal)
local useMessageFtuxTooltipConfig = require(script.Parent.useMessageFtuxTooltipConfig)
local ChatConversationTelemetryEvents = require(AppChat.Components.ChatConversation.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)

local v = {
	GetItem = function(self, p)
		return AppStorageService:GetItem(p)
	end,
	SetItem = function(self, p, p2)
		AppStorageService:SetItem(p, p2)
	end,
	Flush = function()
		AppStorageService:Flush()
	end
}

local function useMessageFtuxTooltip(tooltipVariant, p)
	local v2 = p or v
	local v3 = useMessageFtuxTooltipConfig(tooltipVariant)
	local current = useTelemetry(ChatConversationTelemetryLayer.Context)

	local ref = React.useRef(current)
	ref.current = current
	local v4 = useLocalUserId() or ""
	local state, setState = React.useState(true)
	local ref2 = React.useRef({})

	local v5 = React.useCallback(function()
		ref.current.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipImpression, {
			tooltipVariant = tooltipVariant
		})
	end, { tooltipVariant })

	local v6 = React.useCallback(function()
		ref.current.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipDismissed, {
			tooltipVariant = tooltipVariant
		})
	end, { tooltipVariant })

	local handleDismiss = React.useCallback(function()
		if state then
			return
		end

		v6()
		ref2.current[v4] = v3.textKey
		local success, _ = pcall(function()
			v2:SetItem(v3.storageKey, HttpService:JSONEncode(ref2.current))
			v2:Flush()
		end)
		setState(success)
	end, { v3.storageKey, v3.textKey, v4, state, v2, v6 })

	React.useEffect(function()
		local success, result = pcall(function()
			return HttpService:JSONDecode((v2:GetItem(v3.storageKey)))
		end)

		ref2.current = not success and {} or result
		local v7 = ref2.current[v4] == v3.textKey
		setState(v7)

		if not v7 then
			v5()
		end
	end, { v3.storageKey, v3.textKey, v4, v2, v5 })

	React.useEffect(function()
		if state then
			return
		end

		local dismissedConnection = MessageFtuxTooltipDismissSignal.dismissed:connect(function(p2)
			if p2 == tooltipVariant then
				handleDismiss()
			end
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end, { tooltipVariant, handleDismiss, state })

	local v7 = useLocalization({ tooltipText = v3.textKey })

	return React.useMemo(function()
		return { text = v7.tooltipText, isDismissed = state, handleDismiss = handleDismiss }
	end, { v7.tooltipText, state, handleDismiss })
end

return useMessageFtuxTooltip
