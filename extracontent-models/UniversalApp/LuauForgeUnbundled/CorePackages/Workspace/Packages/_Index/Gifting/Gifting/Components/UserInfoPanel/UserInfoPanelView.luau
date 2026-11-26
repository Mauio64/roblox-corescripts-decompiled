local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local avatar = Foundation.Avatar
local icon = Foundation.Icon
local text = Foundation.Text
local view = Foundation.View
local avatarSize = Foundation.Enums.AvatarSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local iconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function renderDetail(p2, p3, default, p4, p5)
	return React.createElement(
		view,
		{ tag = "row align-y-center gap-xsmall auto-xy", testId = p4, LayoutOrder = p5 },
		{
			Icon = React.createElement(icon, {
				name = p3,
				variant = iconVariant.Filled,
				size = iconSize.XSmall,
				style = default,
				testId = `{p4}-icon`,
				LayoutOrder = 1
			}),
			Label = React.createElement(text, {
				tag = "auto-xy text-body-medium content-default text-no-wrap",
				Text = p2,
				LayoutOrder = 2
			})
		}
	)
end

local function UserInfoPanelView(props)
	local v5 = useTokens()
	local userId = tonumber(props.userId)
	local v6 = props.friendDurationText ~= nil or props.mutualFriendsText ~= nil or props.joinedText ~= nil

	local createElement = React.createElement
	local v8 = {
		tag = "col align-x-center gap-large size-full-0 auto-y padding-large radius-large bg-shift-100",
		testId = "UserInfoPanelView",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement

	local v13 = if userId then React.createElement(avatar, {
		userId = userId,
		size = avatarSize.Large,
		backgroundStyle = v5.Color.Shift.Shift_300,
		LayoutOrder = 1
	}) else nil

	local createElement3 = React.createElement

	local v16 = {
		DisplayName = React.createElement(text, {
			tag = "size-full-0 auto-y text-title-medium text-align-x-center content-emphasis",
			Text = props.displayName,
			testId = "user-info-panel-display-name",
			LayoutOrder = 1
		}),
		Username = 0
	}

	local v17 = if props.username then React.createElement(text, {
		tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
		Text = `@{props.username}`,
		testId = "user-info-panel-username",
		LayoutOrder = 2
	}) else nil
	v16.Username = v17
	local v9 = {
		Identity = createElement2(
			view,
			{ tag = "col align-x-center gap-small size-full-0 auto-y", LayoutOrder = 1 },
			{
				Avatar = v13,
				Names = createElement3(
					view,
					{ tag = "col align-x-center size-full-0 auto-y", LayoutOrder = 2 },
					v16
				)
			}
		),
		Details = 0
	}
	local v18

	if v6 then
		local createElement4 = React.createElement

		local v22 = if props.friendDurationText then renderDetail(
			props.friendDurationText,
			iconName.Calendar,
			v5.Color.Content.Default,
			"user-info-panel-friend-duration",
			1
		) else nil

		local v23 = if props.mutualFriendsText then renderDetail(
			props.mutualFriendsText,
			iconName.TwoPeople,
			v5.Color.Content.Default,
			"user-info-panel-mutual-friends",
			2
		) else nil

		local v24 = if props.joinedText then renderDetail(
			props.joinedText,
			iconName.CircleI,
			v5.Color.Content.Default,
			"user-info-panel-joined",
			3
		) else nil
		v18 = createElement4(
			view,
			{
				tag = "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y",
				testId = "user-info-panel-details",
				LayoutOrder = 2
			},
			{ FriendDuration = v22, MutualFriends = v23, Joined = v24 }
		)
	end

	v9.Details = v18
	return createElement(view, v8, v9)
end

return React.memo(UserInfoPanelView)
