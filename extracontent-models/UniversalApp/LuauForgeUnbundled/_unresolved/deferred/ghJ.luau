local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Style = require("@game/CorePackages/Workspace/Packages/Style")
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

local Foundation2 = require(CorePackages.Packages.Foundation)
local foundationFontFaceMigration = Foundation2.Utility.Flags.FoundationFontFaceMigration

return function(data)
	local v5 = useDesignTokens()

	return withLocalization({
		statusPrimaryText = data.statusPrimaryText,
		statusSecondaryText = data.statusSecondaryText
	})(function(p2)
		local createElement = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1
		}
		local v9

		if data.submitError then
			local createElement2 = React.createElement
			local v11 = {
				Position = UDim2.new(0, 0, 1, -v5.Typography.TitleLarge.FontSize - v5.Size.Size_300),
				Text = p2.statusPrimaryText,
				Font = 0,
				FontFace = 0,
				TextColor3 = 0,
				TextSize = 0,
				Size = 0,
				BackgroundTransparency = 1,
				TextXAlignment = 0
			}

			local v12 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.BodyLarge) else nil
			v11.Font = v12

			local v13 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.BodyLarge.Font) else nil
			v11.FontFace = v13

			v11.TextColor3 = data.color
			v11.TextSize = v5.Typography.BodyLarge.FontSize
			v11.Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize)

			v11.TextXAlignment = Enum.TextXAlignment.Left
			v9 = createElement2("TextLabel", v11)
		elseif data.BEDUIError then
			local createElement2 = React.createElement
			local v11 = {
				Size = UDim2.new(1, 0, 0.9, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1
			}

			local children = {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				PrimaryText = 0,
				SecondaryText = 0
			}

			local createElement3 = React.createElement
			local v13 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = data.statusPrimaryText,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 1,
				TextColor3 = 0,
				TextTransparency = 0,
				TextSize = 0,
				TextWrapped = true,
				TextXAlignment = 0,
				Size = 0,
				BackgroundTransparency = 1
			}

			local v14 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.HeadingLarge) else nil
			v13.Font = v14

			local v15 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.HeadingLarge.Font) else nil
			v13.FontFace = v15

			v13.TextColor3 = v5.Color.Content.Emphasis.Color3
			v13.TextTransparency = v5.Color.Content.Emphasis.Transparency
			v13.TextSize = v5.Typography.HeadingLarge.FontSize

			v13.TextXAlignment = Enum.TextXAlignment.Center
			v13.Size = UDim2.new(1, 0, 0, v5.Typography.HeadingLarge.FontSize)
			children.PrimaryText = createElement3("TextLabel", v13, {
				Padding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, v5.Size.Size_400)
				})
			})

			local createElement4 = React.createElement
			local v17 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = data.statusSecondaryText,
				Font = 0,
				FontFace = 0,
				LayoutOrder = 2,
				TextColor3 = 0,
				TextTransparency = 0,
				TextSize = 0,
				TextWrapped = true,
				TextXAlignment = 0,
				Size = 0,
				BackgroundTransparency = 1
			}

			local v18 = if not foundationFontFaceMigration then mapTypographyVariantToFontEnum(v5.Typography.HeadingSmall) else nil
			v17.Font = v18

			local v19 = if foundationFontFaceMigration then normalizeFontFace(v5.Typography.HeadingSmall.Font) else nil
			v17.FontFace = v19

			v17.TextColor3 = v5.Color.Content.Default.Color3
			v17.TextTransparency = v5.Color.Content.Emphasis.Transparency
			v17.TextSize = v5.Typography.HeadingSmall.FontSize

			v17.TextXAlignment = Enum.TextXAlignment.Center
			v17.Size = UDim2.new(1, 0, 0, v5.Typography.HeadingSmall.FontSize)
			children.SecondaryText = createElement4("TextLabel", v17)
			v9 = createElement2("Frame", v11, children)
		end

		return createElement("Frame", v7, { FetchStatus = v9 })
	end)
end
