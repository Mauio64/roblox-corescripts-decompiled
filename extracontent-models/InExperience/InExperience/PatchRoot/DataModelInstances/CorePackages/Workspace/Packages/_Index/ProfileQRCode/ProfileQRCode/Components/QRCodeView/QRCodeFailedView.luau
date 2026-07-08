local ProfileQRCode = script:FindFirstAncestor("ProfileQRCode")
local ProfileQRCodeParent = ProfileQRCode.Parent
local React = require(ProfileQRCodeParent.React)
local UIBlox = require(ProfileQRCodeParent.UIBlox)
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local useStyle = UIBlox.Core.Style.useStyle
local TextKeys = require(ProfileQRCode.Common.TextKeys)
local useLocalization = require(ProfileQRCodeParent.Localization).Hooks.useLocalization
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local color3 = Color3.new(1, 1, 1)
local v16 = Images["icons/common/refresh"]
local v17 = Images["icons/graphic/error_xlarge"]

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useStyle (copy), useLocalization (copy), TextKeys (copy), React (copy), color3 (copy), IconSize (copy), ImageSetLabel (copy), v17 (copy), StyledTextLabel (copy), Button (copy), ButtonType (copy), StandardButtonSize (copy), v16 (copy)
	local v19 = useStyle()
	local v20 = useLocalization({
		failedToLoadMessage = TextKeys.FailedToLoad
	})

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
		Wrapper = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			ImageWrapper = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				BackgroundColor3 = color3,
				Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge)
			}, {
				FailedImage = React.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = v17,
					Size = UDim2.fromOffset(IconSize.XLarge, IconSize.XLarge),
					Position = UDim2.fromScale(0.5, 0.5)
				})
			}),
			Spacer1 = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(0, 0, 0, 12)
			}),
			FailedMessage = React.createElement(StyledTextLabel, {
				layoutOrder = 3,
				fluidSizing = false,
				richText = false,
				size = UDim2.new(1, 0, 0, 0),
				text = v20.failedToLoadMessage,
				fontStyle = v19.Font.CaptionBody,
				colorStyle = v19.Theme.TextMuted,
				automaticSize = Enum.AutomaticSize.Y,
				textTruncate = Enum.TextTruncate.AtEnd,
				textXAlignment = Enum.TextXAlignment.Center,
				textYAlignment = Enum.TextYAlignment.Center
			}),
			Spacer2 = React.createElement("Frame", {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 4,
				Size = UDim2.new(0, 0, 0, 20)
			}),
			RetryButton = React.createElement(Button, {
				layoutOrder = 5,
				buttonType = ButtonType.Secondary,
				standardSize = StandardButtonSize.Regular,
				icon = v16,
				onActivated = t1.onActivated
			})
		})
	})
end
