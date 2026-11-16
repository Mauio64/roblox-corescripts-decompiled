local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local createCurrentTimeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createCurrentTimeSignal

local GetChatModerationStatusDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local getConversationSendEligibilityStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getConversationSendEligibilityStatus")

local function areResultsEqual(p2, p3): boolean
	if p2.isLoading ~= p3.isLoading or #p2.eligibleConversations ~= #p3.eligibleConversations then
		return false
	end

	for k, eligibleConversation in p2.eligibleConversations do
		if eligibleConversation ~= p3.eligibleConversations[k] then
			return false
		end
	end

	return true
end

local function useExternalChatConversationEligibility(data)
	local v5 = GetChatModerationStatusDataHydration()
	local v6 = React.useMemo(function()
		return createCurrentTimeSignal(1)
	end, {})

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local conversations = {}

			if not data.isActive then
				return { eligibleConversations = conversations, isLoading = true }
			end

			local v8 = v6(p2)

			for k, conversation in data.conversations do
				local v9 = getConversationSendEligibilityStatus({
					allowConversationStatusLoading = false,
					conversation = conversation,
					currentTimestamp = v8,
					isAvailable = true,
					isGroupChatEnabled = data.isGroupChatEnabled,
					scope = p2,
					timeoutStore = v5
				})

				if v9 == "loading" then
					return { eligibleConversations = {}, isLoading = true }
				end

				if v9 ~= "eligible" then
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
		v6,
		data.conversations,
		data.isActive,
		data.isGroupChatEnabled,
		data.maxConversationCount,
		v5
	})

	return SignalsReact.useSignalState(v7)
end

return useExternalChatConversationEligibility
