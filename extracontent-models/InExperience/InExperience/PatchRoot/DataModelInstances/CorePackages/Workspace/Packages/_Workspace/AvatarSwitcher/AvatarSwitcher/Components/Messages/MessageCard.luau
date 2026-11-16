local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherUiFixes = AvatarExperienceFlags.FFlagAvatarSwitcherUiFixes

local function MessageCard(props)
	local size_800 = useTokens().Size.Size_800

	return React.createElement(
		Foundation.View,
		{
			tag = "col gap-medium stroke-default bg-shift-100 radius-medium padding-large",
			Size = props.Size,
			AutomaticSize = props.AutomaticSize
		},
		{
			Header = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y row align-y-center gap-small"
			}, {
				Image = React.createElement(Foundation.Image, {
					tag = props.icon == "Info" and "" or "content-system-warning",
					Image = props.icon == "Info" and "icons/actions/info" or "icons/status/alert",
					Size = UDim2.fromOffset(size_800, size_800),
					LayoutOrder = 1
				}),
				HeaderText = React.createElement(Foundation.Text, {
					tag = "auto-y text-align-x-left anchor-center-right text-title-medium text-wrap grow",
					Text = props.headerText,
					LayoutOrder = 2
				}),
				CloseButton = props.onClose and React.createElement(Foundation.Image, {
					tag = "size-600 radius-small",
					Image = "icons/navigation/close",
					onActivated = props.onClose,
					LayoutOrder = 3
				})
			}),
			ContentText = (not FFlagAvatarSwitcherUiFixes or props.contentText) and React.createElement(Foundation.Text, {
				tag = " size-full-0 auto-y text-align-x-left text-body-medium text-wrap",
				Text = props.contentText
			})
		}
	)
end

return MessageCard
