local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)
require(parent.AppChat.GetConversationListStore)
require(parent.AppChat.GetExternalChatMessageSenderStore)
local fetchConversationListPageToSignals = require(parent.AppChat.fetchConversationListPageToSignals)
local useExternalChatConversationEligibility = require(parent.AppChat.useExternalChatConversationEligibility)
local ListRecipientsStatus = require(ShareSheet.Recipients.ListRecipientsStatus)
local Recipient = require(ShareSheet.Recipients.Recipient)
local getSelectableRecipients = require(ShareSheet.Recipients.getSelectableRecipients)
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
require(ShareSheet.Types)

local useConversationList = require(parent.AppChat.useConversationList)

local function getCompactConversations(eligibleConversations, items, selectedConversationIds, fn)
	local compactConversations = {}
	local idSet = {}

	for i = 1, math.min(#eligibleConversations, ShareSheetConstants.FIntShareSheetMaxConversations) do
		local item = eligibleConversations[i]
		table.insert(compactConversations, item)
		idSet[item.id] = true
	end

	for _, item in items do
		if not selectedConversationIds[item.id] or idSet[item.id] or not fn(item) then
			continue
		end

		table.insert(compactConversations, item)
		idSet[item.id] = true
	end

	return compactConversations
end

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
	local current = nil
	local current2 = nil
	local items = nil
	local v2, v3, v4

	if FFlagShareSheetFriendsSort then
		current2 = data.listResult

		local ref = React.useRef(current2)

		if data.isSending then
			current2 = ref.current
		else
			ref.current = current2
		end

		v2 = #current2.recipients > 0
		v3 = current2.status == ListRecipientsStatus.Failed
		v4 = current2.status == ListRecipientsStatus.Loading
	else
		current = useConversationList(v)

		local ref = React.useRef(current)

		if data.isSending then
			current = ref.current
		else
			ref.current = current
		end

		items = current.items
		v2 = #items > 0
		local listStatus = current.listStatus
		v3 = listStatus.error ~= nil

		if #items == 0 and listStatus.error == nil then
			v4 = listStatus.isFetchingConversations == true or listStatus.hasFetchedInitialPage ~= true
		else
			v4 = false
		end
	end

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

	local conversationEligibility = nil
	local socialRowRecipients = nil
	local peoplePickerEligibility = nil
	local peoplePickerRecipients = nil

	if FFlagShareSheetFriendsSort then
		local recipients = current2.recipients
		local v6 = Recipient.useEligibleRecipients({
			recipients = recipients,
			isActive = isActive,
			isGroupChatEnabled = isGroupChatEnabled,
			maxCount = ShareSheetConstants.FIntShareSheetMaxConversations
		})

		if FFlagShareSheetPeoplePickerEnabled then
			local searchResult = data.searchResult
			local selectableRecipients = getSelectableRecipients(recipients, data.pickedRecipients)
			local useEligibleRecipients = Recipient.useEligibleRecipients

			if searchResult then
				recipients = searchResult.recipients
			end

			local v7 = useEligibleRecipients({
				recipients = recipients,
				isActive = isActive and data.isPeoplePickerDisplayed == true,
				isGroupChatEnabled = isGroupChatEnabled,
				maxCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
			})

			socialRowRecipients = {
				recipients = getCompactRecipients(
					v6.recipients,
					selectableRecipients,
					data.selectedConversationIds,
					function(p)
						return data.chatShare ~= nil and Recipient.canSend(data.chatShare, p)
					end
				),
				isLoading = v6.isLoading
			}

			peoplePickerRecipients = { recipients = 0, isLoading = 0 }
			local recipients2

			if v7.isLoading and not v6.isLoading and searchResult == nil then
				recipients2 = v6.recipients
			else
				recipients2 = v7.recipients
			end

			peoplePickerRecipients.recipients = recipients2
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

			peoplePickerRecipients.isLoading = isLoading
		else
			socialRowRecipients = v6
		end
	else
		local v6 = useExternalChatConversationEligibility({
			conversations = items,
			isActive = isActive,
			isGroupChatEnabled = isGroupChatEnabled,
			maxConversationCount = ShareSheetConstants.FIntShareSheetMaxConversations
		})

		if FFlagShareSheetPeoplePickerEnabled then
			local v7 = useExternalChatConversationEligibility({
				conversations = items,
				isActive = isActive and data.isPeoplePickerDisplayed == true,
				isGroupChatEnabled = isGroupChatEnabled,
				maxConversationCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
			})

			conversationEligibility = {
				eligibleConversations = getCompactConversations(
					v6.eligibleConversations,
					items,
					data.selectedConversationIds,
					function(p)
						return data.chatShare ~= nil and data.chatShare.canSendToConversation(p)
					end
				),
				isLoading = v6.isLoading
			}

			peoplePickerEligibility = { eligibleConversations = 0, isLoading = 0 }
			local eligibleConversations

			if v7.isLoading and not v6.isLoading then
				eligibleConversations = v6.eligibleConversations
			else
				eligibleConversations = v7.eligibleConversations
			end

			peoplePickerEligibility.eligibleConversations = eligibleConversations

			peoplePickerEligibility.isLoading = not v3 and v7.isLoading
		else
			conversationEligibility = v6
		end
	end

	if not FFlagShareSheetFriendsSort then
		React.useEffect(function()
			if v then
				fetchConversationListPageToSignals()
			end
		end, { v })
	end

	local v6 = v and v4

	local v7 = {
		conversationEligibility = conversationEligibility,
		socialRowRecipients = socialRowRecipients,
		isSocialRowLoading = v5 and v6,
		listStatus = 0,
		peoplePickerEligibility = 0,
		peoplePickerRecipients = 0,
		peoplePickerListResult = 0,
		shouldShowSocialRow = 0
	}
	local listStatus

	if not FFlagShareSheetFriendsSort then
		listStatus = current.listStatus
	end

	v7.listStatus = listStatus
	v7.peoplePickerEligibility = peoplePickerEligibility
	v7.peoplePickerRecipients = peoplePickerRecipients
	local peoplePickerListResult

	if FFlagShareSheetFriendsSort then
		peoplePickerListResult = data.searchResult or current2
	end

	v7.peoplePickerListResult = peoplePickerListResult
	v7.shouldShowSocialRow = v5 and (v2 or v6)
	return v7
end

return useShareSheetRecipientModel
