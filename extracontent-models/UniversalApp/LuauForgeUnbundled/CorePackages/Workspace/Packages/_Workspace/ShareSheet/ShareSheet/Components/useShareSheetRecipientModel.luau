local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
local fetchConversationListPageToSignals = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/fetchConversationListPageToSignals")
local useExternalChatConversationEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/useExternalChatConversationEligibility")
local ListRecipientsStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/ListRecipientsStatus")
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local getSelectableRecipients = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/getSelectableRecipients")
local ShareSheetConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/ShareSheetConstants")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local useConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/useConversationList")

local function getCompactConversations(eligibleConversations, items, selectedConversationIds, fn)
	local compactConversations = {}
	local idSet = {}

	for i = 1, math.min(#eligibleConversations, ShareSheetConstants.FIntShareSheetMaxConversations) do
		local item = eligibleConversations[i]
		table.insert(compactConversations, item)
		idSet[item.id] = true
	end

	for k, item in items do
		if not selectedConversationIds[item.id] or idSet[item.id] or not fn(item) then
			continue
		end

		table.insert(compactConversations, item)
		idSet[item.id] = true
	end

	return compactConversations
end

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
	local v6 = nil
	local v7 = nil
	local items = nil
	local v8, v9, v10

	if fFlagShareSheetFriendsSort then
		v7 = data.listResult

		local ref = React.useRef(v7)

		if data.isSending then
			v7 = ref.current
		else
			ref.current = v7
		end

		v8 = #v7.recipients > 0
		v9 = v7.status == ListRecipientsStatus.Failed
		v10 = v7.status == ListRecipientsStatus.Loading
	else
		v6 = useConversationList(v5)

		local ref = React.useRef(v6)

		if data.isSending then
			v6 = ref.current
		else
			ref.current = v6
		end

		items = v6.items
		v8 = #items > 0
		local listStatus = v6.listStatus
		v9 = listStatus.error ~= nil

		if #items == 0 and listStatus.error == nil then
			v10 = listStatus.isFetchingConversations == true or listStatus.hasFetchedInitialPage ~= true
		else
			v10 = false
		end
	end

	local v11 = not (data.chatShare == nil) and data.chatShare.isAvailable
	local v12 = data.isOpen and v11 and v8
	local v13 = if data.chatShare then data.chatShare.isGroupChatEnabled else false

	local v14 = nil
	local v15 = nil
	local v16 = nil
	local v17 = nil

	if fFlagShareSheetFriendsSort then
		local recipients = v7.recipients
		local v18 = Recipient.useEligibleRecipients({
			recipients = recipients,
			isActive = v12,
			isGroupChatEnabled = v13,
			maxCount = ShareSheetConstants.FIntShareSheetMaxConversations
		})

		if FFlagShareSheetPeoplePickerEnabled then
			local searchResult = data.searchResult
			local v19 = getSelectableRecipients(recipients, data.pickedRecipients)
			local useEligibleRecipients = Recipient.useEligibleRecipients

			if searchResult then
				recipients = searchResult.recipients
			end

			local v21 = useEligibleRecipients({
				recipients = recipients,
				isActive = v12 and data.isPeoplePickerDisplayed == true,
				isGroupChatEnabled = v13,
				maxCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
			})

			v15 = {
				recipients = getCompactRecipients(
					v18.recipients,
					v19,
					data.selectedConversationIds,
					function(p2)
						return data.chatShare ~= nil and Recipient.canSend(data.chatShare, p2)
					end
				),
				isLoading = v18.isLoading
			}

			v17 = { recipients = 0, isLoading = 0 }
			local v22 = if v21.isLoading and not v18.isLoading and searchResult == nil then v18.recipients else v21.recipients
			v17.recipients = v22
			local v23

			if searchResult then
				if searchResult.status == ListRecipientsStatus.Loading then
					v23 = true
				else
					v23 = searchResult.status == ListRecipientsStatus.Ready and v21.isLoading
				end
			else
				v23 = not v9 and v21.isLoading
			end

			v17.isLoading = v23
		else
			v15 = v18
		end
	else
		local v18 = useExternalChatConversationEligibility({
			conversations = items,
			isActive = v12,
			isGroupChatEnabled = v13,
			maxConversationCount = ShareSheetConstants.FIntShareSheetMaxConversations
		})

		if FFlagShareSheetPeoplePickerEnabled then
			local v19 = useExternalChatConversationEligibility({
				conversations = items,
				isActive = v12 and data.isPeoplePickerDisplayed == true,
				isGroupChatEnabled = v13,
				maxConversationCount = ShareSheetConstants.FIntShareSheetPeoplePickerMaxConversations
			})

			v14 = {
				eligibleConversations = getCompactConversations(
					v18.eligibleConversations,
					items,
					data.selectedConversationIds,
					function(p2)
						return data.chatShare ~= nil and data.chatShare.canSendToConversation(p2)
					end
				),
				isLoading = v18.isLoading
			}

			v16 = { eligibleConversations = 0, isLoading = 0 }
			local v20 = if v19.isLoading and not v18.isLoading then v18.eligibleConversations else v19.eligibleConversations
			v16.eligibleConversations = v20

			v16.isLoading = not v9 and v19.isLoading
		else
			v14 = v18
		end
	end

	if not fFlagShareSheetFriendsSort then
		React.useEffect(function()
			if v5 then
				fetchConversationListPageToSignals()
			end
		end, { v5 })
	end

	local v18 = v5 and v10

	local v20 = if not fFlagShareSheetFriendsSort then v6.listStatus else nil

	local v21 = if fFlagShareSheetFriendsSort then data.searchResult or v7 else nil
	return {
		conversationEligibility = v14,
		socialRowRecipients = v15,
		isSocialRowLoading = v11 and v18,
		listStatus = v20,
		peoplePickerEligibility = v16,
		peoplePickerRecipients = v17,
		peoplePickerListResult = v21,
		shouldShowSocialRow = v11 and (v8 or v18)
	}
end

return useShareSheetRecipientModel
