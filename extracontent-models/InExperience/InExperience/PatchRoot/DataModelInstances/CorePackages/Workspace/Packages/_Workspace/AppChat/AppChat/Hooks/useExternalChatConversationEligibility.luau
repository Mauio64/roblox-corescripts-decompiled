local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local SignalsUtils = require(parent.SignalsUtils)
local createCurrentTimeSignal = SignalsUtils.createCurrentTimeSignal

local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)
require(AppChat.Stores.GetConversationStore)
local getConversationSendEligibilityStatus = require(AppChat.Utils.getConversationSendEligibilityStatus)

local function areResultsEqual(p, p2): boolean
	if p.isLoading ~= p2.isLoading or #p.eligibleConversations ~= #p2.eligibleConversations then
		return false
	end

	for k, eligibleConversation in p.eligibleConversations do
		if eligibleConversation ~= p2.eligibleConversations[k] then
			return false
		end
	end

	return true
end

local function useExternalChatConversationEligibility(data)
	local timeoutStore = GetChatModerationStatusDataHydration()
	local v = React.useMemo(function()
		return createCurrentTimeSignal(1)
	end, {})

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(scope)
			local conversations = {}

			if not data.isActive then
				return { eligibleConversations = conversations, isLoading = true }
			end

			local currentTimestamp = v(scope)

			for _, conversation in data.conversations do
				local conversationSendEligibilityStatus = getConversationSendEligibilityStatus({
					allowConversationStatusLoading = false,
					conversation = conversation,
					currentTimestamp = currentTimestamp,
					isAvailable = true,
					isGroupChatEnabled = data.isGroupChatEnabled,
					scope = scope,
					timeoutStore = timeoutStore
				})

				if conversationSendEligibilityStatus == "loading" then
					return { eligibleConversations = {}, isLoading = true }
				end

				if conversationSendEligibilityStatus ~= "eligible" then
					continue
				end

				table.insert(conversations, conversation)

				if #conversations >= data.maxConversationCount then
					break
				end
			end

			return { eligibleConversations = conversations, isLoading = false }
		end, areResultsEqual)
	end, {
		v,
		data.conversations,
		data.isActive,
		data.isGroupChatEnabled,
		data.maxConversationCount,
		timeoutStore
	})

	return SignalsReact.useSignalState(v2)
end

return useExternalChatConversationEligibility
