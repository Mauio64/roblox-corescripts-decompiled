local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

require(script.Parent.PeoplePickerHeader.PeoplePickerHeaderContainer)
require(script.Parent.PeoplePickerList.PeoplePickerListContainer)
local usePeoplePickerPagination = require(script.Parent.usePeoplePickerPagination)
require(script.Parent.usePeoplePickerSearch)
require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Types)

local function usePeoplePickerViewModel(data)
	local search = data.search
	local v = usePeoplePickerPagination({
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
				isLoading = v.isLoading,
				onConversationActivated = data.onConversationActivated,
				paginationProps = v.paginationProps,
				selectedConversationIds = data.selectedConversationIds,
				LayoutOrder = 1
			}
		}
	}
end

return usePeoplePickerViewModel
