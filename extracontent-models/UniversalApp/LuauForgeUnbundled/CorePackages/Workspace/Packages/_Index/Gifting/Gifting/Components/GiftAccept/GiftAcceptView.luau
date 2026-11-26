local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local GiftSheetLayoutView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftSheetLayout/GiftSheetLayoutView")
local GiftStateView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/GiftState/GiftStateView")
local UserInfoPanelView = require("@game/CorePackages/Workspace/Packages/_Index/Gifting/Gifting/Components/UserInfoPanel/UserInfoPanelView")

local button = Foundation.Button
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant

local function GiftAcceptView(props)
	local v5

	if props.state then
		v5 = React.createElement(GiftStateView, props.state)
	else
		v5 = React.createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
			UserInfo = React.createElement(view, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 1
			}, {
				Panel = React.createElement(UserInfoPanelView, props.userInfoProps)
			}),
			GiftPresentation = React.createElement(
				view,
				{
					tag = "col size-full-0 auto-y",
					testId = "gift-accept-presentation",
					LayoutOrder = 2
				},
				props.giftPresentation
			)
		})
	end

	local v6

	if not props.state then
		v6 = React.createElement(view, { tag = "row gap-small size-full-0 auto-y" }, {
			Accept = React.createElement(button, {
				text = props.acceptLabel,
				variant = buttonVariant.Emphasis,
				width = UDim.new(0.5, -4),
				isLoading = props.isAcceptLoading,
				isDisabled = props.isAcceptDisabled,
				onActivated = props.onAccept,
				testId = "gift-accept-accept",
				LayoutOrder = 1
			}),
			Reject = React.createElement(button, {
				text = props.rejectLabel,
				variant = buttonVariant.Alert,
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
	local v8 = {
		isOpen = props.isOpen,
		titleText = props.titleText,
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

return React.memo(GiftAcceptView)
