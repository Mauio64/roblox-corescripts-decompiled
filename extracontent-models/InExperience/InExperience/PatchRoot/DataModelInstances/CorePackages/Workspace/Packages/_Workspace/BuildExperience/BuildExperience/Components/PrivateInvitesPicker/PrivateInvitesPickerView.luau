local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local UserPickerList = require(BuildExperience.Components.UserPicker.UserPickerList)
local v6 = if not require(BuildExperience.Flags.FFlagBuildExperienceUseFoundationSheet) then require(BuildExperience.FoundationFork.Sheet) else Foundation.Sheet
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local SearchInput = Foundation.SearchInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize

local function PrivateInvitesPickerView(t1: {[any]: any}) -- line: 54
	-- upvalues: React (copy), View (copy), Button (copy), ButtonVariant (copy), InputSize (copy), v6 (copy), IconButton (copy), IconName (copy), SearchInput (copy), UserPickerList (copy)
	local v16 = t1.testId or "private-invites-picker"
	local v17 = React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y",
		testId = `{ v16 }-submit`
	}, {
		Send = React.createElement(Button, {
			LayoutOrder = 1,
			text = t1.sendButtonText,
			onActivated = t1.submit,
			isLoading = t1.isSubmitting,
			isDisabled = not t1.hasSelection,
			variant = ButtonVariant.Emphasis,
			size = InputSize.Medium,
			width = UDim.new(1, 0),
			testId = `{ v16 }-send`
		})
	})

	return React.createElement(v6.Root, {
		defaultSnapPointIndex = 1,
		isOpen = t1.isOpen,
		snapPoints = { 1 },
		onClose = t1.onClose,
		testId = v16
	}, {
		Header = React.createElement(v6.Header, {
			hasCloseAffordance = false
		}, {
			Back = React.createElement(IconButton, {
				LayoutOrder = 1,
				isCircular = true,
				icon = IconName.ChevronLargeLeft,
				onActivated = t1.onRequestClose,
				size = InputSize.Medium,
				testId = `{ v16 }-back`,
				variant = ButtonVariant.Utility
			}),
			Search = React.createElement(View, {
				LayoutOrder = 2,
				tag = "fill auto-y"
			}, {
				Input = React.createElement(SearchInput, {
					text = t1.searchText,
					onChanged = t1.setSearchText,
					placeholder = t1.searchPlaceholder,
					width = UDim.new(1, 0),
					testId = `{ v16 }-search`
				})
			})
		}),
		Content = React.createElement(v6.Content, {
			scrollingFrameRef = t1.scrollingFrameRef
		}, {
			List = React.createElement(UserPickerList, {
				userIds = t1.userIds,
				isLoading = t1.isLoading,
				searchText = t1.searchText,
				emptyText = t1.emptyText,
				isSelected = t1.isSelected,
				canSelect = t1.canSelect,
				toggleSelected = t1.toggleSelected,
				testId = v16
			})
		}),
		Actions = React.createElement(v6.Actions, nil, {
			Footer = v17
		})
	})
end

return PrivateInvitesPickerView
