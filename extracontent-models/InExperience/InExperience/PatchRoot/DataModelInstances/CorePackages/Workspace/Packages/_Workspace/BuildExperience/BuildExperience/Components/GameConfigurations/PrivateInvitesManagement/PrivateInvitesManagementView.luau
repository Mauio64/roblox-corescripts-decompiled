local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local PickedUserList = require(BuildExperience.Components.UserPicker.PickedUserList)

local Badge = Foundation.Badge
local List = Foundation.List
local Text = Foundation.Text
local View = Foundation.View

local function PrivateInvitesManagementView(props)
	local testId = props.testId or "private-invites-management"
	local isInviteDisabled = props.isInviteDisabled

	local createElement = React.createElement
	local item = List.Item
	local v = { LayoutOrder = 1, title = props.inviteButtonText, onActivated = 0, testId = 0 }
	local onActivated

	if not isInviteDisabled then
		onActivated = props.onOpenInvitePicker
	end

	v.onActivated = onActivated
	v.testId = `{testId}-invite-button`
	local header = createElement(item, v)

	if isInviteDisabled then
		header = React.createElement("CanvasGroup", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 0.5
		}, { Item = header })
	end

	return React.createElement(
		View,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = testId
		},
		{
			Header = React.createElement(
				View,
				{ LayoutOrder = 1, tag = "row align-y-center gap-small size-full-0 auto-y" },
				{
					Title = React.createElement(Text, {
						LayoutOrder = 1,
						Text = props.title,
						tag = "fill auto-y text-title-large text-align-x-left content-default"
					}),
					Count = React.createElement(Badge, {
						LayoutOrder = 2,
						text = props.countText,
						testId = `{testId}-count`
					})
				}
			),
			Body = React.createElement(Text, {
				LayoutOrder = 2,
				Text = props.subtitle,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted"
			}),
			Table = React.createElement(PickedUserList, {
				layoutOrder = 4,
				userIds = props.userIds,
				onRemove = props.onRemove,
				removingUserIds = props.removingUserIds,
				header = header,
				testId = `{testId}-list`
			})
		}
	)
end

return PrivateInvitesManagementView
