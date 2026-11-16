local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerHeader/PeoplePickerHeaderContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerListContainer")
local usePeoplePickerPagination = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerPagination")
local usePeoplePickerSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerSearch")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function usePeoplePickerViewModel(data)
	local v5 = if fFlagShareSheetFriendsSort then data.search else usePeoplePickerSearch()

	local v8 = if fFlagShareSheetFriendsSort then #data.recipients else #data.conversations
	local v9 = usePeoplePickerPagination({
		conversationCount = v8,
		isEligibilityLoading = data.isEligibilityLoading,
		isPeoplePickerDisplayed = data.isPeoplePickerDisplayed,
		listStatus = data.listStatus,
		loadMore = data.loadMore,
		listResult = data.listResult
	})

	local v11 = {
		headerProps = {
			goBack = React.useCallback(function()
				v5.reset()
				data.onBack()
			end, { data.onBack, v5.reset }),
			query = v5.query,
			setQuery = v5.setQuery
		},
		listProps = 0
	}

	local v12 = {
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
	local v13 = if fFlagShareSheetFriendsSort then data.filterQuery else v5.debouncedQuery
	v12.filterQuery = v13
	v12.scrollResetQuery = v5.debouncedQuery
	v12.isLoading = v9.isLoading
	v12.onConversationActivated = data.onConversationActivated
	v12.paginationProps = v9.paginationProps
	v12.selectedConversationIds = data.selectedConversationIds
	v11.listProps = v12
	return { viewModel = v11 }
end

return usePeoplePickerViewModel
