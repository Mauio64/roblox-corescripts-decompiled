local module = require("@luauforge/bundled/hHr")
local module2 = require("@luauforge/bundled/hHu")

local button = module.Button
local text = module.Text
local view = module.View
local avatarSize = module.Enums.AvatarSize
local buttonVariant = module.Enums.ButtonVariant
local iconName = module.Enums.IconName
local inputSize = module.Enums.InputSize
local getIconRichText = module.Utility.getIconRichText
local useTokens = module.Hooks.useTokens

local function PendingTransfersRow(props)
	local v5 = useTokens()
	local transferRequestId = props.transferRequestId
	local onAccept = props.onAccept

	local v6 = module2.useCallback(function()
		onAccept(transferRequestId)
	end, { onAccept, transferRequestId })

	return module2.createElement(view, {
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
		Sender = module2.createElement(
			view,
			{ LayoutOrder = 1, tag = "row align-y-center fill gap-medium auto-y" },
			{
				Avatar = module2.createElement(module.Avatar, {
					LayoutOrder = 1,
					userId = props.senderUserId,
					size = avatarSize.Small,
					backgroundStyle = v5.Color.Surface.Surface_200
				}),
				Details = module2.createElement(view, {
					LayoutOrder = 2,
					tag = "col fill auto-y"
				}, {
					Name = module2.createElement(text, {
						LayoutOrder = 1,
						Text = props.senderDisplayName,
						tag = "size-full-0 auto-y text-label-medium text-align-x-left text-truncate-end content-emphasis"
					}),
					Date = module2.createElement(text, {
						LayoutOrder = 2,
						Text = props.dateText,
						tag = "size-full-0 auto-y text-body-small text-align-x-left content-muted"
					})
				})
			}
		),
		Action = module2.createElement(
			view,
			{ LayoutOrder = 2, tag = "row align-y-center gap-medium auto-xy" },
			{
				Amount = module2.createElement(text, {
					LayoutOrder = 1,
					Text = `{getIconRichText(iconName.Robux)} {props.amountText}`,
					RichText = true,
					tag = "auto-xy text-label-medium content-emphasis"
				}),
				Accept = module2.createElement(button, {
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
