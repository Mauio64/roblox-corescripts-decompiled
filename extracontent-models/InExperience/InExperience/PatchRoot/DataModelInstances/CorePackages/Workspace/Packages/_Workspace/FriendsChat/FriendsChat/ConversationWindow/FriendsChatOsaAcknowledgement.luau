local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local AppChatNetworking = require(parent.AppChatNetworking)

local GetConversationStore = require(parent.AppChat.GetConversationStore)
local fetchConversationDetailsToSignals = require(parent.AppChat.fetchConversationDetailsToSignals)
local useIsGuiInChatVisible = require(parent.AppChat.useIsGuiInChatVisible)

local ExpChatShared = require(parent.ExpChatShared)
local v = ExpChatShared.Logger:new(script.Name)
local submissionKeySet = {}
local v2 = {}
local v3 = {}
local submissionKeySet2 = {}

local function getSubmissionKey(p: string) -- 2 equivalent calls inferred from this helper
	local localPlayer = Players.LocalPlayer
	return `{not localPlayer and 0 or localPlayer.UserId}:{p}`
end

local function isRetryable(data): boolean -- 1 equivalent call inferred from this helper
	if typeof(data) ~= "table" then
		return true
	end

	local statusCode = data.StatusCode or data.statusCode or data.responseCode
	return statusCode == nil or statusCode <= 0 or statusCode == 408 or statusCode == 429 or statusCode >= 500
end

local function markAcknowledged(conversationId: string)
	local conversationStore = GetConversationStore(false)
	local conversation = conversationStore.getConversation(conversationId, false)

	if
		conversation
		and conversation.osaAcknowledgementStatus ~= AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Acknowledged
	then
		local clone = table.clone(conversation)
		clone.osaAcknowledgementStatus = AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Acknowledged
		conversationStore.upsertConversation(clone)
	end
end

local function useFriendsChatOsaAcknowledgement(data)
	local v4 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return GetConversationStore(p).getConversation(data.conversationId, p)
		end)
	end, { data.conversationId })
	local v5 = SignalsReact.useSignalState(v4)
	local v6

	if v5 == nil then
		v6 = false
	else
		v6 = v5.osaAcknowledgementStatus == AppChatNetworking.Constants.OsaAcknowledgementStatusResponse.Unacknowledged
	end

	local source

	if v5 then
		source = v5.source
	else
		source = nil
	end

	local v7 = useIsGuiInChatVisible(data.guiObjectRef, { data.guiObjectRef.current })
	local state, setState = React.useState(0)

	React.useEffect(function()
		local conversationId = data.conversationId
		local submissionKey = getSubmissionKey(conversationId) -- inferred equivalent call

		if
			conversationId == ""
			or not v6
			or not v7
			or submissionKeySet[submissionKey]
			or submissionKeySet2[submissionKey]
		then
			return
		end

		local v8 = false
		local function scheduleRetry(data2)
			local v9 = v3[submissionKey] or 0

			if not isRetryable(data2) or v9 >= 4 then -- inferred equivalent call
				submissionKeySet2[submissionKey] = true
				return
			end

			local v10 = 2 ^ math.max(v9 - 1, 0) * 1
			task.delay(v10, function()
				if not v8 then
					setState(function(p)
						return p + 1
					end)
				end
			end)
		end
		local v9 = v2[submissionKey]

		if v9 then
			v9:catch(scheduleRetry)
			return function()
				v8 = true
			end
		end

		local v10 = source == "friends"
		local recordModalSequenceResponse = AppChatNetworking.http.RecordModalSequenceResponse
		local conversationId2

		if not v10 then
			conversationId2 = conversationId
		end

		local friendId

		if v10 then
			friendId = data.userId
		end

		local v11 = recordModalSequenceResponse(nil, {
			actionType = "record_has_seen",
			modalSequence = "conversation_inline_top_modal",
			modalVariant = "OsaContextCard",
			conversationId = conversationId2,
			friendId = friendId
		})

		v3[submissionKey] = (v3[submissionKey] or 0) + 1
		v2[submissionKey] = v11

		v11:andThen(function()
			v2[submissionKey] = nil
			v3[submissionKey] = nil
			submissionKeySet[submissionKey] = true
			markAcknowledged(conversationId)

			if not v10 then
				fetchConversationDetailsToSignals(conversationId):andThen(function()
					markAcknowledged(conversationId)
				end):catch(function(p)
					v:warning(`Failed to refresh conversation after Friends Chat OSA acknowledgement: {tostring(p)}`)
				end)
			end
		end):catch(function(p)
			v2[submissionKey] = nil
			v:error(`Failed to record Friends Chat OSA acknowledgement: {tostring(p)}`)
			scheduleRetry(p)
		end)
		return function()
			v8 = true
		end
	end, { data.conversationId, data.userId, v6, v7, source, state })
end

return {
	useAcknowledgement = useFriendsChatOsaAcknowledgement,
	hasSubmitted = function(p: string): boolean
		return submissionKeySet[getSubmissionKey(p)] == true -- inferred equivalent call
	end
}
