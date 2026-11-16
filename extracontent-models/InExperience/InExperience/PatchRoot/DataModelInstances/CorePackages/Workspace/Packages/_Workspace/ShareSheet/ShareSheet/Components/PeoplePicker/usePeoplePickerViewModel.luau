local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort

require(parent.AppChat.GetConversationListStore)
require(script.Parent.PeoplePickerHeader.PeoplePickerHeaderContainer)
require(script.Parent.PeoplePickerList.PeoplePickerListContainer)
local usePeoplePickerPagination = require(script.Parent.usePeoplePickerPagination)
local usePeoplePickerSearch = require(script.Parent.usePeoplePickerSearch)
require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Types)

local function usePeoplePickerViewModel(data)
	local v

	if FFlagShareSheetFriendsSort then
		v = data.search
	else
		v = usePeoplePickerSearch()
	end

	local conversationCount

	if FFlagShareSheetFriendsSort then
		conversationCount = #data.recipients
	else
		conversationCount = #data.conversations
	end

	local v2 = usePeoplePickerPagination({
		conversationCount = conversationCount,
		isEligibilityLoading = data.isEligibilityLoading,
		isPeoplePickerDisplayed = data.isPeoplePickerDisplayed,
		listStatus = data.listStatus,
		loadMore = data.loadMore,
		listResult = data.listResult
	})

	local viewModel = {
		headerProps = {
			goBack = React.useCallback(function()
				v.reset()
				data.onBack()
			end, { data.onBack, v.reset }),
			query = v.query,
			setQuery = v.setQuery
		},
		listProps = 0
	}

	local listProps = {
		conversations = data.conversations,
		recipients = data.recipients,
		filterQuery = 0,
		scrollResetQuery = 0,
		isLoading = 0,
		onConversationActivated = 0,
		paginationProps = 0,
		selectedConversationIds = 0,
		LayoutOrder = 1
	}
	local filterQuery

	if FFlagShareSheetFriendsSort then
		filterQuery = data.filterQuery
	else
		filterQuery = v.debouncedQuery
	end

	listProps.filterQuery = filterQuery
	listProps.scrollResetQuery = v.debouncedQuery
	listProps.isLoading = v2.isLoading
	listProps.onConversationActivated = data.onConversationActivated
	listProps.paginationProps = v2.paginationProps
	listProps.selectedConversationIds = data.selectedConversationIds
	viewModel.listProps = listProps
	return { viewModel = viewModel }
end

return usePeoplePickerViewModel
