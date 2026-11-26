local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization

local module = require("@luauforge/bundled/gxM")

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle

local iconscommonrobux = images["icons/common/robux"]

local function SellItemInfo(p2)
	local v5 = module({
		itemInfoLabel = "Feature.Catalog.Heading.ItemInfo",
		serialNumberLabel = "Feature.Catalog.Label.SerialNumberColon",
		averagePriceLabel = "Feature.Catalog.Label.AveragePriceColon"
	})

	local v6 = useStyle()

	local averagePrice = p2.itemIdPriceSerialNumber.averagePrice

	local theme = v6.Theme
	local font = v6.Font
	local subHeader1 = font.SubHeader1
	local body = font.Body
	local relativeSize = subHeader1.RelativeSize
	local relativeSize2 = body.RelativeSize
	local baseSize = font.BaseSize

	local v7 = relativeSize * baseSize
	local v8 = relativeSize2 * baseSize

	local v9 = averagePrice
		and numberLocalization.localize(averagePrice, LocalizationService.RobloxLocaleId)
		or ""
	local serialNumber

	if p2.itemIdPriceSerialNumber.serialNumber then
		serialNumber = p2.itemIdPriceSerialNumber.serialNumber
	end

	return React.createElement(
		"Frame",
		{
			LayoutOrder = p2.layoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1
		},
		{
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			ItemInfoSubHeader = React.createElement("TextLabel", {
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Text = v5.itemInfoLabel,
				FontFace = normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font),
				Size = UDim2.fromScale(1, 0),
				TextSize = v7,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				TextWrapped = true,
				BackgroundTransparency = 1
			}),
			SerialNumberContainer = serialNumber and React.createElement(
				"Frame",
				{
					LayoutOrder = 2,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					SerialNumberLabel = React.createElement("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v5.serialNumberLabel,
						FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					SerialNumberText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = serialNumber,
						FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					})
				}
			),
			AveragePriceContainer = React.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				{
					UIListLayout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, 10)
					}),
					AveragePriceLabel = React.createElement("TextLabel", {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = v5.averagePriceLabel,
						FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
						TextSize = v8,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						TextWrapped = true,
						BackgroundTransparency = 1
					}),
					AveragePriceTextContainer = React.createElement(
						"Frame",
						{
							LayoutOrder = 2,
							AutomaticSize = Enum.AutomaticSize.XY,
							BackgroundTransparency = 1
						},
						{
							UIListLayout = React.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 4)
							}),
							AveragePriceRobuxImage = React.createElement(imageSetLabel, {
								LayoutOrder = 1,
								Image = iconscommonrobux,
								Size = UDim2.fromOffset(v8, v8),
								ImageColor3 = theme.TextDefault.Color,
								ImageTransparency = theme.TextDefault.Transparency,
								BackgroundTransparency = 1
							}),
							AveragePriceText = React.createElement("TextLabel", {
								LayoutOrder = 2,
								AutomaticSize = Enum.AutomaticSize.XY,
								Text = v9,
								FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
								TextSize = v8,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextColor3 = theme.TextDefault.Color,
								TextTransparency = theme.TextDefault.Transparency,
								TextWrapped = true,
								BackgroundTransparency = 1
							})
						}
					)
				}
			)
		}
	)
end

return SellItemInfo
