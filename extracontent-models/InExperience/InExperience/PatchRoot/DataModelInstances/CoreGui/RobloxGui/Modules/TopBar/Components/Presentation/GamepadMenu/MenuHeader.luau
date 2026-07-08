local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v9 = Images["icons/imageUnavailable"]
local v10 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)
local v12 = Roact.PureComponent:extend("MenuHeader")

v12.validateProps = t.strictInterface({
	gameName = t.string,
	layoutOrder = t.integer,
	height = t.numberPositive
})

function v12.render(p1) -- line: 38
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v10 (copy), rect (copy), v9 (copy)
	return withStyle(function(p2) -- line: 39
		-- upvalues: Roact (copy), ImageSetLabel (copy), v10 (copy), rect (copy), v9 (copy), p1 (copy)
		local Theme = p2.Theme
		local p2Font = p2.Font
		local v19

		if game.GameId == 0 then
			v19 = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = v10,
				SliceCenter = rect,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.fromOffset(80, 80),
				ImageColor3 = p2.Theme.PlaceHolder.Color,
				ImageTransparency = p2.Theme.PlaceHolder.Transparency
			}, {
				PlaceholderIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(44, 44),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = v9,
					ImageColor3 = p2.Theme.UIDefault.Color,
					ImageTransparency = p2.Theme.UIDefault.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		else
			local v20 = ("rbxthumb://type=GameIcon&id=%d&w=%d&h=%d"):format(game.GameId, 128, 128)

			v19 = Roact.createElement("ImageLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(80, 80),
				Image = v20
			})
		end

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = p1.props.layoutOrder,
			Size = UDim2.new(1, 0, 0, p1.props.height)
		}, {
			ContentsFrame = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 20)
				}),
				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20)
				}),
				GameIcon = v19,
				TextFrame = Roact.createElement("Frame", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -100, 1, 0)
				}, {
					TextLabel = Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, -45),
						Position = UDim2.fromOffset(0, 25),
						Font = p2Font.Header1.Font,
						Text = p1.props.gameName,
						TextSize = p2Font.BaseSize * p2Font.Header1.RelativeSize,
						TextColor3 = Theme.TextEmphasis.Color,
						TextTransparency = Theme.TextEmphasis.TextTransparency,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
						TextTruncate = Enum.TextTruncate.AtEnd
					})
				})
			}),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = Theme.Divider.Transparency,
				BackgroundColor3 = Theme.Divider.Color
			})
		})
	end)
end

local function mapStateToProps(p3) -- line: 138
	return {
		gameName = p3.gameInfo.name
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(v12)
