local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local React = require(AppChatParent.React)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local LuauPolyfill = require(AppChatParent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local StatusCodes = require(AppChatParent.Http).StatusCodes
local Logger = require(AppChat.Logger)
local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn

local function useRecordModalSeenWithDelay(t1: {[any]: any}) -- line: 26
	-- upvalues: useDispatch (copy), React (copy), useRecordModalSequenceResponseForConversation (copy), FFlagAppChatEnableDoubleOptIn (copy), AppChatNetworking (copy), StatusCodes (copy), Logger (copy), setTimeout (copy), clearTimeout (copy)
	local v15 = useDispatch()
	local v16, v17 = React.useState(false)
	local v18 = useRecordModalSequenceResponseForConversation(t1.conversationId)

	React.useEffect(function() -- line: 32
		-- upvalues: v17 (copy)
		v17(false)
	end, {
		t1.modalSequence,
		t1.modalId,
		t1.conversationId,
		if not FFlagAppChatEnableDoubleOptIn then nil else t1.modalVariant
	})

	local u19 = t1.canRecordAction and (not v16 and (t1.actionToRecord and (t1.modalSequence and t1.modalId)))

	if FFlagAppChatEnableDoubleOptIn then
		u19 = t1.canRecordAction and (not v16 and (t1.actionToRecord and (t1.modalSequence and (t1.modalId or t1.modalVariant))))
	end

	local v20 = React.useCallback(function() -- line: 56
		-- upvalues: t1 (copy), v18 (copy), v15 (copy), AppChatNetworking (copy), StatusCodes (copy), v17 (copy), Logger (copy)
		local actionToRecord = t1.actionToRecord;

		((if not t1.conversationId then v15(AppChatNetworking.rodux.RecordModalSequenceResponse.API(actionToRecord, t1.modalSequence, t1.modalId)) else v18(actionToRecord, t1.modalSequence, t1.modalId, t1.modalVariant))):andThen(function(p1) -- line: 74
			-- upvalues: StatusCodes (copy), v17 (copy)
			if p1 and p1.responseCode == StatusCodes.OK then
				v17(true)
			end
		end):catch(function(p2) -- line: 79
			-- upvalues: Logger (copy), t1 (copy)
			Logger:warning(`Error in { t1.modalSequence } { t1.modalId } -> RecordModalSequenceResponse seen: { tostring(p2) }`)
		end)
	end, {
		v15,
		t1.actionToRecord,
		t1.modalId,
		t1.modalSequence,
		t1.conversationId,
		v18
	})

	React.useEffect(function() -- line: 97
		-- upvalues: u19 (ref), t1 (copy), setTimeout (copy), v20 (copy), clearTimeout (copy)
		local u22 = nil

		if u19 then
			if t1.delayMs and t1.delayMs > 0 then
				u22 = setTimeout(v20, t1.delayMs)
			else
				v20()
			end
		end

		return function() -- line: 106
			-- upvalues: u22 (ref), clearTimeout (copy)
			if u22 then
				clearTimeout(u22)
			end
		end
	end, {
		t1.delayMs,
		v20,
		u19
	})
end

return useRecordModalSeenWithDelay
