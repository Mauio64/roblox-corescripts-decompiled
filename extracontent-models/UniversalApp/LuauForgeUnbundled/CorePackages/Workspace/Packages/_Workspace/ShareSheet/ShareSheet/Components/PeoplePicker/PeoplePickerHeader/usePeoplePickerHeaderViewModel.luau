local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerHeader/PeoplePickerHeaderView")

local function usePeoplePickerHeaderViewModel(data)
	local v5 = useLocalization({ searchPlaceholder = "CommonUI.Controls.Action.Search" })

	return {
		goBack = data.goBack,
		onQueryChanged = data.setQuery,
		query = data.query,
		searchPlaceholder = v5.searchPlaceholder
	}
end

return usePeoplePickerHeaderViewModel
