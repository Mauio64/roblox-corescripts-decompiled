local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local parent = ProfileQRCode.Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize

local color = Color3.new(1, 1, 1)

local iconscommonrefresh = Images["icons/common/refresh"]
local iconsgraphicerror_xlarge = Images["icons/graphic/error_xlarge"]

return function(p)
	local v = useStyle()
	local v2 = useLocalization({ failedToLoadMessage = TextKeys.FailedToLoad })

	return React.createElement("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, {
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
					Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
					LayoutOrder = 1
				}, {
					FailedImage = React.createElement(ImageSetLabel, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = iconsgraphicerror_xlarge,
						Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
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
				FailedMessage = React.createElement(StyledTextLabel, {
					layoutOrder = 3,
					size = UDim2.new(1, 0, 0, 0),
					text = v2.failedToLoadMessage,
					fontStyle = v.Font.CaptionBody,
					colorStyle = v.Theme.TextMuted,
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
				RetryButton = React.createElement(Button, {
					buttonType = ButtonType.Secondary,
					standardSize = StandardButtonSize.Regular,
					layoutOrder = 5,
					icon = iconscommonrefresh,
					onActivated = p.onActivated
				})
			}
		)
	})
end
