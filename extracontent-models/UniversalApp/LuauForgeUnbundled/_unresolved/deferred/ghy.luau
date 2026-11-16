local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)

local vrConstants = require("@luauforge/bundled/fye").VRConstants
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local module2 = require("@luauforge/bundled/dwM")

local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal

local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

local Foundation2 = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation2.Utility.Flags.FoundationFontFaceMigration

return function(p2)
	local v5 = useDesignTokens()

	module2.assert(
		false,
		"Report Dialog's title and body text have not been localized. This needs to be addressed before this feature is released."
	)

	local createElement = React.createElement
	local v7 = {
		title = "Reporting Coming Soon",
		onCloseClicked = p2.onClose,
		screenSize = vrConstants.MainScreenResolution
	}

	local createElement2 = React.createElement
	local v10 = { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 }

	local v11 = {
		Layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Padding = React.createElement("UIPadding", { PaddingLeft = UDim.new(0, 15) }),
		PrimaryText = 0
	}

	local createElement3 = React.createElement

	local v14 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.TitleLarge) else nil

	local v15 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.TitleLarge.Font) else nil
	v11.PrimaryText = createElement3("TextLabel", {
		Text = "Reporting is coming soon to this platform.",
		Font = v14,
		FontFace = v15,
		LayoutOrder = 1,
		TextColor3 = v5.Color.Content.Emphasis.Color3,
		TextTransparency = v5.Color.Content.Emphasis.Transparency,
		TextSize = v5.Typography.TitleLarge.FontSize,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize),
		BackgroundTransparency = 1
	})
	return createElement(fullPageModal, v7, {
		Texts = createElement2("Frame", v10, v11)
	})
end
