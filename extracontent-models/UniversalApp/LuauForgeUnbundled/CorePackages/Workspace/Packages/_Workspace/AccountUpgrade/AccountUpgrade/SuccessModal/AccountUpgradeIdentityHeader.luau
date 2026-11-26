local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local avatar = Foundation.Avatar
local text = Foundation.Text
local view = Foundation.View
local avatarSize = Foundation.Enums.AvatarSize

local function AccountUpgradeIdentityHeader(props)
	local v5 = props.displayName

	if v5 == nil or v5 == "" then
		v5 = props.username
	end

	return React.createElement(
		view,
		{
			tag = "col align-x-center gap-medium size-full-0 auto-y",
			LayoutOrder = props.LayoutOrder,
			testId = "account-upgrade-identity-header"
		},
		{
			Avatar = React.createElement(avatar, {
				userId = props.userId,
				size = avatarSize.Pictogram,
				LayoutOrder = 1,
				testId = "account-upgrade-identity-avatar"
			}),
			Credentials = React.createElement(
				view,
				{
					tag = "col align-x-center gap-xsmall size-full-0 auto-y",
					LayoutOrder = 2
				},
				{
					DisplayName = React.createElement(text, {
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-default",
						Text = v5,
						LayoutOrder = 1,
						testId = "account-upgrade-display-name"
					}),
					Username = React.createElement(text, {
						tag = "size-full-0 auto-y text-label-medium text-wrap text-align-x-center content-muted",
						Text = `@{props.username}`,
						LayoutOrder = 2,
						testId = "account-upgrade-username"
					})
				}
			)
		}
	)
end

return AccountUpgradeIdentityHeader
