local GetConversationListStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local fetchConversationListPageToSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/fetchConversationListPageToSignals")
local ListRecipientsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/ListRecipientsStatus")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function createChatInboxRecipientList()
	local v5 = GetConversationListStore(false)

	local v6 = {}

	local computed = Signals.createComputed(function(p2)
		local conversations = v5.getConversations(p2)
		local result = table.create(#conversations)
		local v7 = {}

		for k, conversation in conversations do
			local v8 = v6[conversation] or Recipient.fromConversation(conversation)
			v7[conversation] = v8
			result[k] = v8
		end

		v6 = v7
		return result
	end)

	local computed2 = Signals.createComputed(function(p2)
		local v7 = computed(p2)
		local listStatus = v5.getListStatus(p2)
		local isFetchingConversations = listStatus.isFetchingConversations == true
		local v9

		if listStatus.error == nil then
			if #v7 == 0 and (isFetchingConversations or listStatus.hasFetchedInitialPage ~= true) then
				v9 = ListRecipientsStatus.Loading
			else
				v9 = ListRecipientsStatus.Ready
			end
		else
			v9 = ListRecipientsStatus.Failed
		end

		local v10 = if listStatus.oldestConversationIsFetched ~= true then listStatus.nextCursor else nil
		return {
			recipients = v7,
			status = v9,
			nextPageToken = v10,
			isFetchingNextPage = isFetchingConversations
		}
	end)

	return {
		getResult = computed2,
		refresh = function()
			fetchConversationListPageToSignals()
		end,
		loadMore = function(p2)
			if computed2(false).nextPageToken == p2 then
				fetchConversationListPageToSignals({ cursor = p2 })
			end
		end
	}
end

return createChatInboxRecipientList
