local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
local statusCodes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Http").StatusCodes
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")

local useRecordModalSequenceResponseForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSequenceResponseForConversation")

local function useRecordModalSeenWithDelay(data)
	local v5 = useDispatch()
	local state, setState = React.useState(false)

	local v6 = useRecordModalSequenceResponseForConversation(data.conversationId)
	React.useEffect(function()
		setState(false)
	end, { data.modalSequence, data.modalId, data.conversationId, data.modalVariant })

	local modalId = data.canRecordAction
		and not state
		and data.actionToRecord
		and data.modalSequence
		and (data.modalId or data.modalVariant)
	local v7 = React.useCallback(function()
		local actionToRecord = data.actionToRecord
		local v8

		if data.conversationId then
			v8 = v6(actionToRecord, data.modalSequence, data.modalId, data.modalVariant)
		else
			v8 = v5(AppChatNetworking.rodux.RecordModalSequenceResponse.API(
				actionToRecord,
				data.modalSequence,
				data.modalId
			))
		end

		v8:andThen(function(p2)
			if p2 and p2.responseCode == statusCodes.OK then
				setState(true)
			end
		end):catch(function(p2)
			Logger:warning(`Error in {data.modalSequence} {data.modalId} -> RecordModalSequenceResponse seen: {tostring(p2)}`)
		end)
	end, {
		v5,
		data.actionToRecord,
		data.modalId,
		data.modalSequence,
		data.conversationId,
		v6
	})

	React.useEffect(function()
		local v8 = nil

		if modalId then
			if data.delayMs and data.delayMs > 0 then
				v8 = setTimeout(v7, data.delayMs)
			else
				v7()
			end
		end

		return function()
			if v8 then
				clearTimeout(v8)
			end
		end
	end, { data.delayMs, v7, modalId })
end
return useRecordModalSeenWithDelay
