local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local LoadableImage = UIBlox.App.Loading.LoadableImage
local v8 = Roact.PureComponent:extend("GameBanner")

v8.defaultProps = {
	creator = "By (placeholder)",
	name = "Placeholder Game",
	thumbnail = "rbxasset://textures/grid2.png",
	isLoading = false,
	shouldShowCreatorName = true
}

function v8.render(p1) -- line: 24
	-- upvalues: UIBlox (copy), Roact (copy), LoadableImage (copy), Skeleton (copy), EnumsRadius (copy)
	return UIBlox.Style.withStyle(function(p2) -- line: 25
		-- upvalues: Roact (copy), p1 (copy), LoadableImage (copy), Skeleton (copy), EnumsRadius (copy)
		return Roact.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundColor3 = p2.Theme.BackgroundContrast.Color,
			Size = UDim2.new(1, 0, 0, 72)
		}, {
			layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			PlaceThumbnailFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				Size = UDim2.new(0, 72, 0, 72)
			}, {
				layout = Roact.createElement("UIListLayout", {
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				placeThumbnail = not p1.props.isLoading and Roact.createElement(LoadableImage, {
					BackgroundTransparency = 1,
					Image = p1.props.thumbnail,
					Size = UDim2.new(0, 48, 0, 48)
				}) or Roact.createElement(Skeleton, {
					Size = UDim2.new(0, 48, 0, 48),
					radius = EnumsRadius.Small
				})
			}),
			ContentFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, -84, 1, 0)
			}, {
				layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 3)
				}),
				padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 17)
				}),
				PlaceTitle = not p1.props.isLoading and Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 20,
					LayoutOrder = 0,
					Size = UDim2.new(1, 0, 0, 20),
					TextColor3 = p2.Theme.TextEmphasis.Color,
					Font = p2.Font.Header2.Font,
					Text = p1.props.name,
					TextXAlignment = Enum.TextXAlignment.Left
				}) or Roact.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, 20),
					radius = EnumsRadius.Small
				}),
				BuilderLabel = not p1.props.isLoading and Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					TextSize = 17,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 17),
					TextColor3 = p2.Theme.TextDefault.Color,
					Font = p2.Font.Body.Font,
					Text = p1.props.creator,
					TextXAlignment = Enum.TextXAlignment.Left,
					Visible = p1.props.shouldShowCreatorName
				}) or Roact.createElement(Skeleton, {
					Size = UDim2.new(0.6, 0, 0, 17),
					radius = EnumsRadius.Small
				})
			})
		})
	end)
end

return v8
