local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local Foundation = require(CorePackages.Packages.Foundation)

local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("ModalErrorText")

extended.defaultProps = { contentWidth = 0 }

function extended.render(p2)
	local contentWidth = p2.props.contentWidth
	local layoutOrder = p2.props.layoutOrder
	local errorText = p2.props.errorText

	return withStyle(function(props)
		local createElement = Roact.createElement

		local v8 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		local v9 = if foundationFontFaceMigration then UDim.new(0, contentWidth) else nil

		local v10 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.CaptionSmall.Font) else props.Font.Footer.Font
		return createElement(v5, {
			BackgroundTransparency = 1,
			fitAxis = v8,
			width = v9,
			Font = v10,
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
