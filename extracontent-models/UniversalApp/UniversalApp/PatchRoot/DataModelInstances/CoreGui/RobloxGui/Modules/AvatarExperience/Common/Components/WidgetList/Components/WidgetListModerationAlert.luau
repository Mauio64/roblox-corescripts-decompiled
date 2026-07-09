local CorePackages = game:GetService("CorePackages")
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v10 = Images["icons/status/alert"]

local function mapTokens(p1) -- line: 17
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		alertHeight = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_1300 else p1.Size.Size_2600,
		alertPadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_150 else p1.Size.Size_300,
		alertImageSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_450 else p1.Size.Size_900,
		cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Medium else p1.Radius.Medium,
		backgroundColor = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.BackgroundUi.Default else p1.Color.Surface.Surface_300,
		alertTitleColor = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Muted else p1.Color.Content.Muted,
		alertMessageColor = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Default else p1.Color.Content.Default,
		alertTitleFont = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Subheader else p1.Typography.TitleLarge,
		alertMessageFont = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body else p1.Typography.BodyLarge
	}
end
local function WidgetListModerationAlert(_) -- line: 43
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useStyle (copy), useLocalization (copy), React (copy), ImageSetLabel (copy), v10 (copy)
	local v15 = useDesignTokens(mapTokens)
	local v16 = useStyle()
	local v17 = useLocalization({
		alertTitle = "Feature.Avatar.Label.ModerationFailed",
		alertMessage = "Feature.Avatar.Message.ModerationFailed"
	})
	local Theme = v16.Theme

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = v15.backgroundColor.Transparency,
		BackgroundColor3 = v15.backgroundColor.Color3,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UICornoer = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v15.cornerRadius)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v15.alertPadding),
			PaddingBottom = UDim.new(0, v15.alertPadding),
			PaddingLeft = UDim.new(0, v15.alertPadding),
			PaddingRight = UDim.new(0, v15.alertPadding)
		}),
		UIListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 8)
		}),
		LeftContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, v15.alertImageSize, 1, 0)
		}, {
			AlertImage = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v10,
				Size = UDim2.new(0, v15.alertImageSize, 0, v15.alertImageSize),
				ImageColor3 = Theme.IconDefault.Color,
				ImageTransparency = Theme.IconDefault.Transparency,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			})
		}),
		RightContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -1 * v15.alertImageSize, 1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v15.alertPadding),
				PaddingBottom = UDim.new(0, v15.alertPadding),
				PaddingLeft = UDim.new(0, v15.alertPadding),
				PaddingRight = UDim.new(0, v15.alertPadding)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v15.alertPadding)
			}),
			AlertTitle = React.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v17.alertTitle,
				TextSize = v15.alertTitleFont.FontSize,
				Font = v15.alertTitleFont.Font,
				TextColor3 = v15.alertTitleColor.Color3,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			AlertMessage = React.createElement("TextLabel", {
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v17.alertMessage,
				TextSize = v15.alertMessageFont.FontSize,
				Font = v15.alertMessageFont.Font,
				TextColor3 = v15.alertMessageColor.Color3,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	})
end

return WidgetListModerationAlert
