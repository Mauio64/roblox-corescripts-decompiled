local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local Foundation = require(BuildExperienceParent.Foundation)
local React = require(BuildExperienceParent.React)
local PickedUserList = require(BuildExperience.Components.UserPicker.PickedUserList)
local Badge = Foundation.Badge
local Button = Foundation.Button
local List = Foundation.List
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function PrivateInvitesManagementView(t1: {[any]: any}) -- line: 42
	-- upvalues: React (copy), List (copy), View (copy), FoundationText (copy), Badge (copy), Button (copy), ButtonVariant (copy), InputSize (copy), PickedUserList (copy)
	local v15 = t1.testId or "private-invites-management"
	local isInviteDisabled = t1.isInviteDisabled
	local v17 = React.createElement(List.Item, {
		LayoutOrder = 1,
		title = t1.inviteButtonText,
		onActivated = if not isInviteDisabled then t1.onOpenInvitePicker else nil,
		testId = `{ v15 }-invite-button`
	})
	local v18 = if not isInviteDisabled then v17 else React.createElement("CanvasGroup", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		GroupTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		Item = v17
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		testId = v15
	}, {
		Header = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-y-center gap-small size-full-0 auto-y"
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-title-large text-align-x-left content-default",
				Text = t1.title
			}),
			Count = React.createElement(Badge, {
				LayoutOrder = 2,
				text = t1.countText,
				testId = `{ v15 }-count`
			})
		}),
		Body = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted",
			Text = t1.subtitle
		}),
		ShareLink = React.createElement(View, {
			LayoutOrder = 3,
			tag = "row align-y-center gap-small size-full-0 auto-y padding-large stroke-standard stroke-default radius-large bg-surface-0",
			testId = `{ v15 }-share-link`
		}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "fill auto-y text-title-medium text-wrap text-align-x-left content-default",
				Text = t1.shareWithFriendsTitle
			}),
			Share = React.createElement(Button, {
				LayoutOrder = 2,
				text = t1.shareWithFriendsButtonText,
				onActivated = t1.onShareLink,
				variant = ButtonVariant.Standard,
				size = InputSize.Small,
				testId = `{ v15 }-share-link-button`
			})
		}),
		Table = React.createElement(PickedUserList, {
			layoutOrder = 4,
			userIds = t1.userIds,
			onRemove = t1.onRemove,
			removingUserIds = t1.removingUserIds,
			header = v18,
			testId = `{ v15 }-list`
		})
	})
end

return PrivateInvitesManagementView
