local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local PickedUserList = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/UserPicker/PickedUserList")

local badge = Foundation.Badge
local list = Foundation.List
local text = Foundation.Text
local view = Foundation.View

local function PrivateInvitesManagementView(props)
	local testId = props.testId or "private-invites-management"
	local isInviteDisabled = props.isInviteDisabled

	local createElement = React.createElement
	local item = list.Item
	local v5 = {
		LayoutOrder = 1,
		title = props.inviteButtonText,
		onActivated = 0,
		testId = 0
	}
	local v6 = if not isInviteDisabled then props.onOpenInvitePicker else nil
	v5.onActivated = v6
	v5.testId = `{testId}-invite-button`
	local v7 = createElement(item, v5)

	if isInviteDisabled then
		v7 = React.createElement("CanvasGroup", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			GroupTransparency = 0.5
		}, { Item = v7 })
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.layoutOrder,
			tag = "col gap-medium size-full-0 auto-y",
			testId = testId
		},
		{
			Header = React.createElement(
				view,
				{
					LayoutOrder = 1,
					tag = "row align-y-center gap-small size-full-0 auto-y"
				},
				{
					Title = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.title,
						tag = "fill auto-y text-title-large text-align-x-left content-default"
					}),
					Count = React.createElement(badge, {
						LayoutOrder = 2,
						text = props.countText,
						testId = `{testId}-count`
					})
				}
			),
			Body = React.createElement(text, {
				LayoutOrder = 2,
				Text = props.subtitle,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-muted"
			}),
			Table = React.createElement(PickedUserList, {
				layoutOrder = 4,
				userIds = props.userIds,
				onRemove = props.onRemove,
				removingUserIds = props.removingUserIds,
				header = v7,
				testId = `{testId}-list`
			})
		}
	)
end

return PrivateInvitesManagementView
