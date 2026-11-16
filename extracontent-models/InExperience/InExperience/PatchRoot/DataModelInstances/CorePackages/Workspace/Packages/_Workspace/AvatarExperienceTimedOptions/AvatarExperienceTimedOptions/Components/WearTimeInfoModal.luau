local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local UIBlox = require(parent.UIBlox)

local useLocalization = Localization.Hooks.useLocalization

local ModalWindow = UIBlox.App.Dialog.Modal.ModalWindow

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Button = Foundation.Button
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function(p)
	local v = useTokens()

	local v2 = useLocalization({
		modalTitle = "Feature.Durables.InfoModal.Title",
		modalDescription = "Feature.Durables.InfoModal.Description",
		actionOK = "CommonUI.Messages.Action.OK"
	})

	local screenSize = useSelector(function(p2)
		return p2.ScreenSize
	end)

	return React.createElement(ModalWindow, { screenSize = screenSize, isFullHeight = false }, {
		Body = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-large col gap-large", BackgroundTransparency = 1 },
			{
				IconContainer = React.createElement(
					View,
					{
						tag = "size-full-0 auto-y align-x-center margin-top-medium margin-bottom-medium",
						LayoutOrder = 0
					},
					{
						InnerContainer = React.createElement(
							View,
							{ tag = "size-2000-2000 auto-xy", BackgroundTransparency = 1 },
							{
								RotatedSquare = React.createElement(View, {
									tag = "size-full radius-small stroke-default stroke-thicker",
									BackgroundTransparency = 1,
									Rotation = 25,
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5)
								}, {
									IconWrapper = React.createElement(
										View,
										{ tag = "size-full", BackgroundTransparency = 1 },
										{
											ClockIcon = React.createElement(Icon, {
												name = IconName.Clock,
												Rotation = -25,
												Position = UDim2.fromScale(0.5, 0.5),
												AnchorPoint = Vector2.new(0.5, 0.5),
												size = v.Size.Size_600
											})
										}
									)
								})
							}
						)
					}
				),
				Title = React.createElement(Text, {
					tag = "size-full-0 auto-y text-align-x-left text-heading-medium",
					Text = v2.modalTitle,
					LayoutOrder = 1
				}),
				Description = React.createElement(Text, {
					tag = "size-full-0 auto-y text-wrap text-truncate-none text-align-x-left text-body-medium",
					Text = v2.modalDescription,
					RichText = true,
					LayoutOrder = 2
				}),
				CloseButton = React.createElement(Button, {
					LayoutOrder = 5,
					tag = "size-full-0 auto-y",
					text = v2.actionOK,
					size = InputSize.Medium,
					width = UDim.new(1, 0),
					onActivated = p.onClose,
					testId = "theCloseButton"
				})
			}
		)
	})
end
