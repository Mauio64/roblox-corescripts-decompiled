local array = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill").Array
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SignalsReact")

local GetUniversalShareSheetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Stores/GetUniversalShareSheetStore")
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
local usePeoplePickerViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerViewModel")
local useShareSheetRecipientModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetRecipientModel")
local useShareSheetSelection = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetSelection")
local useShareSheetSend = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/useShareSheetSend")

local function useShareSheetViewModel(data)
	local v5 = GetUniversalShareSheetStore()
	local v6 = SignalsReact.useSignalState(v5.getIsPeoplePickerDisplayed)
	local v7 = SignalsReact.useSignalState(GetExternalChatMessageSenderStore().getSender)

	local v8, v9 = useRecipientList(data.recipientSource or RecipientSource.DefaultRecipientSource, v7 ~= nil)

	local v10 = usePeoplePickerSearch()
	local v11 = useRecipientSearch(v9, v10.debouncedQuery)

	local state, setState = React.useState({})
	local v12 = React.useMemo(function()
		return getSelectableRecipients(v8.recipients, state)
	end, { v8.recipients, state })
	local v13 = useShareSheetSelection()
	local selectedConversationIds = v13.selectedConversationIds
	local v14 = useShareSheetSend({
		chatShare = v7,
		context = data.context,
		recipients = v12,
		recipientSource = data.recipientSource,
		formatSuccessSnackbarText = data.formatSuccessSnackbarText,
		onCloseWithReason = data.onCloseWithReason,
		onSendActivated = v13.onSendActivated,
		onShareSendResultSnackbar = data.onShareSendResultSnackbar,
		selectedConversationIds = selectedConversationIds,
		telemetryId = data.telemetryId,
		url = data.url
	})

	local v15 = useShareSheetRecipientModel({
		listResult = v8,
		chatShare = v7,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = v6,
		isSending = v14.isSending,
		searchResult = v11.result,
		pickedRecipients = state,
		selectedConversationIds = selectedConversationIds
	})

	local v16 = useLocalization({
		messagePlaceholder = "Feature.UniversalShareSheet.InputPlaceholder.ShareMessage",
		send = "CommonUI.Features.Action.Send",
		share = "Feature.SocialShare.Action.Share"
	})

	local v17 = React.useCallback(function()
		ShareSheetTelemetry.logInteraction({
			context = data.context,
			recipientSource = data.recipientSource,
			telemetryId = data.telemetryId or "",
			interactionType = ShareSheetTelemetry.InteractionType.CustomMessageComposerFocused
		})
	end, { data.context, data.recipientSource, data.telemetryId })
	local v18 = React.useCallback(function(p2)
		if v14.isSending then
			return
		end

		local v19 = selectedConversationIds[p2] and "conversationDeselected" or "conversationSelected"

		ShareSheetTelemetry.logInteraction({
			context = data.context,
			telemetryId = data.telemetryId or "",
			interactionType = v19,
			recipientSource = data.recipientSource,
			requestedConversationId = p2
		})

		local function hasId(p3): boolean
			return p3.id == p2
		end

		local v20 = array.find(v15.peoplePickerRecipients.recipients, hasId)
			or array.find(v15.socialRowRecipients.recipients, hasId)

		if v20 then
			setState(function(p3)
				if array.find(p3, hasId) then
					return p3
				end

				return (array.concat(p3, { v20 }))
			end)
		end

		v13.onConversationActivated(p2)
	end, {
		data.context,
		data.recipientSource,
		data.telemetryId,
		selectedConversationIds,
		v13.onConversationActivated,
		v14.isSending,
		v15.socialRowRecipients,
		v15.peoplePickerRecipients
	})

	local v19 = React.useCallback(function()
		v5.setIsPeoplePickerDisplayed(true)
	end, { v5 })
	local v20 = React.useCallback(function()
		v5.setIsPeoplePickerDisplayed(false)
	end, { v5 })
	local peoplePickerRecipients = v15.peoplePickerRecipients
	local v21 = usePeoplePickerViewModel({
		filterQuery = v11.filterQuery,
		recipients = peoplePickerRecipients.recipients,
		isEligibilityLoading = peoplePickerRecipients.isLoading,
		isPeoplePickerDisplayed = v6,
		loadMore = v11.pageList.loadMore,
		listResult = v15.peoplePickerListResult,
		search = v10,
		onBack = v20,
		onConversationActivated = v18,
		selectedConversationIds = selectedConversationIds
	})

	return {
		canShareLink = getAppFeaturePolicies().getEligibleForExternalContentSharing(),
		socialRowRecipients = v15.socialRowRecipients,
		context = data.context,
		isOpen = data.isOpen == true,
		isPeoplePickerDisplayed = v6,
		isSending = v14.isSending,
		isSocialRowLoading = v15.isSocialRowLoading,
		messagePlaceholder = data.messagePlaceholder or v16.messagePlaceholder,
		onComposerFocused = v17,
		onCloseWithReason = data.onCloseWithReason,
		onConversationActivated = v18,
		onMoreActivated = v19,
		onSendActivated = v14.onSendActivated,
		peoplePicker = v21.viewModel,
		recipientSource = data.recipientSource,
		selectedConversationIds = selectedConversationIds,
		sendLabel = v16.send,
		shareLabel = v16.share,
		telemetryId = data.telemetryId,
		shouldShowSocialRow = v15.shouldShowSocialRow,
		url = data.url
	}
end

return useShareSheetViewModel
