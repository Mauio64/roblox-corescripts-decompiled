local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local withStyle = UIBlox.Core.Style.withStyle
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local iconsimageUnavailable = Images["icons/imageUnavailable"]
local component_assetscircle_17 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)

local extended = Roact.PureComponent:extend("MenuHeader")

extended.validateProps = t.strictInterface({
	gameName = t.string,
	layoutOrder = t.integer,
	height = t.numberPositive
})

function extended.render(p)
	return withStyle(function(props)
		local theme = props.Theme
		local font = props.Font
		local gameIcon

		if game.GameId == 0 then
			gameIcon = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17,
				SliceCenter = rect,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.fromOffset(80, 80),
				ImageColor3 = props.Theme.PlaceHolder.Color,
				ImageTransparency = props.Theme.PlaceHolder.Transparency
			}, {
				PlaceholderIcon = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(44, 44),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = iconsimageUnavailable,
					ImageColor3 = props.Theme.UIDefault.Color,
					ImageTransparency = props.Theme.UIDefault.Transparency,
					AnchorPoint = Vector2.new(0.5, 0.5)
				})
			})
		else
			local formatted = ("rbxthumb://type=GameIcon&id=%d&w=%d&h=%d"):format(game.GameId, 128, 128)

			gameIcon = Roact.createElement("ImageLabel", {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(80, 80),
				Image = formatted
			})
		end

		local createElement = Roact.createElement
		local v = {
			LayoutOrder = p.props.layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, p.props.height)
		}

		local createElement2 = Roact.createElement
		local v2 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1) }
		local v3 = {
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
			GameIcon = gameIcon,
			TextFrame = 0
		}

		local createElement3 = Roact.createElement
		local v4 = { LayoutOrder = 2, BackgroundTransparency = 1, Size = UDim2.new(1, -100, 1, 0) }

		local createElement4 = Roact.createElement
		local v5 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -45),
			Position = UDim2.fromOffset(0, 25),
			Font = 0,
			FontFace = 0,
			Text = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextTruncate = 0,
			TextWrapped = true
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = font.Header1.Font
		end

		v5.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.HeadingSmall.Font)
		end

		v5.FontFace = fontFace

		v5.Text = p.props.gameName
		v5.TextSize = font.BaseSize * font.Header1.RelativeSize
		v5.TextColor3 = theme.TextEmphasis.Color
		v5.TextTransparency = theme.TextEmphasis.TextTransparency
		v5.TextXAlignment = Enum.TextXAlignment.Left
		v5.TextYAlignment = Enum.TextYAlignment.Top
		v5.TextTruncate = Enum.TextTruncate.AtEnd
		v3.TextFrame = createElement3("Frame", v4, {
			TextLabel = createElement4("TextLabel", v5)
		})
		return createElement("Frame", v, {
			ContentsFrame = createElement2("Frame", v2, v3),
			Divider = Roact.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				BackgroundTransparency = theme.Divider.Transparency,
				BackgroundColor3 = theme.Divider.Color
			})
		})
	end)
end

local function mapStateToProps(p)
	return { gameName = p.gameInfo.name }
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, nil)(extended)
