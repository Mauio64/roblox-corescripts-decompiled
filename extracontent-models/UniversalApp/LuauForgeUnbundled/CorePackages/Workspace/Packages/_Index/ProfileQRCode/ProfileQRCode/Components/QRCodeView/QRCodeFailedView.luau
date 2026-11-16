local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/UIBlox")
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ProfileQRCode/ProfileQRCode/Common/TextKeys")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileQRCode/Localization").Hooks.useLocalization

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local iconSize = UIBlox.App.Constant.IconSize

local color = Color3.new(1, 1, 1)

local iconscommonrefresh = images["icons/common/refresh"]
local iconsgraphicerror_xlarge = images["icons/graphic/error_xlarge"]

return function(p2)
	local v5 = useStyle()
	local v6 = useLocalization({ failedToLoadMessage = TextKeys.FailedToLoad })

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0)
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Wrapper = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				ImageWrapper = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundColor3 = color,
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
					LayoutOrder = 1
				}, {
					FailedImage = React.createElement(imageSetLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = iconsgraphicerror_xlarge,
						Size = UDim2.fromOffset(iconSize.XLarge, iconSize.XLarge),
						Position = UDim2.fromScale(0.5, 0.5),
						LayoutOrder = 1
					})
				}),
				Spacer1 = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 12),
					LayoutOrder = 2
				}),
				FailedMessage = React.createElement(styledTextLabel, {
					layoutOrder = 3,
					size = UDim2.new(1, 0, 0, 0),
					text = v6.failedToLoadMessage,
					fontStyle = v5.Font.CaptionBody,
					colorStyle = v5.Theme.TextMuted,
					automaticSize = Enum.AutomaticSize.Y,
					textTruncate = Enum.TextTruncate.AtEnd,
					textXAlignment = Enum.TextXAlignment.Center,
					textYAlignment = Enum.TextYAlignment.Center,
					fluidSizing = false,
					richText = false
				}),
				Spacer2 = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 0, 20),
					LayoutOrder = 4
				}),
				RetryButton = React.createElement(button, {
					buttonType = buttonType.Secondary,
					standardSize = standardButtonSize.Regular,
					layoutOrder = 5,
					icon = iconscommonrefresh,
					onActivated = p2.onActivated
				})
			}
		)
	})
end
