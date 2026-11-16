local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local CreatorGroupRow = require(script.Parent.CreatorGroupRow)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local List = Foundation.List
local RadioGroup = Foundation.RadioGroup
local SearchInput = Foundation.SearchInput
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function MyCreationsFilterView(props)
	local testId = props.testId or "MyCreationsFilterView"

	local children = {}

	for k, gamesOption in props.gamesOptions do
		children[gamesOption.value] = React.createElement(RadioGroup.Item, {
			LayoutOrder = k,
			value = gamesOption.value,
			label = gamesOption.label,
			size = InputSize.Medium
		})
	end

	local children2 = {}

	for k, group in props.groups do
		children2[`Group{group.id}`] = React.createElement(CreatorGroupRow, {
			LayoutOrder = k,
			name = group.name,
			icon = group.icon,
			isSelected = group.isSelected,
			onActivated = group.onActivated,
			testId = `{testId}.Group.{group.id}`
		})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		Header = React.createElement(View, {
			LayoutOrder = props.LayoutOrder,
			tag = { ["composition-layout-detail"] = true, ["size-full-0 auto-y"] = true },
			testId = `{testId}.Layout`
		}, {
			Header = React.createElement(View, {
				tag = {
					["composition-content-body"] = true,
					["row align-y-center gap-small size-full-0 auto-y padding-y-small"] = true
				},
				testId = testId
			}, {
				Label = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.label,
					tag = "fill auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
					testId = `{testId}.Label`
				}),
				FilterButton = React.createElement(IconButton, {
					LayoutOrder = 2,
					icon = IconName.ThreeBarsHorizontalNarrowing,
					onActivated = props.onOpenSheet,
					size = InputSize.Small,
					testId = `{testId}.FilterButton`,
					variant = ButtonVariant.Utility
				})
			})
		}),
		Sheet = 0
	}

	local createElement2 = React.createElement
	local root = Sheet.Root
	local v2 = {
		isOpen = props.isSheetOpen,
		onClose = props.onSheetClosed,
		ref = props.focusRootRef,
		testId = `{testId}.Sheet`
	}
	local children3 = {
		Header = React.createElement(Sheet.Header, nil, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = props.titleText,
				tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = Sheet.Content
	local createElement4 = React.createElement

	local v3 = {
		Games = React.createElement(RadioGroup.Root, {
			LayoutOrder = 1,
			legend = props.gamesLegend,
			onValueChanged = props.onGamesChanged,
			tag = "size-full-0 auto-y",
			testId = `{testId}.Games`,
			value = props.selectedGames
		}, children),
		Groups = 0
	}
	local groups

	if props.isGroupsVisible then
		groups = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "col gap-large size-full-0 auto-y",
				testId = `{testId}.Groups`
			},
			{
				Legend = React.createElement(Text, {
					LayoutOrder = 1,
					Text = props.groupsLegend,
					tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
				}),
				Search = React.createElement(SearchInput, {
					LayoutOrder = 2,
					text = props.groupSearchText,
					placeholder = props.groupSearchPlaceholder,
					onChanged = props.onGroupSearchTextChanged,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					testId = `{testId}.GroupSearch`
				}),
				List = React.createElement(List.Root, {
					LayoutOrder = 3,
					hasDivider = true,
					isContained = true,
					size = InputSize.Medium,
					testId = `{testId}.GroupList`
				}, children2)
			}
		)
	end

	v3.Groups = groups
	children3.Content = createElement3(content, nil, {
		Body = createElement4(View, { tag = "col gap-xlarge size-full-0 auto-y" }, v3)
	})

	children3.Actions = React.createElement(Sheet.Actions, nil, {
		Apply = React.createElement(Button, {
			LayoutOrder = 1,
			text = props.applyText,
			size = InputSize.Medium,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onApply,
			testId = `{testId}.Apply`
		}),
		Reset = React.createElement(Button, {
			LayoutOrder = 2,
			text = props.resetText,
			size = InputSize.Medium,
			variant = ButtonVariant.Standard,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onReset,
			testId = `{testId}.Reset`
		})
	})
	v.Sheet = createElement2(root, v2, children3)
	return createElement(fragment, nil, v)
end

return MyCreationsFilterView
