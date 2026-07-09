local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local MessageFtuxTooltipVariant = require(script.Parent.MessageFtuxTooltipVariant)
local MessageFtuxTooltipDismissSignal = require(script.Parent.MessageFtuxTooltipDismissSignal)
local useMessageFtuxTooltipConfig = require(script.Parent.useMessageFtuxTooltipConfig)
local ChatConversationTelemetryEvents = require(AppChat.Components.ChatConversation.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local FFlagAppChatUseSwipeForReplies = require(AppChat.Flags.FFlagAppChatUseSwipeForReplies)

local function useMessageFtuxTooltip(p1) -- line: 27
	-- upvalues: MessageFtuxTooltipVariant (copy), useMessageFtuxTooltipConfig (copy), useTelemetry (copy), ChatConversationTelemetryLayer (copy), useLocalUserId (copy), React (copy), ChatConversationTelemetryEvents (copy), FFlagAppChatUseSwipeForReplies (copy), AppStorageService (copy), HttpService (copy), MessageFtuxTooltipDismissSignal (copy), useLocalization (copy)
	if p1 == MessageFtuxTooltipVariant.None then
		return {
			text = "",
			isDismissed = true,
			handleDismiss = function() -- line: 32
			end
		}
	end

	local v17 = useMessageFtuxTooltipConfig(p1)
	local v18 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v19 = useLocalUserId() or ""
	local v20, v21 = React.useState(true)
	local v22 = React.useRef({})
	local v23 = React.useCallback(function() -- line: 42
		-- upvalues: v18 (copy), ChatConversationTelemetryEvents (copy), p1 (copy)
		v18.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipImpression, {
			tooltipVariant = p1
		})
	end, {
		p1,
		v18
	})
	local v24 = React.useCallback(function() -- line: 48
		-- upvalues: v18 (copy), ChatConversationTelemetryEvents (copy), p1 (copy)
		v18.emit(ChatConversationTelemetryEvents.ConversationMessageFtuxTooltipDismissed, {
			tooltipVariant = p1
		})
	end, {
		p1,
		v18
	})
	local v25 = React.useCallback(function() -- line: 54
		-- upvalues: v20 (copy), v24 (copy), v22 (copy), v19 (copy), FFlagAppChatUseSwipeForReplies (copy), v17 (copy), AppStorageService (copy), HttpService (copy), v21 (copy)
		if v20 then
			return
		end

		v24()
		v22.current[v19] = not FFlagAppChatUseSwipeForReplies or v17.textKey

		local ok, _ = pcall(function() -- line: 60
			-- upvalues: AppStorageService (copy), v17 (copy), HttpService (copy), v22 (copy)
			AppStorageService:SetItem(v17.storageKey, HttpService:JSONEncode(v22.current))
			AppStorageService:Flush()
		end)

		v21(ok)
	end, {
		v17.storageKey,
		v19,
		v20
	})

	React.useEffect(function() -- line: 67
		-- upvalues: AppStorageService (copy), v17 (copy), HttpService (copy), v22 (copy), FFlagAppChatUseSwipeForReplies (copy), v19 (copy), v21 (copy), v23 (copy)
		local ok, result = pcall(function() -- line: 68
			-- upvalues: AppStorageService (copy), v17 (copy), HttpService (copy)
			local Item = AppStorageService:GetItem(v17.storageKey)

			return HttpService:JSONDecode(Item)
		end)

		v22.current = if not ok then {} else result

		local v31 = if not FFlagAppChatUseSwipeForReplies then v22.current[v19] or false else v22.current[v19] == v17.textKey

		v21(v31)

		if not v31 then
			v23()
		end
	end, {
		v17.storageKey,
		v19
	})
	React.useEffect(function() -- line: 82
		-- upvalues: v20 (copy), MessageFtuxTooltipDismissSignal (copy), p1 (copy), v25 (copy)
		if v20 then
			return
		end

		local v32 = MessageFtuxTooltipDismissSignal.dismissed:connect(function(p2) -- line: 86
			-- upvalues: p1 (copy), v25 (copy)
			if p2 == p1 then
				v25()
			end
		end)

		return function() -- line: 91
			-- upvalues: v32 (copy)
			v32:disconnect()
		end
	end, {
		p1,
		v25,
		v20
	})

	local v26 = useLocalization({
		tooltipText = v17.textKey
	})

	return React.useMemo(function() -- line: 99
		-- upvalues: v26 (copy), v20 (copy), v25 (copy)
		return {
			text = v26.tooltipText,
			isDismissed = v20,
			handleDismiss = v25
		}
	end, {
		v26.tooltipText,
		v20,
		v25
	})
end

return useMessageFtuxTooltip
