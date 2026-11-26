local module = require("@luauforge/bundled/duh")
local module2 = require("@luauforge/bundled/duf")
local module3 = require("@luauforge/bundled/dvi")

local withStyle = module2.Style.withStyle
local withLocalization = require("@luauforge/bundled/duR").withLocalization
local getTextSize = require("@luauforge/bundled/dvl").GetTextSize
local module4 = require("@luauforge/bundled/dvm")
local normalizeFontFace = module3.Utility.normalizeFontFace

local extended = module.PureComponent:extend("ItemTileCreatorName")

extended.defaultProps = { textYAlignment = Enum.TextYAlignment.Top }

function extended.render(p2)
	local name = p2.props.name
	local hasVerifiedBadge = p2.props.hasVerifiedBadge
	local textYAlignment = p2.props.textYAlignment

	return withStyle(function(data)
		local theme = data.Theme
		local font = data.Font
		local v5 = font.BaseSize * font.Header2.RelativeSize
		local v6 = v5 + data.Tokens.Size.Size_200

		return withLocalization({ creatorByLabel = "Feature.GameDetails.Label.By" })(function(p3)
			local creatorByLabel = p3.creatorByLabel

			local x = getTextSize(creatorByLabel, v5, font.Body.Font, Vector2.new(10000, 10000)).X

			local createElement = module.createElement
			local v9 = if hasVerifiedBadge then UDim2.new(0, 0, 1, 0) else UDim2.new(1, -x, 1, 0)
			local element = createElement("TextLabel", {
				Size = v9,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextSize = v5,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				FontFace = normalizeFontFace(data.Tokens.Typography.TitleLarge.Font),
				Text = name,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = textYAlignment
			}, {
				UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
					MaxTextSize = v6
				})
			})

			return module.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					ClipsDescendants = true
				},
				{
					UIListLayout = module.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, 6)
					}),
					Label = module.createElement("TextLabel", {
						Size = UDim2.new(0, 0, 0, 0),
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextSize = v5,
						TextColor3 = theme.TextDefault.Color,
						TextTransparency = theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(data.Tokens.Typography.TitleLarge.Font),
						Text = creatorByLabel,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = textYAlignment,
						AutomaticSize = Enum.AutomaticSize.XY
					}, {
						UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
							MaxTextSize = v6
						})
					}),
					CreatorName = not hasVerifiedBadge and element,
					VerifiedCreatorName = hasVerifiedBadge and module.createElement(module4.EmojiWrapper, {
						emoji = module4.emoji.verified,
						font = font.Body.Font,
						size = UDim2.new(1, -x, 0, 0),
						automaticSize = Enum.AutomaticSize.XY,
						horizontalAlignment = Enum.HorizontalAlignment.Left,
						verticalAlignment = Enum.VerticalAlignment.Center,
						layoutOrder = 2
					}, { CreatorName = element })
				}
			)
		end)
	end)
end

return extended
