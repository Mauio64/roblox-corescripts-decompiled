local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local t = require(CorePackages.Packages.t)
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local useStyle = UIBlox.Core.Style.useStyle

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local images = UIBlox.App.ImageSet.Images
local iconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconSizeUDim2 = getIconSizeUDim2(iconSize2.XLarge)
local iconsgraphicdevices_xxlarge = images["icons/graphic/devices_xxlarge"]

local interface = t.interface({ DeviceCode = t.string, ShortLink = t.string })

return function(p2)
	assert(interface(p2))
	local v5 = useDesignTokens()
	local loginView = v5.LuaApps.LoginView

	local v6 = useStyle()
	local deviceCode = p2.DeviceCode

	local textEmphasis = v6.Theme.TextEmphasis
	local textMuted = v6.Theme.TextMuted
	local iconDefault = v6.Theme.IconDefault

	local v7 = useLocalization({
		goToText = "Authentication.CrossDevice.GoToInstruction",
		enterCodeInstruction = "Authentication.CrossDevice.EnterCodeInstruction"
	})

	local createElement = Roact.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local children = {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, loginView.quickLinkCodeViewTopPadding),
			PaddingBottom = UDim.new(0, loginView.quickLinkCodeViewBottomPadding)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		DeviceIcon = Roact.createElement(imageSetLabel, {
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = iconSizeUDim2,
			BackgroundTransparency = 1,
			ScaleType = Enum.ScaleType.Fit,
			Image = iconsgraphicdevices_xxlarge,
			ImageColor3 = iconDefault.Color,
			ImageTransparency = iconDefault.Transparency
		}),
		InstructionsPadding = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 4)
		}),
		InstructionTextGroup = 0,
		QuickLoginCodePadding = 0,
		QuickLoginCodeGroup = 0
	}

	local createElement2 = Roact.createElement
	local v11 = {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local children2 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		GotToDeviceText = 0,
		LinkText = 0
	}

	local createElement3 = Roact.createElement
	local v13 = {
		Text = v7.goToText,
		Font = 0,
		FontFace = 0,
		RichText = false,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		TextXAlignment = nil,
		AutomaticSize = 0,
		Size = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local v14 = if not foundationFontFaceMigration then v5.Typography.TitleLarge.Font else nil
	v13.Font = v14

	local v15 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v13.FontFace = v15

	v13.TextSize = v5.Typography.TitleLarge.FontSize
	v13.TextColor3 = textMuted.Color
	v13.TextTransparency = textMuted.Transparency

	v13.AutomaticSize = Enum.AutomaticSize.Y
	v13.Size = UDim2.new(1, 0, 0, 0)
	children2.GotToDeviceText = createElement3("TextLabel", v13)

	local createElement4 = Roact.createElement
	local v17 = {
		Text = p2.ShortLink,
		RichText = true,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		TextXAlignment = nil,
		AutomaticSize = 0,
		Size = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 2
	}

	local v18 = if not foundationFontFaceMigration then v5.Typography.HeadingLarge.Font else nil
	v17.Font = v18

	local v19 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.HeadingLarge.Font) else nil
	v17.FontFace = v19

	v17.TextSize = v5.Typography.HeadingLarge.FontSize
	v17.TextColor3 = textEmphasis.Color
	v17.TextTransparency = textEmphasis.Transparency

	v17.AutomaticSize = Enum.AutomaticSize.Y
	v17.Size = UDim2.new(1, 0, 0, 0)
	children2.LinkText = createElement4("TextLabel", v17)
	children.InstructionTextGroup = createElement2("Frame", v11, children2)

	children.QuickLoginCodePadding = Roact.createElement("Frame", {
		LayoutOrder = 4,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 8)
	})

	local createElement5 = Roact.createElement
	local v21 = {
		LayoutOrder = 5,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1
	}

	local children3 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		GoToCodeText = 0,
		CodeDisplayPadding = 0,
		CodeDisplay = 0
	}

	local createElement6 = Roact.createElement
	local v23 = {
		Text = v7.enterCodeInstruction,
		Font = 0,
		FontFace = 0,
		RichText = false,
		TextSize = 0,
		TextColor3 = 0,
		TextTransparency = 0,
		TextWrapped = true,
		TextXAlignment = nil,
		AutomaticSize = 0,
		Size = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local v24 = if not foundationFontFaceMigration then v5.Typography.BodyLarge.Font else nil
	v23.Font = v24

	local v25 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.BodyLarge.Font) else nil
	v23.FontFace = v25

	v23.TextSize = v5.Typography.BodyLarge.FontSize
	v23.TextColor3 = textMuted.Color
	v23.TextTransparency = textMuted.Transparency

	v23.AutomaticSize = Enum.AutomaticSize.Y
	v23.Size = UDim2.new(1, 0, 0, 0)
	children3.GoToCodeText = createElement6("TextLabel", v23)

	children3.CodeDisplayPadding = Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 8),
		LayoutOrder = 2
	})

	local createElement7 = Roact.createElement

	local v28 = if not foundationFontFaceMigration then v5.Typography.HeadingLarge.Font else nil

	local v29 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.HeadingLarge.Font) else nil
	children3.CodeDisplay = createElement7("TextLabel", {
		LayoutOrder = 3,
		Text = deviceCode,
		Font = v28,
		FontFace = v29,
		TextSize = v5.Typography.HeadingLarge.FontSize,
		TextColor3 = textEmphasis.Color,
		TextTransparency = textEmphasis.Transparency,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.7,
		TextXAlignment = nil,
		Size = UDim2.new(
			0,
			v5.Typography.HeadingLarge.FontSize * 6,
			0,
			v5.Typography.HeadingLarge.FontSize * 1.5
		)
	}, {
		Spinner = deviceCode == "" and Roact.createElement(loading, {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			size = iconSize.Small,
			AnchorPoint = Vector2.new(0.5, 0.5)
		}),
		UICorner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		UIPadding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(loginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
			PaddingRight = UDim.new(loginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
			PaddingTop = UDim.new(0, loginView.quickLinkCodeViewCodeBoxVertialPaddingb),
			PaddingBottom = UDim.new(0, loginView.quickLinkCodeViewCodeBoxVertialPaddingb)
		})
	})
	children.QuickLoginCodeGroup = createElement5("Frame", v21, children3)
	return createElement("Frame", v9, children)
end
