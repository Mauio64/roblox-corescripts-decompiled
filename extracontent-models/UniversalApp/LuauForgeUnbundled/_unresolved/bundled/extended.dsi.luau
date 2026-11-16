local module = require("@luauforge/bundled/drf")
local module2 = require("@luauforge/bundled/drd")
local module3 = require("@luauforge/bundled/dsg")

local withStyle = module2.Style.withStyle
local withLocalization = require("@luauforge/bundled/drP").withLocalization
local text = require("@luauforge/bundled/dqY").Text
local getTextSize = require("@luauforge/bundled/dsj").GetTextSize
local module4 = require("@luauforge/bundled/dsk")
local normalizeFontFace = module3.Utility.normalizeFontFace
local foundationFontFaceMigration = module3.Utility.Flags.FoundationFontFaceMigration

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
			local v7

			if foundationFontFaceMigration then
				v7 = getTextSize(creatorByLabel, v5, font.Body.Font, Vector2.new(10000, 10000)).X
			else
				v7 = text.GetTextWidth(creatorByLabel, font.Body.Font, v5)
			end

			local createElement = module.createElement
			local v10 = if hasVerifiedBadge then UDim2.new(0, 0, 1, 0) else UDim2.new(1, -v7, 1, 0)
			local v9 = {
				Size = v10,
				AutomaticSize = Enum.AutomaticSize.XY,
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextSize = v5,
				TextColor3 = theme.TextEmphasis.Color,
				TextTransparency = theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				Text = 0,
				TextTruncate = 0,
				TextXAlignment = 0,
				TextYAlignment = 0
			}
			local v11 = if not foundationFontFaceMigration then font.Header2.Font else nil
			v9.Font = v11

			local v12 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.TitleLarge.Font) else nil
			v9.FontFace = v12

			v9.Text = name
			v9.TextTruncate = Enum.TextTruncate.AtEnd
			v9.TextXAlignment = Enum.TextXAlignment.Left
			v9.TextYAlignment = textYAlignment
			local element = createElement("TextLabel", v9, {
				UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
					MaxTextSize = v6
				})
			})

			local createElement2 = module.createElement
			local v14 = {
				Size = UDim2.new(1, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				ClipsDescendants = true
			}

			local v15 = {
				UIListLayout = module.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, 6)
				}),
				Label = 0,
				CreatorName = 0,
				VerifiedCreatorName = 0
			}

			local createElement3 = module.createElement
			local v17 = {
				Size = UDim2.new(0, 0, 0, 0),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextSize = v5,
				TextColor3 = theme.TextDefault.Color,
				TextTransparency = theme.TextDefault.Transparency,
				Font = 0,
				FontFace = 0,
				Text = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				AutomaticSize = 0
			}
			local v18 = if not foundationFontFaceMigration then font.Header2.Font else nil
			v17.Font = v18

			local v19 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.TitleLarge.Font) else nil
			v17.FontFace = v19

			v17.Text = creatorByLabel
			v17.TextXAlignment = Enum.TextXAlignment.Left
			v17.TextYAlignment = textYAlignment
			v17.AutomaticSize = Enum.AutomaticSize.XY
			v15.Label = createElement3("TextLabel", v17, {
				UITextSizeConstraint = module.createElement("UITextSizeConstraint", {
					MaxTextSize = v6
				})
			})

			v15.CreatorName = not hasVerifiedBadge and element
			v15.VerifiedCreatorName = hasVerifiedBadge and module.createElement(module4.EmojiWrapper, {
				emoji = module4.emoji.verified,
				font = font.Body.Font,
				size = UDim2.new(1, -v7, 0, 0),
				automaticSize = Enum.AutomaticSize.XY,
				horizontalAlignment = Enum.HorizontalAlignment.Left,
				verticalAlignment = Enum.VerticalAlignment.Center,
				layoutOrder = 2
			}, { CreatorName = element })
			return createElement2("Frame", v14, v15)
		end)
	end)
end

return extended
