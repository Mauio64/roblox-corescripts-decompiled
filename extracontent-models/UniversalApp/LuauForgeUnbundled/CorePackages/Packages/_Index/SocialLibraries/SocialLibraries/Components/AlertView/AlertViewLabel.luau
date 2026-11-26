local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("ModalErrorText")

extended.defaultProps = { contentWidth = 0 }

function extended.render(p2)
	local contentWidth = p2.props.contentWidth
	local layoutOrder = p2.props.layoutOrder
	local errorText = p2.props.errorText

	return withStyle(function(props)
		return Roact.createElement(fitTextLabel, {
			BackgroundTransparency = 1,
			width = UDim.new(0, contentWidth),
			Font = normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font),
			LayoutOrder = layoutOrder or nil,
			Size = UDim2.new(0, contentWidth, 0, 0),
			Text = errorText,
			TextColor3 = props.Theme.Alert.Color,
			TextSize = props.Font.BaseSize * props.Font.Footer.RelativeSize,
			TextTransparency = props.Theme.TextDefault.Transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Center
		})
	end)
end

return extended
