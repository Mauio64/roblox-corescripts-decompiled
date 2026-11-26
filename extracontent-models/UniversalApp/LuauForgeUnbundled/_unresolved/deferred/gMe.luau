local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local UIBlox = require(CorePackages.Packages.UIBlox)

local vrConstants = require("@luauforge/bundled/fFV").VRConstants
local Style = require("@game/CorePackages/Workspace/Packages/Style")
local module2 = require("@luauforge/bundled/dzP")

local fullPageModal = UIBlox.App.Dialog.Modal.FullPageModal

local useDesignTokens = Style.useDesignTokens

return function(p2)
	local v5 = useDesignTokens()

	module2.assert(
		false,
		"Report Dialog's title and body text have not been localized. This needs to be addressed before this feature is released."
	)

	return React.createElement(
		fullPageModal,
		{
			title = "Reporting Coming Soon",
			onCloseClicked = p2.onClose,
			screenSize = vrConstants.MainScreenResolution
		},
		{
			Texts = React.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 },
				{
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 15)
					}),
					PrimaryText = React.createElement("TextLabel", {
						Text = "Reporting is coming soon to this platform.",
						FontFace = normalizeFontFace(v5.Typography.TitleLarge.Font),
						LayoutOrder = 1,
						TextColor3 = v5.Color.Content.Emphasis.Color3,
						TextTransparency = v5.Color.Content.Emphasis.Transparency,
						TextSize = v5.Typography.TitleLarge.FontSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize),
						BackgroundTransparency = 1
					})
				}
			)
		}
	)
end
