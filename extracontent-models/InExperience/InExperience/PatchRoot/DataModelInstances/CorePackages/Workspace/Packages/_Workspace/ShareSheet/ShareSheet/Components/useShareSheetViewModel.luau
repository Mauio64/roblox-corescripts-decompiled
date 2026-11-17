local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetUniversalShareSheetStore = require(ShareSheet.Stores.GetUniversalShareSheetStore)
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
local usePeoplePickerViewModel = require(script.Parent.PeoplePicker.usePeoplePickerViewModel)
local useShareSheetRecipientModel = require(script.Parent.useShareSheetRecipientModel)
local useShareSheetSelection = require(script.Parent.useShareSheetSelection)
local useShareSheetSend = require(script.Parent.useShareSheetSend)

local function useShareSheetViewModel(data)
	local universalShareSheetStore = GetUniversalShareSheetStore()
	local isPeoplePickerDisplayed = SignalsReact.useSignalState(universalShareSheetStore.getIsPeoplePickerDisplayed)
	local chatShare = SignalsReact.useSignalState(GetExternalChatMessageSenderStore().getSender)

	local listResult, v = useRecipientList(
		data.recipientSource or RecipientSource.DefaultRecipientSource,
		chatShare ~= nil
	)

	local search = usePeoplePickerSearch()
	local v2 = useRecipientSearch(v, search.debouncedQuery)

	local state, setState = React.useState({})
	local recipients = React.useMemo(function()
		return getSelectableRecipients(listResult.recipients, state)
	end, { listResult.recipients, state })
	local v3 = useShareSheetSelection()
	local selectedConversationIds = v3.selectedConversationIds
	local v4 = useShareSheetSend({
		chatShare = chatShare,
		context = data.context,
		recipients = recipients,
		recipientSource = data.recipientSource,
		formatSuccessSnackbarText = data.formatSuccessSnackbarText,
		onCloseWithReason = data.onCloseWithReason,
		onSendActivated = v3.onSendActivated,
		onShareSendResultSnackbar = data.onShareSendResultSnackbar,
		selectedConversationIds = selectedConversationIds,
		telemetryId = data.telemetryId,
		url = data.url
	})

	local v5 = useShareSheetRecipientModel({
		listResult = listResult,
		chatShare = chatShare,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = isPeoplePickerDisplayed,
		isSending = v4.isSending,
		searchResult = v2.result,
		pickedRecipients = state,
		selectedConversationIds = selectedConversationIds
	})

	local v6 = useLocalization({
		messagePlaceholder = "Feature.UniversalShareSheet.InputPlaceholder.ShareMessage",
		send = "CommonUI.Features.Action.Send",
		share = "Feature.SocialShare.Action.Share"
	})

	local onComposerFocused = React.useCallback(function()
		ShareSheetTelemetry.logInteraction({
			context = data.context,
			recipientSource = data.recipientSource,
			telemetryId = data.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CustomMessageComposerFocused
		})
	end, { data.context, data.recipientSource, data.telemetryId })
	local onConversationActivated = React.useCallback(function(requestedConversationId: string)
		if v4.isSending then
			return
		end

		local interactionType = selectedConversationIds[requestedConversationId] and "conversationDeselected"
			or "conversationSelected"

		ShareSheetTelemetry.logInteraction({
			context = data.context,
			telemetryId = data.telemetryId or "",
			interactionType = interactionType,
			recipientSource = data.recipientSource,
			requestedConversationId = requestedConversationId
		})

		local function hasId(p): boolean
			return p.id == requestedConversationId
		end

		local v7 = Array.find(v5.peoplePickerRecipients.recipients, hasId)
			or Array.find(v5.socialRowRecipients.recipients, hasId)

		if v7 then
			setState(function(p)
				if Array.find(p, hasId) then
					return p
				end

				return (Array.concat(p, { v7 }))
			end)
		end

		v3.onConversationActivated(requestedConversationId)
	end, {
		data.context,
		data.recipientSource,
		data.telemetryId,
		selectedConversationIds,
		v3.onConversationActivated,
		v4.isSending,
		v5.socialRowRecipients,
		v5.peoplePickerRecipients
	})

	local onMoreActivated = React.useCallback(function()
		universalShareSheetStore.setIsPeoplePickerDisplayed(true)
	end, { universalShareSheetStore })
	local onBack = React.useCallback(function()
		universalShareSheetStore.setIsPeoplePickerDisplayed(false)
	end, { universalShareSheetStore })
	local peoplePickerRecipients = v5.peoplePickerRecipients
	local v7 = usePeoplePickerViewModel({
		filterQuery = v2.filterQuery,
		recipients = peoplePickerRecipients.recipients,
		isEligibilityLoading = peoplePickerRecipients.isLoading,
		isPeoplePickerDisplayed = isPeoplePickerDisplayed,
		loadMore = v2.pageList.loadMore,
		listResult = v5.peoplePickerListResult,
		search = search,
		onBack = onBack,
		onConversationActivated = onConversationActivated,
		selectedConversationIds = selectedConversationIds
	})

	return {
		canShareLink = getAppFeaturePolicies().getEligibleForExternalContentSharing(),
		socialRowRecipients = v5.socialRowRecipients,
		context = data.context,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = isPeoplePickerDisplayed,
		isSending = v4.isSending,
		isSocialRowLoading = v5.isSocialRowLoading,
		messagePlaceholder = data.messagePlaceholder or v6.messagePlaceholder,
		onComposerFocused = onComposerFocused,
		onCloseWithReason = data.onCloseWithReason,
		onConversationActivated = onConversationActivated,
		onMoreActivated = onMoreActivated,
		onSendActivated = v4.onSendActivated,
		peoplePicker = v7.viewModel,
		recipientSource = data.recipientSource,
		selectedConversationIds = selectedConversationIds,
		sendLabel = v6.send,
		shareLabel = v6.share,
		telemetryId = data.telemetryId,
		shouldShowSocialRow = v5.shouldShowSocialRow,
		url = data.url
	}
end

return useShareSheetViewModel
