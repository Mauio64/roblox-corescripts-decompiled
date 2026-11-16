local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/React")

local button = Foundation.Button
local text = Foundation.Text
local view = Foundation.View
local avatarSize = Foundation.Enums.AvatarSize
local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local getIconRichText = Foundation.Utility.getIconRichText
local useTokens = Foundation.Hooks.useTokens

local function PendingTransfersRow(props)
	local v5 = useTokens()
	local transferRequestId = props.transferRequestId
	local onAccept = props.onAccept

	local v6 = React.useCallback(function()
		onAccept(transferRequestId)
	end, { onAccept, transferRequestId })

	return React.createElement(view, {
		LayoutOrder = props.LayoutOrder,
		tag = "row flex-x-between align-y-center gap-medium size-full-0 auto-y padding-medium radius-medium",
		stroke = {
			Color = v5.Color.Stroke.Default.Color3,
			Transparency = v5.Color.Stroke.Default.Transparency,
			Thickness = v5.Stroke.Standard,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner
		},
		testId = `pending-transfers-row-{transferRequestId}`
	}, {
		Sender = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "row align-y-center fill gap-medium auto-y" },
			{
				Avatar = React.createElement(Foundation.Avatar, {
					LayoutOrder = 1,
					userId = props.senderUserId,
					size = avatarSize.Small,
					backgroundStyle = v5.Color.Surface.Surface_200
				}),
				Details = React.createElement(view, {
					LayoutOrder = 2,
					tag = "col fill auto-y"
				}, {
					Name = React.createElement(text, {
						LayoutOrder = 1,
						Text = props.senderDisplayName,
						tag = "size-full-0 auto-y text-label-medium text-align-x-left text-truncate-end content-emphasis"
					}),
					Date = React.createElement(text, {
						LayoutOrder = 2,
						Text = props.dateText,
						tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
					})
				})
			}
		),
		Action = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "row align-y-center gap-medium auto-xy" },
			{
				Amount = React.createElement(text, {
					LayoutOrder = 1,
					Text = `{getIconRichText(iconName.Robux)} {props.amountText}`,
					RichText = true,
					tag = "auto-xy text-label-medium content-emphasis"
				}),
				Accept = React.createElement(button, {
					LayoutOrder = 2,
					text = props.acceptText,
					variant = buttonVariant.Standard,
					size = inputSize.Small,
					onActivated = v6,
					testId = `pending-transfers-accept-{transferRequestId}`
				})
			}
		)
	})
end

return PendingTransfersRow
