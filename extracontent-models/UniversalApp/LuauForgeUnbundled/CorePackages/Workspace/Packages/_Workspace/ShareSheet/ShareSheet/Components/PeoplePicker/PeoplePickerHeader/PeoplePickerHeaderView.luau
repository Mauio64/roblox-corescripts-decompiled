local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local iconButton = Foundation.IconButton
local searchInput = Foundation.SearchInput
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local searchInputShape = Foundation.Enums.SearchInputShape

local function PeoplePickerHeaderView(props)
	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-small padding-right-small",
			testId = "PeoplePickerHeaderView"
		},
		{
			Back = React.createElement(view, { tag = "auto-xy", LayoutOrder = 1 }, {
				Button = React.createElement(iconButton, {
					icon = iconName.ChevronLargeLeft,
					onActivated = props.goBack,
					size = inputSize.Medium,
					variant = buttonVariant.Utility,
					testId = "PeoplePickerHeaderView--back"
				})
			}),
			Field = React.createElement(view, { tag = "fill auto-y", LayoutOrder = 2 }, {
				Input = React.createElement(searchInput, {
					onChanged = props.onQueryChanged,
					placeholder = props.searchPlaceholder,
					shape = searchInputShape.Pill,
					size = inputSize.Medium,
					text = props.query,
					width = UDim.new(1, 0)
				})
			})
		}
	)
end

return PeoplePickerHeaderView
