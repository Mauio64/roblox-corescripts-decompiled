local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Style = require(CorePackages.Workspace.Packages.Style)
local ReportTargetThumbnail = require(Modules.LuaApp.Components.AbuseReporting.ReportTargetThumbnail)
local useDesignTokens = Style.useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useDesignTokens (copy), React (copy), ReportTargetThumbnail (copy), mapTypographyVariantToFontEnum (copy)
	local v9 = useDesignTokens()

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v9.Size.Size_2800)
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v9.Size.Size_600),
			PaddingBottom = UDim.new(0, v9.Size.Size_1400)
		}),
		TargetInner = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Thumbnail = React.createElement(ReportTargetThumbnail, {
				thumbnailUrl = t1.thumbnailUrl
			}),
			Texts = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v9.Size.Size_300)
				}),
				PrimaryText = React.createElement("TextLabel", {
					LayoutOrder = 1,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = t1.primaryText,
					Font = mapTypographyVariantToFontEnum(v9.Typography.TitleLarge),
					TextColor3 = v9.Color.Content.Emphasis.Color3,
					TextTransparency = v9.Color.Content.Emphasis.Transparency,
					TextSize = v9.Typography.TitleLarge.FontSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(0, 0, 0, v9.Typography.TitleLarge.FontSize)
				}),
				SecondaryText = React.createElement("TextLabel", {
					LayoutOrder = 2,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = t1.secondaryText,
					Font = mapTypographyVariantToFontEnum(v9.Typography.BodyLarge),
					TextColor3 = v9.Color.Content.Default.Color3,
					TextTransparency = v9.Color.Content.Emphasis.Transparency,
					TextSize = v9.Typography.BodyLarge.FontSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = UDim2.new(0, 0, 0, v9.Typography.TitleLarge.FontSize)
				})
			})
		})
	})
end
