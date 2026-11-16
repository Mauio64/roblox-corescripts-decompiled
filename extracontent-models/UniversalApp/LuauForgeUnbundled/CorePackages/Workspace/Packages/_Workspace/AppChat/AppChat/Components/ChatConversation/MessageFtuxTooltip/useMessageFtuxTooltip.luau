local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/MessageFtuxTooltipVariant")
local GlobalLongPressSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/Utils/GlobalLongPressSignal")
local useMessageFtuxTooltipConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageFtuxTooltip/useMessageFtuxTooltipConfig")
local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")
local ChatConversationTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatConversationTelemetryLayer")

local v5 = {
	GetItem = function(self, p3)
		return AppStorageService:GetItem(p3)
	end,
	SetItem = function(self, p3, p4)
		AppStorageService:SetItem(p3, p4)
	end,
	Flush = function()
		AppStorageService:Flush()
	end
}

local function useMessageFtuxTooltip(p2, p3)
	local v6 = p3 or v5
	local v7 = useMessageFtuxTooltipConfig(p2)
	local v8 = useTelemetry(ChatConversationTelemetryLayer.Context)

	local ref = React.useRef(v8)
	ref.current = v8
	local v9 = useLocalUserId() or ""
	local state, setState = React.useState(true)
	local ref2 = React.useRef({})

	local v10 = React.useCallback(function()
		ref.current.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipImpression, {
			tooltipVariant = p2
		})
	end, { p2 })

	local v11 = React.useCallback(function()
		ref.current.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipDismissed, {
			tooltipVariant = p2
		})
	end, { p2 })

	local v12 = React.useCallback(function()
		if state then
			return
		end

		v11()
		ref2.current[v9] = v7.textKey
		local success, result = pcall(function()
			v6:SetItem(v7.storageKey, HttpService:JSONEncode(ref2.current))
			v6:Flush()
		end)
		setState(success)
	end, { v7.storageKey, v7.textKey, v9, state, v6, v11 })

	React.useEffect(function()
		local success, result = pcall(function()
			return HttpService:JSONDecode((v6:GetItem(v7.storageKey)))
		end)

		ref2.current = not success and {} or result
		local v13 = ref2.current[v9] == v7.textKey
		setState(v13)

		if not v13 then
			v10()
		end
	end, { v7.storageKey, v7.textKey, v9, v6, v10 })

	React.useEffect(function()
		if state then
			return
		end

		local dismissedConnection = GlobalLongPressSignal.dismissed:connect(function(p4)
			if p4 == p2 then
				v12()
			end
		end)
		return function()
			dismissedConnection:disconnect()
		end
	end, { p2, v12, state })

	local v13 = useLocalization({ tooltipText = v7.textKey })

	return React.useMemo(function()
		return { text = v13.tooltipText, isDismissed = state, handleDismiss = v12 }
	end, { v13.tooltipText, state, v12 })
end

return useMessageFtuxTooltip
