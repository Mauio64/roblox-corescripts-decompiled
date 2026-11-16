local parent = script:FindFirstAncestor("AccountUpgrade").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Avatar = Foundation.Avatar
local Text = Foundation.Text
local View = Foundation.View
local AvatarSize = Foundation.Enums.AvatarSize

local function AccountUpgradeIdentityHeader(props)
	local text = props.displayName

	if text == nil or text == "" then
		text = props.username
	end

	return React.createElement(
		View,
		{
			tag = "col align-x-center gap-medium size-full-0 auto-y",
			LayoutOrder = props.LayoutOrder,
			testId = "account-upgrade-identity-header"
		},
		{
			Avatar = React.createElement(Avatar, {
				userId = props.userId,
				size = AvatarSize.Pictogram,
				LayoutOrder = 1,
				testId = "account-upgrade-identity-avatar"
			}),
			Credentials = React.createElement(
				View,
				{ tag = "col align-x-center gap-xsmall size-full-0 auto-y", LayoutOrder = 2 },
				{
					DisplayName = React.createElement(Text, {
						tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-center content-default",
						Text = text,
						LayoutOrder = 1,
						testId = "account-upgrade-display-name"
					}),
					Username = React.createElement(Text, {
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
