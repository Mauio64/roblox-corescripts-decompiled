local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local UserPickerList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/UserPickerList")
local PrivateInviteAddErrorDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInviteAddErrorDialog")
local PrivateInviteAddRejectedDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PrivateInvitesPicker/PrivateInviteAddRejectedDialog")
local sheet = Foundation.Sheet
local button = Foundation.Button
local iconButton = Foundation.IconButton
local searchInput = Foundation.SearchInput
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize

local function PrivateInvitesPickerView(props)
	local testId = props.testId or "private-invites-picker"

	local element = React.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y", testId = `{testId}-submit` },
		{
			Send = React.createElement(button, {
				LayoutOrder = 1,
				text = props.sendButtonText,
				onActivated = props.submit,
				isLoading = props.isSubmitting,
				isDisabled = not props.hasSelection,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				testId = `{testId}-send`
			})
		}
	)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v6 = {
		Sheet = React.createElement(sheet.Root, {
			isOpen = props.isOpen,
			snapPoints = { 1 },
			defaultSnapPointIndex = 1,
			onClose = props.onClose,
			testId = testId
		}, {
			Header = React.createElement(sheet.Header, { hasCloseAffordance = false }, {
				Back = React.createElement(iconButton, {
					LayoutOrder = 1,
					icon = iconName.ChevronLargeLeft,
					isCircular = true,
					onActivated = props.onRequestClose,
					size = inputSize.Medium,
					testId = `{testId}-back`,
					variant = buttonVariant.Utility
				}),
				Search = React.createElement(view, {
					LayoutOrder = 2,
					tag = "fill auto-y"
				}, {
					Input = React.createElement(searchInput, {
						text = props.searchText,
						onChanged = props.setSearchText,
						placeholder = props.searchPlaceholder,
						width = UDim.new(1, 0),
						testId = `{testId}-search`
					})
				})
			}),
			Content = React.createElement(
				sheet.Content,
				{ scrollingFrameRef = props.scrollingFrameRef },
				{
					List = React.createElement(UserPickerList, {
						userIds = props.userIds,
						isLoading = props.isLoading,
						searchText = props.searchText,
						emptyText = props.emptyText,
						isSelected = props.isSelected,
						canSelect = props.canSelect,
						toggleSelected = props.toggleSelected,
						testId = testId
					})
				}
			),
			Actions = React.createElement(sheet.Actions, nil, { Footer = element })
		}),
		AddErrorDialog = 0,
		AddRejectedDialog = 0
	}

	local v7 = if props.hasAddError then React.createElement(PrivateInviteAddErrorDialog, {
		onDismiss = props.onDismissAddError
	}) else nil
	v6.AddErrorDialog = v7

	local v8 = if #props.rejectedInviteUserIds > 0 then React.createElement(PrivateInviteAddRejectedDialog, {
		rejectedUserIds = props.rejectedInviteUserIds,
		onDismiss = props.onDismissRejectedInvite
	}) else nil
	v6.AddRejectedDialog = v8
	return createElement(fragment, nil, v6)
end

return PrivateInvitesPickerView
