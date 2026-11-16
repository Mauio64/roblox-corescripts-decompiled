local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local numberLocalization = require("@game/CorePackages/Workspace/Packages/Localization").NumberLocalization

local module = require("@luauforge/bundled/fTi")

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
	local v10

	if p2.itemIdPriceSerialNumber.serialNumber then
		v10 = p2.itemIdPriceSerialNumber.serialNumber
	end

	local createElement = React.createElement
	local v12 = {
		LayoutOrder = p2.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1
	}

	local children = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		ItemInfoSubHeader = 0,
		SerialNumberContainer = 0,
		AveragePriceContainer = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = v5.itemInfoLabel,
		Font = 0,
		FontFace = 0,
		Size = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local v15 = if not foundationFontFaceMigration then subHeader1.Font else nil
	v14.Font = v15

	local v16 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.TitleLarge.Font) else nil
	v14.FontFace = v16

	v14.Size = UDim2.fromScale(1, 0)
	v14.TextSize = v7
	v14.TextXAlignment = Enum.TextXAlignment.Left
	v14.TextColor3 = theme.TextEmphasis.Color
	v14.TextTransparency = theme.TextEmphasis.Transparency
	children.ItemInfoSubHeader = createElement2("TextLabel", v14)

	if v10 then
		local createElement3 = React.createElement
		local v18 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1
		}

		local children2 = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10)
			}),
			SerialNumberLabel = 0,
			SerialNumberText = 0
		}

		local createElement4 = React.createElement
		local v20 = {
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v5.serialNumberLabel,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1
		}
		local v21 = if not foundationFontFaceMigration then body.Font else nil
		v20.Font = v21

		local v22 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v20.FontFace = v22

		v20.TextSize = v8
		v20.TextXAlignment = Enum.TextXAlignment.Left
		v20.TextColor3 = theme.TextDefault.Color
		v20.TextTransparency = theme.TextDefault.Transparency
		children2.SerialNumberLabel = createElement4("TextLabel", v20)

		local createElement5 = React.createElement
		local v24 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = v10,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextWrapped = true,
			BackgroundTransparency = 1
		}

		local v25 = if not foundationFontFaceMigration then body.Font else nil
		v24.Font = v25

		local v26 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
		v24.FontFace = v26

		v24.TextSize = v8
		v24.TextXAlignment = Enum.TextXAlignment.Left
		v24.TextColor3 = theme.TextDefault.Color
		v24.TextTransparency = theme.TextDefault.Transparency
		children2.SerialNumberText = createElement5("TextLabel", v24)
		v10 = createElement3("Frame", v18, children2)
	end

	children.SerialNumberContainer = v10

	local createElement3 = React.createElement
	local v18 = {
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}

	local children2 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 10)
		}),
		AveragePriceLabel = 0,
		AveragePriceTextContainer = 0
	}

	local createElement4 = React.createElement
	local v20 = {
		LayoutOrder = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v5.averagePriceLabel,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}
	local v21 = if not foundationFontFaceMigration then body.Font else nil
	v20.Font = v21

	local v22 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v20.FontFace = v22

	v20.TextSize = v8
	v20.TextXAlignment = Enum.TextXAlignment.Left
	v20.TextColor3 = theme.TextDefault.Color
	v20.TextTransparency = theme.TextDefault.Transparency
	children2.AveragePriceLabel = createElement4("TextLabel", v20)

	local createElement5 = React.createElement
	local v24 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1
	}

	local v25 = {
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
		AveragePriceText = 0
	}

	local createElement6 = React.createElement
	local v27 = {
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = v9,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		BackgroundTransparency = 1
	}

	local v28 = if not foundationFontFaceMigration then body.Font else nil
	v27.Font = v28

	local v29 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v27.FontFace = v29

	v27.TextSize = v8
	v27.TextXAlignment = Enum.TextXAlignment.Left
	v27.TextColor3 = theme.TextDefault.Color
	v27.TextTransparency = theme.TextDefault.Transparency
	v25.AveragePriceText = createElement6("TextLabel", v27)
	children2.AveragePriceTextContainer = createElement5("Frame", v24, v25)
	children.AveragePriceContainer = createElement3("Frame", v18, children2)
	return createElement("Frame", v12, children)
end

return SellItemInfo
