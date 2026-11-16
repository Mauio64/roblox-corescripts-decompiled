local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local Http = require(parent.Http)
local StatusCodes = Http.StatusCodes
local Logger = require(AppChat.Logger)

local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)

local function useRecordModalSeenWithDelay(data)
	local v = useDispatch()
	local state, setState = React.useState(false)

	local v2 = useRecordModalSequenceResponseForConversation(data.conversationId)
	React.useEffect(function()
		setState(false)
	end, { data.modalSequence, data.modalId, data.conversationId, data.modalVariant })

	local modalId = data.canRecordAction
		and not state
		and data.actionToRecord
		and data.modalSequence
		and (data.modalId or data.modalVariant)
	local v3 = React.useCallback(function()
		local actionToRecord = data.actionToRecord
		local v3

		if data.conversationId then
			v3 = v2(actionToRecord, data.modalSequence, data.modalId, data.modalVariant)
		else
			v3 = v(AppChatNetworking.rodux.RecordModalSequenceResponse.API(
				actionToRecord,
				data.modalSequence,
				data.modalId
			))
		end

		v3:andThen(function(p)
			if p and p.responseCode == StatusCodes.OK then
				setState(true)
			end
		end):catch(function(p)
			Logger:warning(`Error in {data.modalSequence} {data.modalId} -> RecordModalSequenceResponse seen: {tostring(p)}`)
		end)
	end, { v, data.actionToRecord, data.modalId, data.modalSequence, data.conversationId, v2 })

	React.useEffect(function()
		local v4 = nil

		if modalId then
			if data.delayMs and data.delayMs > 0 then
				v4 = setTimeout(v3, data.delayMs)
			else
				v3()
			end
		end

		return function()
			if v4 then
				clearTimeout(v4)
			end
		end
	end, { data.delayMs, v3, modalId })
end
return useRecordModalSeenWithDelay
