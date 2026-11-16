local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local GiftSheetLayoutView = require(script.Parent.Parent.GiftSheetLayout.GiftSheetLayoutView)
local GiftStateView = require(script.Parent.Parent.GiftState.GiftStateView)
local UserInfoPanelView = require(script.Parent.Parent.UserInfoPanel.UserInfoPanelView)

local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant

local function GiftAcceptView(props)
	local content

	if props.state then
		content = React.createElement(GiftStateView, props.state)
	else
		content = React.createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, {
			UserInfo = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 1 }, {
				Panel = React.createElement(UserInfoPanelView, props.userInfoProps)
			}),
			GiftPresentation = React.createElement(
				View,
				{
					tag = "col size-full-0 auto-y",
					testId = "gift-accept-presentation",
					LayoutOrder = 2
				},
				props.giftPresentation
			)
		})
	end

	local actions

	if not props.state then
		actions = React.createElement(View, { tag = "row gap-small size-full-0 auto-y" }, {
			Accept = React.createElement(Button, {
				text = props.acceptLabel,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(0.5, -4),
				isLoading = props.isAcceptLoading,
				isDisabled = props.isAcceptDisabled,
				onActivated = props.onAccept,
				testId = "gift-accept-accept",
				LayoutOrder = 1
			}),
			Reject = React.createElement(Button, {
				text = props.rejectLabel,
				variant = ButtonVariant.Alert,
				width = UDim.new(0.5, -4),
				isLoading = props.isRejectLoading,
				isDisabled = props.isRejectDisabled,
				onActivated = props.onReject,
				testId = "gift-accept-reject",
				LayoutOrder = 2
			})
		})
	end

	local createElement = React.createElement
	local v = {
		isOpen = props.isOpen,
		titleText = props.titleText,
		content = content,
		actions = actions,
		captionText = 0,
		onClose = 0
	}
	local captionText

	if not props.state then
		captionText = props.disclaimerText
	end

	v.captionText = captionText
	v.onClose = props.onClose
	return createElement(GiftSheetLayoutView, v)
end

return React.memo(GiftAcceptView)
