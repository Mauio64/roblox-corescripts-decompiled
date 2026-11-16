local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
	return UIBlox.Style.withStyle(function(props)
		local createElement = Roact.createElement
		local v6 = {
			BackgroundColor3 = props.Theme.BackgroundContrast.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 72)
		}
		local v7 = {
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
			ContentFrame = 0
		}

		local createElement2 = Roact.createElement
		local v9 = {
			Size = UDim2.new(1, -84, 1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v10 = {
			layout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 3)
			}),
			padding = Roact.createElement("UIPadding", { PaddingTop = UDim.new(0, 17) }),
			PlaceTitle = 0,
			BuilderLabel = 0
		}
		local v11

		if p2.props.isLoading then
			v11 = Roact.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, 20),
				radius = radius.Small
			})
		else
			local createElement3 = Roact.createElement
			local v13 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 20),
				TextSize = 20,
				TextColor3 = props.Theme.TextEmphasis.Color,
				Font = 0,
				FontFace = 0,
				Text = 0,
				TextXAlignment = 0,
				LayoutOrder = 0
			}
			local v14 = if not foundationFontFaceMigration then props.Font.Header2.Font else nil
			v13.Font = v14

			local v15 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
			v13.FontFace = v15

			v13.Text = p2.props.name
			v13.TextXAlignment = Enum.TextXAlignment.Left
			v11 = createElement3("TextLabel", v13)
				or Roact.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 20),
					radius = radius.Small
				})
		end

		v10.PlaceTitle = v11
		local v12

		if p2.props.isLoading then
			v12 = Roact.createElement(skeleton, {
				Size = UDim2.new(0.6, 0, 0, 17),
				radius = radius.Small
			})
		else
			local createElement3 = Roact.createElement
			local v14 = {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 17),
				TextSize = 17,
				TextColor3 = props.Theme.TextDefault.Color,
				Font = 0,
				FontFace = 0,
				Text = 0,
				TextXAlignment = 0,
				Visible = 0,
				LayoutOrder = 1
			}
			local v15 = if not foundationFontFaceMigration then props.Font.Body.Font else nil
			v14.Font = v15

			local v16 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodyLarge.Font) else nil
			v14.FontFace = v16

			v14.Text = p2.props.creator
			v14.TextXAlignment = Enum.TextXAlignment.Left
			v14.Visible = p2.props.shouldShowCreatorName
			v12 = createElement3("TextLabel", v14)
				or Roact.createElement(skeleton, {
					Size = UDim2.new(0.6, 0, 0, 17),
					radius = radius.Small
				})
		end

		v10.BuilderLabel = v12
		v7.ContentFrame = createElement2("Frame", v9, v10)
		return createElement("Frame", v6, v7)
	end)
end

return extended
