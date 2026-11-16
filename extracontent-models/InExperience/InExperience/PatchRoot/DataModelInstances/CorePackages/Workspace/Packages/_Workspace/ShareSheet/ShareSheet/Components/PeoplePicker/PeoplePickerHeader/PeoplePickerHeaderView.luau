local parent = script:FindFirstAncestor("ShareSheet").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local IconButton = Foundation.IconButton
local SearchInput = Foundation.SearchInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local SearchInputShape = Foundation.Enums.SearchInputShape

local function PeoplePickerHeaderView(props)
	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-xsmall size-full-0 auto-y padding-y-small padding-right-small",
			testId = "PeoplePickerHeaderView"
		},
		{
			Back = React.createElement(View, { tag = "auto-xy", LayoutOrder = 1 }, {
				Button = React.createElement(IconButton, {
					icon = IconName.ChevronLargeLeft,
					onActivated = props.goBack,
					size = InputSize.Medium,
					variant = ButtonVariant.Utility,
					testId = "PeoplePickerHeaderView--back"
				})
			}),
			Field = React.createElement(View, { tag = "fill auto-y", LayoutOrder = 2 }, {
				Input = React.createElement(SearchInput, {
					onChanged = props.onQueryChanged,
					placeholder = props.searchPlaceholder,
					shape = SearchInputShape.Pill,
					size = InputSize.Medium,
					text = props.query,
					width = UDim.new(1, 0)
				})
			})
		}
	)
end

return PeoplePickerHeaderView
