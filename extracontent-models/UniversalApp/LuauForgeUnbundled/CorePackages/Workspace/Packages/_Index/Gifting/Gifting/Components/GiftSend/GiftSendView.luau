local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local GiftAllowanceView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftAllowance/GiftAllowanceView")
local GiftSheetLayoutView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftSheetLayout/GiftSheetLayoutView")
local GiftStateView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateView")
local UserInfoPanelView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/UserInfoPanel/UserInfoPanelView")

local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant

local function GiftSendView(props)
	local allowance = props.allowance
	local savingsPresentation = props.savingsPresentation
	local v5

	if props.state then
		v5 = React.createElement(GiftStateView, props.state)
	else
		local createElement = React.createElement

		local v8 = if allowance then React.createElement(
			view,
			{ tag = "col size-full-0 auto-y", LayoutOrder = 1 },
			{
				Panel = React.createElement(GiftAllowanceView, allowance)
			}
		) else nil
		local children = {
			Allowance = v8,
			UserInfo = React.createElement(view, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				Panel = React.createElement(UserInfoPanelView, props.userInfoProps)
			}),
			GiftPresentation = React.createElement(
				view,
				{
					tag = "col size-full-0 auto-y",
					testId = "gift-send-presentation",
					LayoutOrder = 3
				},
				props.giftPresentation
			),
			Savings = 0
		}

		local v9 = if savingsPresentation then React.createElement(
			view,
			{
				tag = "col size-full-0 auto-y padding-top-small",
				testId = "gift-send-savings",
				LayoutOrder = 4
			},
			savingsPresentation
		) else nil
		children.Savings = v9
		v5 = createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, children)
	end

	local v6

	if not props.state then
		v6 = React.createElement(button, {
			text = props.buyLabel,
			variant = buttonVariant.Emphasis,
			width = UDim.new(1, 0),
			isLoading = props.isBuyLoading,
			isDisabled = props.isBuyDisabled,
			onActivated = props.onBuy,
			testId = "gift-send-buy"
		})
	end

	local createElement = React.createElement
	local v8 = {
		isOpen = props.isOpen,
		titleText = props.titleText,
		onBack = props.onBack,
		content = v5,
		actions = v6,
		captionText = 0,
		onClose = 0
	}

	local v9 = if not props.state then props.disclaimerText else nil
	v8.captionText = v9
	v8.onClose = props.onClose
	return createElement(GiftSheetLayoutView, v8)
end

return React.memo(GiftSendView)
