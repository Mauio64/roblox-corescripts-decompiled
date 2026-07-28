local Parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useCursor = UIBlox.App.SelectionCursor.useCursor
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(Parent.Style).useDesignTokens
local v9 = Images["icons/navigation/pushRight"]

function SeeAllTile(t1: {[any]: any}) -- line: 27
	-- upvalues: useDesignTokens (copy), useLocalization (copy), useCursor (copy), v9 (copy), React (copy), ImageSetLabel (copy)
	local size = t1.size
	local layoutOrder = t1.layoutOrder
	local v13 = useDesignTokens()
	local v14 = useLocalization({
		seeAll = "Feature.Home.ActionSeeAll"
	})
	local uDim = UDim.new(0, v13.Size.Size_200)
	local v16 = useCursor(uDim)
	local TitleLarge = v13.Typography.TitleLarge
	local EmphasisColor3 = v13.Color.Content.Emphasis.Color3
	local EmphasisColor3_2 = v13.Color.Content.Emphasis.Color3
	local EmphasisTransparency = v13.Color.Content.Emphasis.Transparency
	local v21 = t1.title or v14.seeAll
	local v22 = t1.icon or v9
	local Size_900 = v13.Size.Size_900

	return React.createElement("TextButton", {
		AutoButtonColor = false,
		Text = "",
		Size = size,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = v13.Color.Surface.Surface_300.Transparency,
		BackgroundColor3 = v13.Color.Surface.Surface_300.Color3,
		[React.Event.Activated] = t1.onActivated,
		SelectionImageObject = v16
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v13.Size.Size_100)
		}),
		Icon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(Size_900, Size_900),
			Image = v22,
			ImageColor3 = EmphasisColor3_2,
			ImageTransparency = EmphasisTransparency
		}),
		Title = React.createElement("TextLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Text = v21,
			Size = UDim2.new(1, 0, 0, TitleLarge.FontSize),
			TextXAlignment = Enum.TextXAlignment.Center,
			Font = TitleLarge.Font,
			TextSize = TitleLarge.FontSize,
			TextColor3 = EmphasisColor3,
			TextTruncate = Enum.TextTruncate.AtEnd
		})
	})
end

return SeeAllTile
