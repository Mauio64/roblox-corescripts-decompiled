local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local t = require(CorePackages.Packages.t)
local getIconSizeUDim2 = UIBlox.App.ImageSet.getIconSizeUDim2
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local Images = UIBlox.App.ImageSet.Images
local IconSize2 = UIBlox.App.ImageSet.Enum.IconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v15 = getIconSizeUDim2(IconSize2.XLarge)
local v16 = Images["icons/graphic/devices_xxlarge"]
local v17 = t.interface({
	DeviceCode = t.string,
	ShortLink = t.string
})

return function(p1) -- line: 29
	-- upvalues: v17 (copy), useDesignTokens (copy), useStyle (copy), useLocalization (copy), Roact (copy), ImageSetLabel (copy), v15 (copy), v16 (copy), Loading (copy), IconSize (copy)
	assert(v17(p1))

	local v19 = useDesignTokens()
	local LoginView = v19.LuaApps.LoginView
	local v21 = useStyle()
	local DeviceCode = p1.DeviceCode
	local TextEmphasis = v21.Theme.TextEmphasis
	local TextMuted = v21.Theme.TextMuted
	local IconDefault = v21.Theme.IconDefault
	local v26 = useLocalization({
		goToText = "Authentication.CrossDevice.GoToInstruction",
		enterCodeInstruction = "Authentication.CrossDevice.EnterCodeInstruction"
	})

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, LoginView.quickLinkCodeViewTopPadding),
			PaddingBottom = UDim.new(0, LoginView.quickLinkCodeViewBottomPadding)
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 0)
		}),
		DeviceIcon = Roact.createElement(ImageSetLabel, {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = v15,
			ScaleType = Enum.ScaleType.Fit,
			Image = v16,
			ImageColor3 = IconDefault.Color,
			ImageTransparency = IconDefault.Transparency
		}),
		InstructionsPadding = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 4)
		}),
		InstructionTextGroup = Roact.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			GotToDeviceText = Roact.createElement("TextLabel", {
				RichText = false,
				TextWrapped = true,
				TextXAlignment = nil,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Text = v26.goToText,
				Font = v19.Typography.TitleLarge.Font,
				TextSize = v19.Typography.TitleLarge.FontSize,
				TextColor3 = TextMuted.Color,
				TextTransparency = TextMuted.Transparency,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			LinkText = Roact.createElement("TextLabel", {
				RichText = true,
				TextWrapped = true,
				TextXAlignment = nil,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Text = p1.ShortLink,
				Font = v19.Typography.HeadingLarge.Font,
				TextSize = v19.Typography.HeadingLarge.FontSize,
				TextColor3 = TextEmphasis.Color,
				TextTransparency = TextEmphasis.Transparency,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			})
		}),
		QuickLoginCodePadding = Roact.createElement("Frame", {
			LayoutOrder = 4,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 8)
		}),
		QuickLoginCodeGroup = Roact.createElement("Frame", {
			LayoutOrder = 5,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			GoToCodeText = Roact.createElement("TextLabel", {
				RichText = false,
				TextWrapped = true,
				TextXAlignment = nil,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Text = v26.enterCodeInstruction,
				Font = v19.Typography.BodyLarge.Font,
				TextSize = v19.Typography.BodyLarge.FontSize,
				TextColor3 = TextMuted.Color,
				TextTransparency = TextMuted.Transparency,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			CodeDisplayPadding = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 8)
			}),
			CodeDisplay = Roact.createElement("TextLabel", {
				LayoutOrder = 3,
				BackgroundTransparency = 0.7,
				TextXAlignment = nil,
				Text = DeviceCode,
				Font = v19.Typography.HeadingLarge.Font,
				TextSize = v19.Typography.HeadingLarge.FontSize,
				TextColor3 = TextEmphasis.Color,
				TextTransparency = TextEmphasis.Transparency,
				BackgroundColor3 = Color3.new(0, 0, 0),
				Size = UDim2.new(0, v19.Typography.HeadingLarge.FontSize * 6, 0, v19.Typography.HeadingLarge.FontSize * 1.5)
			}, {
				Spinner = DeviceCode == "" and Roact.createElement(Loading, {
					Position = UDim2.new(0.5, 0, 0.5, 0),
					size = IconSize.Small,
					AnchorPoint = Vector2.new(0.5, 0.5)
				}),
				UICorner = Roact.createElement("UICorner", {
					CornerRadius = UDim.new(0, 8)
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(LoginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
					PaddingRight = UDim.new(LoginView.quickLinkCodeViewCodeBoxHorizontalPadding, 0),
					PaddingTop = UDim.new(0, LoginView.quickLinkCodeViewCodeBoxVertialPaddingb),
					PaddingBottom = UDim.new(0, LoginView.quickLinkCodeViewCodeBoxVertialPaddingb)
				})
			})
		})
	})
end
