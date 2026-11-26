local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading
local normalizeFontFace = Foundation.Utility.normalizeFontFace

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

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		},
		{
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
			InstructionTextGroup = Roact.createElement(
				"Frame",
				{
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					GotToDeviceText = Roact.createElement("TextLabel", {
						Text = v7.goToText,
						FontFace = normalizeFontFace(v5.Typography.TitleLarge.Font),
						RichText = false,
						TextSize = v5.Typography.TitleLarge.FontSize,
						TextColor3 = textMuted.Color,
						TextTransparency = textMuted.Transparency,
						TextWrapped = true,
						TextXAlignment = nil,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}),
					LinkText = Roact.createElement("TextLabel", {
						Text = p2.ShortLink,
						RichText = true,
						FontFace = normalizeFontFace(v5.Typography.HeadingLarge.Font),
						TextSize = v5.Typography.HeadingLarge.FontSize,
						TextColor3 = textEmphasis.Color,
						TextTransparency = textEmphasis.Transparency,
						TextWrapped = true,
						TextXAlignment = nil,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 2
					})
				}
			),
			QuickLoginCodePadding = Roact.createElement("Frame", {
				LayoutOrder = 4,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 8)
			}),
			QuickLoginCodeGroup = Roact.createElement(
				"Frame",
				{
					LayoutOrder = 5,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1
				},
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center
					}),
					GoToCodeText = Roact.createElement("TextLabel", {
						Text = v7.enterCodeInstruction,
						FontFace = normalizeFontFace(v5.Typography.BodyLarge.Font),
						RichText = false,
						TextSize = v5.Typography.BodyLarge.FontSize,
						TextColor3 = textMuted.Color,
						TextTransparency = textMuted.Transparency,
						TextWrapped = true,
						TextXAlignment = nil,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1, 0, 0, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					}),
					CodeDisplayPadding = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 8),
						LayoutOrder = 2
					}),
					CodeDisplay = Roact.createElement("TextLabel", {
						LayoutOrder = 3,
						Text = deviceCode,
						FontFace = normalizeFontFace(v5.Typography.HeadingLarge.Font),
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
						UICorner = Roact.createElement("UICorner", {
							CornerRadius = UDim.new(0, 8)
						}),
						UIPadding = Roact.createElement("UIPadding", {
							PaddingLeft = UDim.new(loginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
							PaddingRight = UDim.new(loginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
							PaddingTop = UDim.new(0, loginView.quickLinkCodeViewCodeBoxVertialPaddingb),
							PaddingBottom = UDim.new(0, loginView.quickLinkCodeViewCodeBoxVertialPaddingb)
						})
					})
				}
			)
		}
	)
end
