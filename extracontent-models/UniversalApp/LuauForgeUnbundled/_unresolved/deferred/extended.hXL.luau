local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("ModalBodyText")

extended.defaultProps = { contentWidth = 0 }

function extended.render(p2)
	local contentWidth = p2.props.contentWidth
	local layoutOrder = p2.props.layoutOrder
	local richText = p2.props.richText
	local text = p2.props.text

	return withStyle(function(props)
		local useBold = p2.props.useBold == true

		local v5 = Enum.TextXAlignment.Center

		if p2.props.alignLeft == true then
			v5 = Enum.TextXAlignment.Left
		end

		local x = if contentWidth == 0 then Enum.AutomaticSize.X else nil

		local createElement = Roact.createElement
		local v7 = {
			BackgroundTransparency = 1,
			width = UDim.new(0, contentWidth),
			Font = 0,
			LayoutOrder = 0,
			RichText = 0,
			Size = 0,
			AutomaticSize = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextTransparency = 0,
			TextWrapped = true,
			TextXAlignment = 0
		}
		local v9

		if p2.props.useBold == true then
			v9 = props.Tokens.Typography.HeadingSmall.Font
		else
			v9 = props.Tokens.Typography.BodyLarge.Font
		end

		v7.Font = normalizeFontFace(v9)

		v7.LayoutOrder = layoutOrder or nil
		v7.RichText = richText
		v7.Size = UDim2.new(0, contentWidth, 0, 0)
		v7.AutomaticSize = x
		v7.Text = text
		v7.TextColor3 = props.Theme.TextDefault.Color
		v7.TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize
		v7.TextTransparency = props.Theme.TextDefault.Transparency

		v7.TextXAlignment = v5
		return createElement(fitTextLabel, v7)
	end)
end

return extended
