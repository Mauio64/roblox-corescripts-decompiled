local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

require(parent.AppChat.GetExternalChatMessageSenderStore)
local ListRecipientsStatus = require(ShareSheet.Recipients.ListRecipientsStatus)
local Recipient = require(ShareSheet.Recipients.Recipient)
local getSelectableRecipients = require(ShareSheet.Recipients.getSelectableRecipients)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
require(ShareSheet.Types)

local function getCompactRecipients(recipients, selectableRecipients, selectedConversationIds, fn)
	local compactRecipients = {}
	local idSet = {}

	for i = 1, math.min(#recipients, ShareSheetConstants.FIntShareSheetMaxConversations) do
		local item = recipients[i]
		table.insert(compactRecipients, item)
		idSet[item.id] = true
	end

	for _, item in selectableRecipients do
		if not selectedConversationIds[item.id] or idSet[item.id] or not fn(item) then
			continue
		end

		table.insert(compactRecipients, item)
		idSet[item.id] = true
	end

	return compactRecipients
end

local function useShareSheetRecipientModel(data)
	local v = data.chatShare ~= nil
	local current = data.listResult

	local ref = React.useRef(current)

	if data.isSending then
		current = ref.current
	else
		ref.current = current
	end

	local v2 = #current.recipients > 0
	local v3 = current.status == ListRecipientsStatus.Failed
	local v4 = current.status == ListRecipientsStatus.Loading
	local v5

	if data.chatShare == nil then
		v5 = false
	else
		v5 = data.chatShare.isAvailable
	end

	local isActive = data.isOpen and v5 and v2
	local isGroupChatEnabled

	if data.chatShare then
		isGroupChatEnabled = data.chatShare.isGroupChatEnabled
	else
		isGroupChatEnabled = false
	end

	local recipients = current.recipients
	local v6 = Recipient.useEligibleRecipients({
		recipients = recipients,
		isActive = isActive,
		isGroupChatEnabled = isGroupChatEnabled,
		maxCount = ShareSheetConstants.FIntShareSheetMaxConversations
	})

	local searchResult = data.searchResult
	local selectableRecipients = getSelectableRecipients(recipients, data.pickedRecipients)
	local useEligibleRecipients = Recipient.useEligibleRecipients

	if searchResult then
		recipients = searchResult.recipients
	end

	local v7 = useEligibleRecipients({
		recipients = recipients,
		isActive = isActive and data.isPeoplePickerDisplayed,
		isGroupChatEnabled = isGroupChatEnabled,
		maxCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
	})

	local socialRowRecipients = {
		recipients = getCompactRecipients(v6.recipients, selectableRecipients, data.selectedConversationIds, function(p)
			return data.chatShare ~= nil and Recipient.canSend(data.chatShare, p)
		end),
		isLoading = v6.isLoading
	}
	local recipients2

	if v7.isLoading and not v6.isLoading and searchResult == nil then
		recipients2 = v6.recipients
	else
		recipients2 = v7.recipients
	end

	local isLoading

	if searchResult then
		if searchResult.status == ListRecipientsStatus.Loading then
			isLoading = true
		elseif searchResult.status == ListRecipientsStatus.Ready then
			isLoading = v7.isLoading
		else
			isLoading = false
		end
	else
		isLoading = not v3 and v7.isLoading
	end

	local v8 = v and v4
	return {
		socialRowRecipients = socialRowRecipients,
		isSocialRowLoading = v5 and v8,
		peoplePickerRecipients = { recipients = recipients2, isLoading = isLoading },
		peoplePickerListResult = data.searchResult or current,
		shouldShowSocialRow = v5 and (v2 or v8)
	}
end

return useShareSheetRecipientModel
