local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(Parent.Style).useDesignTokens
local v10 = Images["icons/navigation/pushRight"]

function SeeAllTile(t1: {[any]: any}) -- line: 29
	-- upvalues: useDesignTokens (copy), useLocalization (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useCursor (copy), v10 (copy), React (copy), ImageSetLabel (copy)
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local v14 = useDesignTokens()
	local v15 = useLocalization({
		seeAll = "Feature.Home.ActionSeeAll"
	})
	local uDim = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Space_100 else v14.Size.Size_200)
	local v17 = useCursor(uDim)
	local v18 = if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Typography.Subheader else v14.Typography.TitleLarge
	local Color3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.Text.Emphasis else v14.Color.Content.Emphasis)).Color3
	local Color3_2 = ((if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.Icon.Emphasis else v14.Color.Content.Emphasis)).Color3
	local Transparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.Icon.Emphasis else v14.Color.Content.Emphasis)).Transparency
	local v22 = t1.title or v15.seeAll
	local v23 = t1.icon or v10
	local v24 = if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Icon.Size.Medium else v14.Size.Size_900

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Text = "",
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.BackgroundUi.Default else v14.Color.Surface.Surface_300)).Transparency,
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v14.Semantic.Color.BackgroundUi.Default else v14.Color.Surface.Surface_300)).Color3,
		[React.Event.Activated] = t1.onActivated,
		SelectionImageObject = v17
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Space_50 else v14.Size.Size_100)
		}),
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(v24, v24),
			Image = v23,
			ImageColor3 = Color3_2,
			ImageTransparency = Transparency
		}),
		Title = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = v22,
			Size = UDim2.new(1, 0, 0, v18.FontSize),
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = v18.Font,
			TextSize = v18.FontSize,
			TextColor3 = Color3,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return SeeAllTile
