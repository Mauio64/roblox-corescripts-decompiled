local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
local ListRecipientsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/ListRecipientsStatus")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local getSelectableRecipients = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/getSelectableRecipients")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function getCompactRecipients(recipients, items, selectedConversationIds, fn)
	local compactRecipients = {}
	local idSet = {}

	for i = 1, math.min(#recipients, ShareSheetConstants.FIntShareSheetMaxConversations) do
		local item = recipients[i]
		table.insert(compactRecipients, item)
		idSet[item.id] = true
	end

	for k, item in items do
		if not selectedConversationIds[item.id] or idSet[item.id] or not fn(item) then
			continue
		end

		table.insert(compactRecipients, item)
		idSet[item.id] = true
	end

	return compactRecipients
end

local function useShareSheetRecipientModel(data)
	local v5 = data.chatShare ~= nil
	local v6 = data.listResult

	local ref = React.useRef(v6)

	if data.isSending then
		v6 = ref.current
	else
		ref.current = v6
	end

	local v7 = #v6.recipients > 0
	local v8 = v6.status == ListRecipientsStatus.Failed
	local v9 = v6.status == ListRecipientsStatus.Loading
	local v10 = not (data.chatShare == nil) and data.chatShare.isAvailable
	local v11 = data.isOpen and v10 and v7
	local v12 = if data.chatShare then data.chatShare.isGroupChatEnabled else false

	local recipients = v6.recipients
	local v13 = Recipient.useEligibleRecipients({
		recipients = recipients,
		isActive = v11,
		isGroupChatEnabled = v12,
		maxCount = ShareSheetConstants.FIntShareSheetMaxConversations
	})

	local searchResult = data.searchResult
	local v14 = getSelectableRecipients(recipients, data.pickedRecipients)
	local useEligibleRecipients = Recipient.useEligibleRecipients

	if searchResult then
		recipients = searchResult.recipients
	end

	local v16 = useEligibleRecipients({
		recipients = recipients,
		isActive = v11 and data.isPeoplePickerDisplayed,
		isGroupChatEnabled = v12,
		maxCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
	})

	local v17 = {
		recipients = getCompactRecipients(v13.recipients, v14, data.selectedConversationIds, function(p2)
			return data.chatShare ~= nil and Recipient.canSend(data.chatShare, p2)
		end),
		isLoading = v13.isLoading
	}

	local v19 = if v16.isLoading and not v13.isLoading and searchResult == nil then v13.recipients else v16.recipients
	local v20

	if searchResult then
		if searchResult.status == ListRecipientsStatus.Loading then
			v20 = true
		else
			v20 = searchResult.status == ListRecipientsStatus.Ready and v16.isLoading
		end
	else
		v20 = not v8 and v16.isLoading
	end

	local v21 = v5 and v9
	return {
		socialRowRecipients = v17,
		isSocialRowLoading = v10 and v21,
		peoplePickerRecipients = { recipients = v19, isLoading = v20 },
		peoplePickerListResult = data.searchResult or v6,
		shouldShowSocialRow = v10 and (v7 or v21)
	}
end

return useShareSheetRecipientModel
