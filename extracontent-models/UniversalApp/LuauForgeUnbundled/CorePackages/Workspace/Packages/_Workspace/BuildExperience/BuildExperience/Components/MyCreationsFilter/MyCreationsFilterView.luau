local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local CreatorGroupRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MyCreationsFilter/CreatorGroupRow")

local button = Foundation.Button
local iconButton = Foundation.IconButton
local list = Foundation.List
local radioGroup = Foundation.RadioGroup
local searchInput = Foundation.SearchInput
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function MyCreationsFilterView(props)
	local testId = props.testId or "MyCreationsFilterView"

	local children = {}

	for k, gamesOption in props.gamesOptions do
		children[gamesOption.value] = React.createElement(radioGroup.Item, {
			LayoutOrder = k,
			value = gamesOption.value,
			label = gamesOption.label,
			size = inputSize.Medium
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
	local v6 = {
		Header = React.createElement(view, {
			LayoutOrder = props.LayoutOrder,
			tag = {
				["composition-layout-detail"] = true,
				["size-full-0 auto-y"] = true
			},
			testId = `{testId}.Layout`
		}, {
			Header = React.createElement(view, {
				tag = {
					["composition-content-body"] = true,
					["row align-y-center gap-small size-full-0 auto-y padding-y-small"] = true
				},
				testId = testId
			}, {
				Label = React.createElement(text, {
					LayoutOrder = 1,
					Text = props.label,
					tag = "fill auto-y text-heading-small text-align-x-left text-truncate-end content-emphasis",
					testId = `{testId}.Label`
				}),
				FilterButton = React.createElement(iconButton, {
					LayoutOrder = 2,
					icon = iconName.ThreeBarsHorizontalNarrowing,
					onActivated = props.onOpenSheet,
					size = inputSize.Small,
					testId = `{testId}.FilterButton`,
					variant = buttonVariant.Utility
				})
			})
		}),
		Sheet = 0
	}

	local createElement2 = React.createElement
	local root = sheet.Root
	local v7 = {
		isOpen = props.isSheetOpen,
		onClose = props.onSheetClosed,
		ref = props.focusRootRef,
		testId = `{testId}.Sheet`
	}
	local children3 = {
		Header = React.createElement(sheet.Header, nil, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.titleText,
				tag = "shrink auto-xy text-heading-small text-wrap text-align-x-left content-emphasis"
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement3 = React.createElement
	local content = sheet.Content
	local createElement4 = React.createElement

	local v12 = {
		Games = React.createElement(radioGroup.Root, {
			LayoutOrder = 1,
			legend = props.gamesLegend,
			onValueChanged = props.onGamesChanged,
			tag = "size-full-0 auto-y",
			testId = `{testId}.Games`,
			value = props.selectedGames
		}, children),
		Groups = 0
	}

	local v13 = if props.isGroupsVisible then React.createElement(
		view,
		{
			LayoutOrder = 2,
			tag = "col gap-large size-full-0 auto-y",
			testId = `{testId}.Groups`
		},
		{
			Legend = React.createElement(text, {
				LayoutOrder = 1,
				Text = props.groupsLegend,
				tag = "auto-xy text-title-medium text-wrap text-align-x-left content-emphasis"
			}),
			Search = React.createElement(searchInput, {
				LayoutOrder = 2,
				text = props.groupSearchText,
				placeholder = props.groupSearchPlaceholder,
				onChanged = props.onGroupSearchTextChanged,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				testId = `{testId}.GroupSearch`
			}),
			List = React.createElement(list.Root, {
				LayoutOrder = 3,
				hasDivider = true,
				isContained = true,
				size = inputSize.Medium,
				testId = `{testId}.GroupList`
			}, children2)
		}
	) else nil
	v12.Groups = v13
	children3.Content = createElement3(content, nil, {
		Body = createElement4(view, { tag = "col gap-xlarge size-full-0 auto-y" }, v12)
	})

	children3.Actions = React.createElement(sheet.Actions, nil, {
		Apply = React.createElement(button, {
			LayoutOrder = 1,
			text = props.applyText,
			size = inputSize.Medium,
			variant = buttonVariant.Emphasis,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onApply,
			testId = `{testId}.Apply`
		}),
		Reset = React.createElement(button, {
			LayoutOrder = 2,
			text = props.resetText,
			size = inputSize.Medium,
			variant = buttonVariant.Standard,
			fillBehavior = fillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = props.onReset,
			testId = `{testId}.Reset`
		})
	})
	v6.Sheet = createElement2(root, v7, children3)
	return createElement(fragment, nil, v6)
end

return MyCreationsFilterView
