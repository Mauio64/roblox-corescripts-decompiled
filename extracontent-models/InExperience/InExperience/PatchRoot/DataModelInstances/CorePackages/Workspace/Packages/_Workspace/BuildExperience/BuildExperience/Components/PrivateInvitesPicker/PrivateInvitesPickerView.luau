local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local UserPickerList = require(BuildExperience.Components.UserPicker.UserPickerList)
local PrivateInviteAddErrorDialog = require(script.Parent.PrivateInviteAddErrorDialog)
local PrivateInviteAddRejectedDialog = require(script.Parent.PrivateInviteAddRejectedDialog)
local Sheet = Foundation.Sheet
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local SearchInput = Foundation.SearchInput
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function PrivateInvitesPickerView(props)
	local testId = props.testId or "private-invites-picker"

	local element = React.createElement(
		View,
		{ tag = "col gap-small size-full-0 auto-y", testId = `{testId}-submit` },
		{
			Send = React.createElement(Button, {
				LayoutOrder = 1,
				text = props.sendButtonText,
				onActivated = props.submit,
				isLoading = props.isSubmitting,
				isDisabled = not props.hasSelection,
				variant = ButtonVariant.Emphasis,
				size = InputSize.Medium,
				width = UDim.new(1, 0),
				testId = `{testId}-send`
			})
		}
	)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v = {
		Sheet = React.createElement(Sheet.Root, {
			isOpen = props.isOpen,
			snapPoints = { 1 },
			defaultSnapPointIndex = 1,
			onClose = props.onClose,
			testId = testId
		}, {
			Header = React.createElement(Sheet.Header, { hasCloseAffordance = false }, {
				Back = React.createElement(IconButton, {
					LayoutOrder = 1,
					icon = IconName.ChevronLargeLeft,
					isCircular = true,
					onActivated = props.onRequestClose,
					size = InputSize.Medium,
					testId = `{testId}-back`,
					variant = ButtonVariant.Utility
				}),
				Search = React.createElement(View, { LayoutOrder = 2, tag = "fill auto-y" }, {
					Input = React.createElement(SearchInput, {
						text = props.searchText,
						onChanged = props.setSearchText,
						placeholder = props.searchPlaceholder,
						width = UDim.new(1, 0),
						testId = `{testId}-search`
					})
				})
			}),
			Content = React.createElement(Sheet.Content, {
				scrollingFrameRef = props.scrollingFrameRef
			}, {
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
			}),
			Actions = React.createElement(Sheet.Actions, nil, { Footer = element })
		}),
		AddErrorDialog = 0,
		AddRejectedDialog = 0
	}
	local addErrorDialog

	if props.hasAddError then
		addErrorDialog = React.createElement(PrivateInviteAddErrorDialog, {
			onDismiss = props.onDismissAddError
		})
	end

	v.AddErrorDialog = addErrorDialog
	local addRejectedDialog

	if #props.rejectedInviteUserIds > 0 then
		addRejectedDialog = React.createElement(PrivateInviteAddRejectedDialog, {
			rejectedUserIds = props.rejectedInviteUserIds,
			onDismiss = props.onDismissRejectedInvite
		})
	end

	v.AddRejectedDialog = addRejectedDialog
	return createElement(fragment, nil, v)
end

return PrivateInvitesPickerView
