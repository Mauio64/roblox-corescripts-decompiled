local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/UIBlox")

local useLocalization = Localization.Hooks.useLocalization

local modalWindow = UIBlox.App.Dialog.Modal.ModalWindow

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local button = Foundation.Button
local inputSize = Foundation.Enums.InputSize
local iconName = Foundation.Enums.IconName
local useTokens = Foundation.Hooks.useTokens

local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/RoactUtils").Hooks.RoactRodux.useSelector

return function(p2)
	local v5 = useTokens()

	local v6 = useLocalization({
		modalTitle = "Feature.Durables.InfoModal.Title",
		modalDescription = "Feature.Durables.InfoModal.Description",
		actionOK = "CommonUI.Messages.Action.OK"
	})

	local v7 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	return React.createElement(modalWindow, { screenSize = v7, isFullHeight = false }, {
		Body = React.createElement(
			view,
			{
				tag = "size-full-0 auto-y padding-large col gap-large",
				BackgroundTransparency = 1
			},
			{
				IconContainer = React.createElement(
					view,
					{
						tag = "size-full-0 auto-y align-x-center margin-top-medium margin-bottom-medium",
						LayoutOrder = 0
					},
					{
						InnerContainer = React.createElement(
							view,
							{
								tag = "size-2000-2000 auto-xy",
								BackgroundTransparency = 1
							},
							{
								RotatedSquare = React.createElement(view, {
									tag = "size-full radius-small stroke-default stroke-thicker",
									BackgroundTransparency = 1,
									Rotation = 25,
									Position = UDim2.fromScale(0.5, 0.5),
									AnchorPoint = Vector2.new(0.5, 0.5)
								}, {
									IconWrapper = React.createElement(
										view,
										{
											tag = "size-full",
											BackgroundTransparency = 1
										},
										{
											ClockIcon = React.createElement(icon, {
												name = iconName.Clock,
												Rotation = -25,
												Position = UDim2.fromScale(0.5, 0.5),
												AnchorPoint = Vector2.new(0.5, 0.5),
												size = v5.Size.Size_600
											})
										}
									)
								})
							}
						)
					}
				),
				Title = React.createElement(text, {
					tag = "size-full-0 auto-y text-align-x-left text-heading-medium",
					Text = v6.modalTitle,
					LayoutOrder = 1
				}),
				Description = React.createElement(text, {
					tag = "size-full-0 auto-y text-wrap text-truncate-none text-align-x-left text-body-medium",
					Text = v6.modalDescription,
					RichText = true,
					LayoutOrder = 2
				}),
				CloseButton = React.createElement(button, {
					LayoutOrder = 5,
					tag = "size-full-0 auto-y",
					text = v6.actionOK,
					size = inputSize.Medium,
					width = UDim.new(1, 0),
					onActivated = p2.onClose,
					testId = "theCloseButton"
				})
			}
		)
	})
end
