local parent = script:FindFirstAncestor("Gifting").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local GiftAllowanceView = require(script.Parent.Parent.GiftAllowance.GiftAllowanceView)
local GiftSheetLayoutView = require(script.Parent.Parent.GiftSheetLayout.GiftSheetLayoutView)
local GiftStateView = require(script.Parent.Parent.GiftState.GiftStateView)
local UserInfoPanelView = require(script.Parent.Parent.UserInfoPanel.UserInfoPanelView)

local Button = Foundation.Button
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant

local function GiftSendView(props)
	local allowance = props.allowance
	local savingsPresentation = props.savingsPresentation
	local content

	if props.state then
		content = React.createElement(GiftStateView, props.state)
	else
		local createElement = React.createElement
		local allowance2

		if allowance then
			allowance2 = React.createElement(View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Panel = React.createElement(GiftAllowanceView, allowance)
			})
		end

		local children = {
			Allowance = allowance2,
			UserInfo = React.createElement(View, { tag = "col size-full-0 auto-y", LayoutOrder = 2 }, {
				Panel = React.createElement(UserInfoPanelView, props.userInfoProps)
			}),
			GiftPresentation = React.createElement(
				View,
				{
					tag = "col size-full-0 auto-y",
					testId = "gift-send-presentation",
					LayoutOrder = 3
				},
				props.giftPresentation
			),
			Savings = 0
		}
		local savings

		if savingsPresentation then
			savings = React.createElement(
				View,
				{
					tag = "col size-full-0 auto-y padding-top-small",
					testId = "gift-send-savings",
					LayoutOrder = 4
				},
				savingsPresentation
			)
		end

		children.Savings = savings
		content = createElement(View, { tag = "col gap-medium size-full-0 auto-y" }, children)
	end

	local actions

	if not props.state then
		actions = React.createElement(Button, {
			text = props.buyLabel,
			variant = ButtonVariant.Emphasis,
			width = UDim.new(1, 0),
			isLoading = props.isBuyLoading,
			isDisabled = props.isBuyDisabled,
			onActivated = props.onBuy,
			testId = "gift-send-buy"
		})
	end

	local createElement = React.createElement
	local v = {
		isOpen = props.isOpen,
		titleText = props.titleText,
		onBack = props.onBack,
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

return React.memo(GiftSendView)
