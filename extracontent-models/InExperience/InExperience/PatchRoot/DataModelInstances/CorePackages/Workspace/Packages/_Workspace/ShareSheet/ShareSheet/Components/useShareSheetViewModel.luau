local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local GetUniversalShareSheetStore

if FFlagShareSheetPeoplePickerEnabled then
	GetUniversalShareSheetStore = require(ShareSheet.Stores.GetUniversalShareSheetStore)
else
	GetUniversalShareSheetStore = nil
end

local GetExternalChatMessageSenderStore = require(parent.AppChat.GetExternalChatMessageSenderStore)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local getAppFeaturePolicies = UniversalAppPolicy.getAppFeaturePolicies
require(ShareSheet.Recipients.Recipient)
local RecipientSource = require(ShareSheet.Recipients.RecipientSource)
local useRecipientList = require(ShareSheet.Recipients.useRecipientList)
local getSelectableRecipients = require(ShareSheet.Recipients.getSelectableRecipients)
local useRecipientSearch = require(ShareSheet.Recipients.useRecipientSearch)
local usePeoplePickerSearch = require(script.Parent.PeoplePicker.usePeoplePickerSearch)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)
require(script.Parent.ShareSheetView)
local usePeoplePickerViewModel

if FFlagShareSheetPeoplePickerEnabled then
	usePeoplePickerViewModel = require(script.Parent.PeoplePicker.usePeoplePickerViewModel)
else
	usePeoplePickerViewModel = nil
end

local useShareSheetRecipientModel = require(script.Parent.useShareSheetRecipientModel)
local useShareSheetSelection = require(script.Parent.useShareSheetSelection)
local useShareSheetSend = require(script.Parent.useShareSheetSend)

local function useShareSheetViewModel(data)
	local recipientSource

	if FFlagShareSheetFriendsSort then
		recipientSource = data.recipientSource
	else
		recipientSource = nil
	end

	local v, isPeoplePickerDisplayed

	if FFlagShareSheetPeoplePickerEnabled then
		v = GetUniversalShareSheetStore()
		isPeoplePickerDisplayed = SignalsReact.useSignalState(v.getIsPeoplePickerDisplayed)
	else
		v = nil
	end

	local chatShare = SignalsReact.useSignalState(GetExternalChatMessageSenderStore().getSender)
	local v2, v3

	if FFlagShareSheetFriendsSort then
		v2, v3 = useRecipientList(recipientSource or RecipientSource.DefaultRecipientSource, chatShare ~= nil)
	else
		v2 = nil
	end

	local search

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		search = usePeoplePickerSearch()
	end

	local v4

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		v4 = useRecipientSearch(v3, search.debouncedQuery)
	end

	local state, setState

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		state, setState = React.useState({})
	else
		state = nil
		setState = nil
	end

	local recipients

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		recipients = React.useMemo(function()
			return getSelectableRecipients(v2.recipients, state)
		end, { v2.recipients, state })
	end

	local v5 = useShareSheetSelection()
	local selectedConversationIds = v5.selectedConversationIds
	local v6 = {
		chatShare = chatShare,
		context = data.context,
		recipients = 0,
		recipientSource = 0,
		formatSuccessSnackbarText = 0,
		onCloseWithReason = 0,
		onSendActivated = 0,
		onShareSendResultSnackbar = 0,
		selectedConversationIds = 0,
		telemetryId = 0,
		url = 0
	}

	if not (FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled) then
		if FFlagShareSheetFriendsSort then
			recipients = v2.recipients
		else
			recipients = nil
		end
	end

	v6.recipients = recipients

	v6.recipientSource = recipientSource
	v6.formatSuccessSnackbarText = data.formatSuccessSnackbarText
	v6.onCloseWithReason = data.onCloseWithReason
	v6.onSendActivated = v5.onSendActivated
	v6.onShareSendResultSnackbar = data.onShareSendResultSnackbar
	v6.selectedConversationIds = selectedConversationIds
	v6.telemetryId = data.telemetryId
	v6.url = data.url
	local v7 = useShareSheetSend(v6)
	local listResult

	if FFlagShareSheetFriendsSort then
		listResult = v2
	end

	local v8 = {
		listResult = listResult,
		chatShare = chatShare,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = isPeoplePickerDisplayed,
		isSending = v7.isSending,
		searchResult = 0,
		pickedRecipients = 0,
		selectedConversationIds = 0
	}
	local searchResult

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		searchResult = v4.result
	end

	v8.searchResult = searchResult
	local pickedRecipients

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		pickedRecipients = state
	end

	v8.pickedRecipients = pickedRecipients

	v8.selectedConversationIds = selectedConversationIds
	local v9 = useShareSheetRecipientModel(v8)

	local v10 = useLocalization({
		messagePlaceholder = "Feature.UniversalShareSheet.InputPlaceholder.ShareMessage",
		send = "CommonUI.Features.Action.Send",
		share = "Feature.SocialShare.Action.Share"
	})

	local onComposerFocused = React.useCallback(function()
		ShareSheetTelemetry.logInteraction({
			context = data.context,
			recipientSource = recipientSource,
			telemetryId = data.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CustomMessageComposerFocused
		})
	end, { data.context, recipientSource, data.telemetryId })
	local useCallback = React.useCallback
	local function fn(requestedConversationId: string)
		if v7.isSending then
			return
		end

		local interactionType = selectedConversationIds[requestedConversationId] and "conversationDeselected"
			or "conversationSelected"

		ShareSheetTelemetry.logInteraction({
			context = data.context,
			telemetryId = data.telemetryId or "",
			interactionType = interactionType,
			recipientSource = recipientSource,
			requestedConversationId = requestedConversationId
		})

		if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
			local function hasId(p): boolean
				return p.id == requestedConversationId
			end

			local v11 = Array.find(v9.peoplePickerRecipients.recipients, hasId)
				or Array.find(v9.socialRowRecipients.recipients, hasId)

			if v11 then
				setState(function(p)
					if Array.find(p, hasId) then
						return p
					end

					return (Array.concat(p, { v11 }))
				end)
			end
		end

		v5.onConversationActivated(requestedConversationId)
	end

	local context = data.context

	local telemetryId = data.telemetryId

	local onConversationActivated = v5.onConversationActivated
	local isSending = v7.isSending
	local socialRowRecipients

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		socialRowRecipients = v9.socialRowRecipients
	end

	local v11

	if FFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		v11 = v9.peoplePickerRecipients
	end

	local onConversationActivated2 = useCallback(fn, {
		context,
		recipientSource,
		telemetryId,
		selectedConversationIds,
		onConversationActivated,
		isSending,
		socialRowRecipients,
		v11
	})
	local onMoreActivated, v12

	if FFlagShareSheetPeoplePickerEnabled then
		onMoreActivated = React.useCallback(function()
			v.setIsPeoplePickerDisplayed(true)
		end, { v })
		local onBack = React.useCallback(function()
			v.setIsPeoplePickerDisplayed(false)
		end, { v })
		local peoplePickerEligibility = v9.peoplePickerEligibility
		local peoplePickerRecipients = v9.peoplePickerRecipients
		local filterQuery

		if FFlagShareSheetFriendsSort then
			filterQuery = v4.filterQuery
		end

		local conversations

		if not FFlagShareSheetFriendsSort then
			conversations = peoplePickerEligibility.eligibleConversations
		end

		local recipients2

		if FFlagShareSheetFriendsSort then
			recipients2 = peoplePickerRecipients.recipients
		end

		local isEligibilityLoading

		if FFlagShareSheetFriendsSort then
			isEligibilityLoading = peoplePickerRecipients.isLoading
		else
			isEligibilityLoading = peoplePickerEligibility.isLoading
		end

		local v13 = {
			filterQuery = filterQuery,
			conversations = conversations,
			recipients = recipients2,
			isEligibilityLoading = isEligibilityLoading,
			isPeoplePickerDisplayed = isPeoplePickerDisplayed == true,
			listStatus = 0,
			loadMore = 0,
			listResult = 0,
			search = 0,
			onBack = 0,
			onConversationActivated = 0,
			selectedConversationIds = 0
		}
		local listStatus

		if not FFlagShareSheetFriendsSort then
			listStatus = v9.listStatus
		end

		v13.listStatus = listStatus
		local loadMore

		if FFlagShareSheetFriendsSort then
			loadMore = v4.pageList.loadMore
		end

		v13.loadMore = loadMore
		v13.listResult = v9.peoplePickerListResult

		if not FFlagShareSheetFriendsSort then
			search = nil
		end

		v13.search = search
		v13.onBack = onBack
		v13.onConversationActivated = onConversationActivated2
		v13.selectedConversationIds = selectedConversationIds
		v12 = usePeoplePickerViewModel(v13)
	end

	local v13 = {
		canShareLink = getAppFeaturePolicies().getEligibleForExternalContentSharing(),
		conversationEligibility = 0,
		socialRowRecipients = 0,
		context = 0,
		isOpen = 0,
		isPeoplePickerDisplayed = 0,
		isSending = 0,
		isSocialRowLoading = 0,
		messagePlaceholder = 0,
		onComposerFocused = 0,
		onCloseWithReason = 0,
		onConversationActivated = 0,
		onMoreActivated = 0,
		onSendActivated = 0,
		peoplePicker = 0,
		recipientSource = 0,
		selectedConversationIds = 0,
		sendLabel = 0,
		shareLabel = 0,
		telemetryId = 0,
		shouldShowSocialRow = 0,
		url = 0
	}
	local conversationEligibility

	if not FFlagShareSheetFriendsSort then
		conversationEligibility = v9.conversationEligibility
	end

	v13.conversationEligibility = conversationEligibility
	local socialRowRecipients2

	if FFlagShareSheetFriendsSort then
		socialRowRecipients2 = v9.socialRowRecipients
	end

	v13.socialRowRecipients = socialRowRecipients2
	v13.context = data.context
	v13.isOpen = data.isOpen == true

	if not FFlagShareSheetPeoplePickerEnabled then
		isPeoplePickerDisplayed = nil
	end

	v13.isPeoplePickerDisplayed = isPeoplePickerDisplayed
	v13.isSending = v7.isSending
	v13.isSocialRowLoading = v9.isSocialRowLoading
	v13.messagePlaceholder = data.messagePlaceholder or v10.messagePlaceholder
	v13.onComposerFocused = onComposerFocused
	v13.onCloseWithReason = data.onCloseWithReason
	v13.onConversationActivated = onConversationActivated2

	if not FFlagShareSheetPeoplePickerEnabled then
		onMoreActivated = nil
	end

	v13.onMoreActivated = onMoreActivated
	v13.onSendActivated = v7.onSendActivated
	local peoplePicker

	if FFlagShareSheetPeoplePickerEnabled then
		peoplePicker = v12.viewModel
	end

	v13.peoplePicker = peoplePicker
	v13.recipientSource = recipientSource
	v13.selectedConversationIds = selectedConversationIds
	v13.sendLabel = v10.send
	v13.shareLabel = v10.share
	v13.telemetryId = data.telemetryId
	v13.shouldShowSocialRow = v9.shouldShowSocialRow
	v13.url = data.url
	return v13
end

return useShareSheetViewModel
