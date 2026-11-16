local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill").Array
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort

local v5 = if FFlagShareSheetPeoplePickerEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/GetUniversalShareSheetStore") else nil

local GetExternalChatMessageSenderStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/UniversalAppPolicy").getAppFeaturePolicies
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
local RecipientSource = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local useRecipientList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/useRecipientList")
local getSelectableRecipients = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/getSelectableRecipients")
local useRecipientSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/useRecipientSearch")
local usePeoplePickerSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerSearch")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/ShareSheetView")

local v6 = if FFlagShareSheetPeoplePickerEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerViewModel") else nil

local useShareSheetRecipientModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetRecipientModel")
local useShareSheetSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetSelection")
local useShareSheetSend = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetSend")

local function useShareSheetViewModel(data)
	local recipientSource = if fFlagShareSheetFriendsSort then data.recipientSource else nil
	local v7, v8

	if FFlagShareSheetPeoplePickerEnabled then
		v7 = v5()
		v8 = SignalsReact.useSignalState(v7.getIsPeoplePickerDisplayed)
	else
		v7 = nil
	end

	local v9 = SignalsReact.useSignalState(GetExternalChatMessageSenderStore().getSender)
	local v10, v11

	if fFlagShareSheetFriendsSort then
		v10, v11 = useRecipientList(recipientSource or RecipientSource.DefaultRecipientSource, v9 ~= nil)
	else
		v10 = nil
	end

	local v12 = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then usePeoplePickerSearch() else nil

	local v13 = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then useRecipientSearch(v11, v12.debouncedQuery) else nil
	local state, setState

	if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		state, setState = React.useState({})
	else
		state = nil
		setState = nil
	end

	local v14

	if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
		v14 = React.useMemo(function()
			return getSelectableRecipients(v10.recipients, state)
		end, { v10.recipients, state })
	end

	local v15 = useShareSheetSelection()
	local selectedConversationIds = v15.selectedConversationIds
	local v17 = {
		chatShare = v9,
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

	if not (fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled) then
		v14 = if fFlagShareSheetFriendsSort then v10.recipients else nil
	end

	v17.recipients = v14

	v17.recipientSource = recipientSource
	v17.formatSuccessSnackbarText = data.formatSuccessSnackbarText
	v17.onCloseWithReason = data.onCloseWithReason
	v17.onSendActivated = v15.onSendActivated
	v17.onShareSendResultSnackbar = data.onShareSendResultSnackbar
	v17.selectedConversationIds = selectedConversationIds
	v17.telemetryId = data.telemetryId
	v17.url = data.url
	local v18 = useShareSheetSend(v17)

	local v20 = {
		listResult = if fFlagShareSheetFriendsSort then v10 else nil,
		chatShare = v9,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = v8,
		isSending = v18.isSending,
		searchResult = 0,
		pickedRecipients = 0,
		selectedConversationIds = 0
	}

	local v22 = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then v13.result else nil
	v20.searchResult = v22
	local v23 = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then state else nil
	v20.pickedRecipients = v23

	v20.selectedConversationIds = selectedConversationIds
	local v24 = useShareSheetRecipientModel(v20)

	local v25 = useLocalization({
		messagePlaceholder = "Feature.UniversalShareSheet.InputPlaceholder.ShareMessage",
		send = "CommonUI.Features.Action.Send",
		share = "Feature.SocialShare.Action.Share"
	})

	local v26 = React.useCallback(function()
		ShareSheetTelemetry.logInteraction({
			context = data.context,
			recipientSource = recipientSource,
			telemetryId = data.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CustomMessageComposerFocused
		})
	end, { data.context, recipientSource, data.telemetryId })
	local useCallback = React.useCallback
	local function fn(p2)
		if v18.isSending then
			return
		end

		local v27 = selectedConversationIds[p2] and "conversationDeselected" or "conversationSelected"

		ShareSheetTelemetry.logInteraction({
			context = data.context,
			telemetryId = data.telemetryId or "",
			interactionType = v27,
			recipientSource = recipientSource,
			requestedConversationId = p2
		})

		if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then
			local function hasId(p3): boolean
				return p3.id == p2
			end

			local v28 = array.find(v24.peoplePickerRecipients.recipients, hasId)
				or array.find(v24.socialRowRecipients.recipients, hasId)

			if v28 then
				setState(function(p3)
					if array.find(p3, hasId) then
						return p3
					end

					return (array.concat(p3, { v28 }))
				end)
			end
		end

		v15.onConversationActivated(p2)
	end

	local context = data.context

	local telemetryId = data.telemetryId

	local onConversationActivated = v15.onConversationActivated
	local isSending = v18.isSending

	local socialRowRecipients = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then v24.socialRowRecipients else nil

	local v28 = if fFlagShareSheetFriendsSort and FFlagShareSheetPeoplePickerEnabled then v24.peoplePickerRecipients else nil
	local v29 = useCallback(fn, {
		context,
		recipientSource,
		telemetryId,
		selectedConversationIds,
		onConversationActivated,
		isSending,
		socialRowRecipients,
		v28
	})
	local v30, v31

	if FFlagShareSheetPeoplePickerEnabled then
		v30 = React.useCallback(function()
			v7.setIsPeoplePickerDisplayed(true)
		end, { v7 })
		local v32 = React.useCallback(function()
			v7.setIsPeoplePickerDisplayed(false)
		end, { v7 })
		local peoplePickerEligibility = v24.peoplePickerEligibility
		local peoplePickerRecipients = v24.peoplePickerRecipients

		local v35 = if fFlagShareSheetFriendsSort then v13.filterQuery else nil

		local v36 = if not fFlagShareSheetFriendsSort then peoplePickerEligibility.eligibleConversations else nil
		local v37 = if fFlagShareSheetFriendsSort then peoplePickerRecipients.recipients else nil

		local v38 = if fFlagShareSheetFriendsSort then peoplePickerRecipients.isLoading else peoplePickerEligibility.isLoading
		local v34 = {
			filterQuery = v35,
			conversations = v36,
			recipients = v37,
			isEligibilityLoading = v38,
			isPeoplePickerDisplayed = v8 == true,
			listStatus = 0,
			loadMore = 0,
			listResult = 0,
			search = 0,
			onBack = 0,
			onConversationActivated = 0,
			selectedConversationIds = 0
		}

		local v39 = if not fFlagShareSheetFriendsSort then v24.listStatus else nil
		v34.listStatus = v39
		local v40 = if fFlagShareSheetFriendsSort then v13.pageList.loadMore else nil
		v34.loadMore = v40
		v34.listResult = v24.peoplePickerListResult

		if not fFlagShareSheetFriendsSort then
			v12 = nil
		end

		v34.search = v12
		v34.onBack = v32
		v34.onConversationActivated = v29
		v34.selectedConversationIds = selectedConversationIds
		v31 = v6(v34)
	end

	local v32 = {
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

	local v33 = if not fFlagShareSheetFriendsSort then v24.conversationEligibility else nil
	v32.conversationEligibility = v33

	local v34 = if fFlagShareSheetFriendsSort then v24.socialRowRecipients else nil
	v32.socialRowRecipients = v34
	v32.context = data.context
	v32.isOpen = data.isOpen == true

	if not FFlagShareSheetPeoplePickerEnabled then
		v8 = nil
	end

	v32.isPeoplePickerDisplayed = v8
	v32.isSending = v18.isSending
	v32.isSocialRowLoading = v24.isSocialRowLoading
	v32.messagePlaceholder = data.messagePlaceholder or v25.messagePlaceholder
	v32.onComposerFocused = v26
	v32.onCloseWithReason = data.onCloseWithReason
	v32.onConversationActivated = v29

	if not FFlagShareSheetPeoplePickerEnabled then
		v30 = nil
	end

	v32.onMoreActivated = v30
	v32.onSendActivated = v18.onSendActivated
	local v35 = if FFlagShareSheetPeoplePickerEnabled then v31.viewModel else nil
	v32.peoplePicker = v35
	v32.recipientSource = recipientSource
	v32.selectedConversationIds = selectedConversationIds
	v32.sendLabel = v25.send
	v32.shareLabel = v25.share
	v32.telemetryId = data.telemetryId
	v32.shouldShowSocialRow = v24.shouldShowSocialRow
	v32.url = data.url
	return v32
end

return useShareSheetViewModel
