local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Gifting/Foundation")

local sheet = Foundation.Sheet
local buttonVariant = Foundation.Enums.ButtonVariant
local dialogSize = Foundation.Enums.DialogSize
local fillBehavior = Foundation.Enums.FillBehavior
local iconName = Foundation.Enums.IconName
local getIconRichText = Foundation.Utility.getIconRichText

local udim = UDim2.fromScale(0.375, 5 / 9)
local udim2 = UDim2.fromScale(0.671875, 4 / 9)

local function PictogramCard(props)
	return React.createElement(Foundation.View, {
		tag = "align-x-center align-y-center anchor-center-center size-2500-2500 stroke-emphasis radius-medium bg-surface-100",
		Position = props.position,
		Rotation = props.rotation,
		ZIndex = props.zIndex,
		testId = props.testId
	}, {
		Icon = React.createElement(Foundation.Text, {
			Text = getIconRichText(props.icon),
			tag = "position-center-center anchor-center-center size-1800-1800 text-display-medium text-align-x-center content-emphasis",
			RichText = true
		})
	})
end

local function GiftAgeCheckView(props)
	return React.createElement(sheet.Root, {
		isOpen = props.isOpen,
		preferCenterSheet = true,
		size = dialogSize.Medium,
		snapPoints = { props.mobileSnapPoint },
		onClose = props.onClose,
		testId = "GiftAgeCheckView"
	}, {
		Content = React.createElement(
			sheet.Content,
			{ testId = "gift-age-check-content", LayoutOrder = 1 },
			{
				Body = React.createElement(
					Foundation.View,
					{ tag = "col align-x-center gap-small size-full-0 auto-y" },
					{
						Pictogram = React.createElement(
							Foundation.View,
							{ Size = props.pictogramSize, LayoutOrder = 1 },
							{
								ShieldCard = React.createElement(PictogramCard, {
									icon = iconName.ShieldCheck,
									rotation = -15,
									position = udim,
									zIndex = 1,
									testId = "gift-age-check-shield"
								}),
								GiftCard = React.createElement(PictogramCard, {
									icon = iconName.GiftBox,
									rotation = 15,
									position = udim2,
									zIndex = 2,
									testId = "gift-age-check-gift"
								})
							}
						),
						Title = React.createElement(Foundation.Text, {
							tag = "size-full-0 auto-y text-heading-small text-wrap text-align-x-left content-emphasis",
							Text = props.titleText,
							testId = "gift-age-check-title",
							LayoutOrder = 2
						}),
						Description = React.createElement(Foundation.Text, {
							tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
							Text = props.descriptionText,
							testId = "gift-age-check-description",
							LayoutOrder = 3
						})
					}
				)
			}
		),
		Actions = React.createElement(sheet.Actions, { LayoutOrder = 2 }, {
			ContinueButton = React.createElement(Foundation.Button, {
				text = props.continueLabel,
				variant = buttonVariant.Emphasis,
				fillBehavior = fillBehavior.Fill,
				onActivated = props.onContinue,
				testId = "gift-age-check-continue"
			})
		})
	})
end

return React.memo(GiftAgeCheckView)
