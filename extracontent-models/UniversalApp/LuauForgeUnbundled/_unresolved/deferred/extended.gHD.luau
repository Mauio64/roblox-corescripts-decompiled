local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local loadableImage = UIBlox.App.Loading.LoadableImage

local extended = Roact.PureComponent:extend("GameBanner")

extended.defaultProps = {
	creator = "By (placeholder)",
	name = "Placeholder Game",
	thumbnail = "rbxasset://textures/grid2.png",
	isLoading = false,
	shouldShowCreatorName = true
}

function extended.render(p2)
	return UIBlox.Style.withStyle(function(p3)
		return Roact.createElement(
			"Frame",
			{
				BackgroundColor3 = p3.Theme.BackgroundContrast.Color,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 72)
			},
			{
				layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					FillDirection = Enum.FillDirection.Horizontal
				}),
				PlaceThumbnailFrame = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 72, 0, 72),
						LayoutOrder = 0
					},
					{
						layout = Roact.createElement("UIListLayout", {
							VerticalAlignment = Enum.VerticalAlignment.Center,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						placeThumbnail = not p2.props.isLoading and Roact.createElement(loadableImage, {
							Image = p2.props.thumbnail,
							Size = UDim2.new(0, 48, 0, 48),
							BackgroundTransparency = 1
						}) or Roact.createElement(skeleton, {
							Size = UDim2.new(0, 48, 0, 48),
							radius = radius.Small
						})
					}
				),
				ContentFrame = Roact.createElement(
					"Frame",
					{
						Size = UDim2.new(1, -84, 1, 0),
						BackgroundTransparency = 1,
						LayoutOrder = 1
					},
					{
						layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							SortOrder = Enum.SortOrder.LayoutOrder,
							Padding = UDim.new(0, 3)
						}),
						padding = Roact.createElement("UIPadding", {
							PaddingTop = UDim.new(0, 17)
						}),
						PlaceTitle = not p2.props.isLoading and Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 20),
							TextSize = 20,
							TextColor3 = p3.Theme.TextEmphasis.Color,
							FontFace = normalizeFontFace(p3.Tokens.Typography.TitleLarge.Font),
							Text = p2.props.name,
							TextXAlignment = Enum.TextXAlignment.Left,
							LayoutOrder = 0
						}) or Roact.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 20),
							radius = radius.Small
						}),
						BuilderLabel = not p2.props.isLoading and Roact.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 17),
							TextSize = 17,
							TextColor3 = p3.Theme.TextDefault.Color,
							FontFace = normalizeFontFace(p3.Tokens.Typography.BodyLarge.Font),
							Text = p2.props.creator,
							TextXAlignment = Enum.TextXAlignment.Left,
							Visible = p2.props.shouldShowCreatorName,
							LayoutOrder = 1
						}) or Roact.createElement(skeleton, {
							Size = UDim2.new(0.6, 0, 0, 17),
							radius = radius.Small
						})
					}
				)
			}
		)
	end)
end

return extended
