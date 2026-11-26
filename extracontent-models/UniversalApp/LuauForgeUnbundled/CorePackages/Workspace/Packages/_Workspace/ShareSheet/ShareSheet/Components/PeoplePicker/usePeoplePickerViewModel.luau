local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerHeader/PeoplePickerHeaderContainer")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerList/PeoplePickerListContainer")
local usePeoplePickerPagination = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerPagination")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/usePeoplePickerSearch")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Types")

local function usePeoplePickerViewModel(data)
	local search = data.search
	local v5 = usePeoplePickerPagination({
		conversationCount = #data.recipients,
		isEligibilityLoading = data.isEligibilityLoading,
		isPeoplePickerDisplayed = data.isPeoplePickerDisplayed,
		loadMore = data.loadMore,
		listResult = data.listResult
	})

	return {
		viewModel = {
			headerProps = {
				goBack = React.useCallback(function()
					search.reset()
					data.onBack()
				end, { data.onBack, search.reset }),
				query = search.query,
				setQuery = search.setQuery
			},
			listProps = {
				recipients = data.recipients,
				filterQuery = data.filterQuery,
				scrollResetQuery = search.debouncedQuery,
				isLoading = v5.isLoading,
				onConversationActivated = data.onConversationActivated,
				paginationProps = v5.paginationProps,
				selectedConversationIds = data.selectedConversationIds,
				LayoutOrder = 1
			}
		}
	}
end

return usePeoplePickerViewModel
