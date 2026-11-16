local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Avatar = Foundation.Avatar
local Icon = Foundation.Icon
local Text = Foundation.Text
local View = Foundation.View
local AvatarSize = Foundation.Enums.AvatarSize
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local useTokens = Foundation.Hooks.useTokens

local function renderDetail(text: string, name: string, default, testId: string, layoutOrder: number)
	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-xsmall auto-xy",
			testId = testId,
			LayoutOrder = layoutOrder
		},
		{
			Icon = React.createElement(Icon, {
				name = name,
				variant = IconVariant.Filled,
				size = IconSize.XSmall,
				style = default,
				testId = `{testId}-icon`,
				LayoutOrder = 1
			}),
			Label = React.createElement(Text, {
				tag = "auto-xy text-body-medium content-default text-no-wrap",
				Text = text,
				LayoutOrder = 2
			})
		}
	)
end

local function UserInfoPanelView(props)
	local v = useTokens()
	local userId = tonumber(props.userId)
	local v2 = props.friendDurationText ~= nil or props.mutualFriendsText ~= nil or props.joinedText ~= nil

	local createElement = React.createElement
	local v3 = {
		tag = "col align-x-center gap-large size-full-0 auto-y padding-large radius-large bg-shift-100",
		testId = "UserInfoPanelView",
		LayoutOrder = props.LayoutOrder
	}

	local createElement2 = React.createElement
	local avatar

	if userId then
		avatar = React.createElement(Avatar, {
			userId = userId,
			size = AvatarSize.Large,
			backgroundStyle = v.Color.Shift.Shift_300,
			LayoutOrder = 1
		})
	end

	local createElement3 = React.createElement

	local v5 = {
		DisplayName = React.createElement(Text, {
			tag = "size-full-0 auto-y text-title-medium text-align-x-center content-emphasis",
			Text = props.displayName,
			testId = "user-info-panel-display-name",
			LayoutOrder = 1
		}),
		Username = 0
	}
	local username

	if props.username then
		username = React.createElement(Text, {
			tag = "size-full-0 auto-y text-body-small text-align-x-center content-default",
			Text = `@{props.username}`,
			testId = "user-info-panel-username",
			LayoutOrder = 2
		})
	end

	v5.Username = username
	local v4 = {
		Identity = createElement2(View, {
			tag = "col align-x-center gap-small size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Avatar = avatar,
			Names = createElement3(View, {
				tag = "col align-x-center size-full-0 auto-y",
				LayoutOrder = 2
			}, v5)
		}),
		Details = 0
	}
	local details

	if v2 then
		local createElement4 = React.createElement
		local friendDuration

		if props.friendDurationText then
			friendDuration = renderDetail(
				props.friendDurationText,
				IconName.Calendar,
				v.Color.Content.Default,
				"user-info-panel-friend-duration",
				1
			)
		end

		local mutualFriends

		if props.mutualFriendsText then
			mutualFriends = renderDetail(
				props.mutualFriendsText,
				IconName.TwoPeople,
				v.Color.Content.Default,
				"user-info-panel-mutual-friends",
				2
			)
		end

		local joined

		if props.joinedText then
			joined = renderDetail(
				props.joinedText,
				IconName.CircleI,
				v.Color.Content.Default,
				"user-info-panel-joined",
				3
			)
		end

		details = createElement4(
			View,
			{
				tag = "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y",
				testId = "user-info-panel-details",
				LayoutOrder = 2
			},
			{ FriendDuration = friendDuration, MutualFriends = mutualFriends, Joined = joined }
		)
	end

	v4.Details = details
	return createElement(View, v3, v4)
end

return React.memo(UserInfoPanelView)
