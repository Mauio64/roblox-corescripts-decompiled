local parent = script:FindFirstAncestor("ShareSheet").Parent

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(script.Parent.PeoplePickerHeaderView)

local function usePeoplePickerHeaderViewModel(data)
	local v = useLocalization({ searchPlaceholder = "CommonUI.Controls.Action.Search" })

	return {
		goBack = data.goBack,
		onQueryChanged = data.setQuery,
		query = data.query,
		searchPlaceholder = v.searchPlaceholder
	}
end

return usePeoplePickerHeaderViewModel
