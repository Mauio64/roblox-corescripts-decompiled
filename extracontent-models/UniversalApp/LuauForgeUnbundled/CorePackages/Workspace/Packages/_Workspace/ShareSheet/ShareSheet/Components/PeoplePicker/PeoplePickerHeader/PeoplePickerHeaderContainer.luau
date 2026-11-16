local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local PeoplePickerHeaderView = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerHeader/PeoplePickerHeaderView")
local usePeoplePickerHeaderViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Components/PeoplePicker/PeoplePickerHeader/usePeoplePickerHeaderViewModel")

local function PeoplePickerHeaderContainer(p2)
	local v5 = usePeoplePickerHeaderViewModel(p2)

	return React.createElement(PeoplePickerHeaderView, v5)
end

return PeoplePickerHeaderContainer
