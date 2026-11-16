local CorePackages = game:GetService("CorePackages")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local UIBlox = require(CorePackages.Packages.UIBlox)

local useStyle = UIBlox.Core.Style.useStyle
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsstatusalert = images["icons/status/alert"]

local function mapTokens(data)
	return {
		alertHeight = data.Size.Size_2600,
		alertPadding = data.Size.Size_300,
		alertImageSize = data.Size.Size_900,
		cornerRadius = data.Radius.Medium,
		backgroundColor = data.Color.Surface.Surface_300,
		alertTitleColor = data.Color.Content.Muted,
		alertMessageColor = data.Color.Content.Default,
		alertTitleFont = data.Typography.TitleLarge,
		alertMessageFont = data.Typography.BodyLarge
	}
end

local function WidgetListModerationAlert(p2)
	local v5 = useDesignTokens(mapTokens)
	local v6 = useStyle()
	local v7 = useLocalization({
		alertTitle = "Feature.Avatar.Label.ModerationFailed",
		alertMessage = "Feature.Avatar.Message.ModerationFailed"
	})

	local theme = v6.Theme

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = v5.backgroundColor.Transparency,
		BackgroundColor3 = v5.backgroundColor.Color3,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v10 = {
		UICornoer = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v5.cornerRadius)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.alertPadding),
			PaddingBottom = UDim.new(0, v5.alertPadding),
			PaddingLeft = UDim.new(0, v5.alertPadding),
			PaddingRight = UDim.new(0, v5.alertPadding)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		LeftContent = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(0, v5.alertImageSize, 1, 0),
				LayoutOrder = 1
			},
			{
				AlertImage = React.createElement(imageSetLabel, {
					BackgroundTransparency = 1,
					Image = iconsstatusalert,
					Size = UDim2.new(0, v5.alertImageSize, 0, v5.alertImageSize),
					ImageColor3 = theme.IconDefault.Color,
					ImageTransparency = theme.IconDefault.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})
			}
		),
		RightContent = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = UDim2.new(1, -1 * v5.alertImageSize, 1, 0),
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local children = {
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v5.alertPadding),
			PaddingBottom = UDim.new(0, v5.alertPadding),
			PaddingLeft = UDim.new(0, v5.alertPadding),
			PaddingRight = UDim.new(0, v5.alertPadding)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.alertPadding)
		}),
		AlertTitle = 0,
		AlertMessage = 0
	}

	local createElement3 = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 0, 0),
		Text = v7.alertTitle,
		TextSize = v5.alertTitleFont.FontSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextWrapped = true,
		AutomaticSize = 0,
		TextXAlignment = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local v15 = if not foundationFontFaceMigration then v5.alertTitleFont.Font else nil
	v14.Font = v15

	local v16 = if foundationFontFaceMigration then normalizeFontFace(v5.alertTitleFont.Font) else nil
	v14.FontFace = v16

	v14.TextColor3 = v5.alertTitleColor.Color3

	v14.AutomaticSize = Enum.AutomaticSize.Y
	v14.TextXAlignment = Enum.TextXAlignment.Left
	children.AlertTitle = createElement3("TextLabel", v14)

	local createElement4 = React.createElement
	local v18 = {
		Size = UDim2.new(1, 0, 0, 0),
		Text = v7.alertMessage,
		TextSize = v5.alertMessageFont.FontSize,
		Font = 0,
		FontFace = 0,
		TextColor3 = 0,
		TextWrapped = true,
		AutomaticSize = 0,
		TextXAlignment = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}
	local v19 = if not foundationFontFaceMigration then v5.alertMessageFont.Font else nil
	v18.Font = v19

	local v20 = if foundationFontFaceMigration then normalizeFontFace(v5.alertMessageFont.Font) else nil
	v18.FontFace = v20

	v18.TextColor3 = v5.alertMessageColor.Color3

	v18.AutomaticSize = Enum.AutomaticSize.Y
	v18.TextXAlignment = Enum.TextXAlignment.Left
	children.AlertMessage = createElement4("TextLabel", v18)
	v10.RightContent = createElement2("Frame", v12, children)
	return createElement("Frame", v9, v10)
end

return WidgetListModerationAlert
