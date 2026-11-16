local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local GetConversationListStore = require(parent.AppChat.GetConversationListStore)
local Signals = require(parent.Signals)
local fetchConversationListPageToSignals = require(parent.AppChat.fetchConversationListPageToSignals)
local ListRecipientsStatus = require(ShareSheet.Recipients.ListRecipientsStatus)
local Recipient = require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Types)

local function createChatInboxRecipientList()
	local conversationListStore = GetConversationListStore(false)

	local v = {}

	local computed = Signals.createComputed(function(p)
		local conversations = conversationListStore.getConversations(p)
		local result = table.create(#conversations)
		local v2 = {}

		for k, conversation in conversations do
			local v3 = v[conversation] or Recipient.fromConversation(conversation)
			v2[conversation] = v3
			result[k] = v3
		end

		v = v2
		return result
	end)

	local getResult = Signals.createComputed(function(p)
		local recipients = computed(p)
		local listStatus = conversationListStore.getListStatus(p)
		local isFetchingConversations = listStatus.isFetchingConversations == true
		local status

		if listStatus.error == nil then
			if #recipients == 0 and (isFetchingConversations or listStatus.hasFetchedInitialPage ~= true) then
				status = ListRecipientsStatus.Loading
			else
				status = ListRecipientsStatus.Ready
			end
		else
			status = ListRecipientsStatus.Failed
		end

		local nextPageToken

		if listStatus.oldestConversationIsFetched ~= true then
			nextPageToken = listStatus.nextCursor
		end

		return {
			recipients = recipients,
			status = status,
			nextPageToken = nextPageToken,
			isFetchingNextPage = isFetchingConversations
		}
	end)

	return {
		getResult = getResult,
		refresh = function()
			fetchConversationListPageToSignals()
		end,
		loadMore = function(cursor: string)
			if getResult(false).nextPageToken == cursor then
				fetchConversationListPageToSignals({ cursor = cursor })
			end
		end
	}
end

return createChatInboxRecipientList
