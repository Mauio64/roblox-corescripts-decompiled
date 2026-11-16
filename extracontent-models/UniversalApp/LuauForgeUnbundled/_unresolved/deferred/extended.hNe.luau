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

local extended = Roact.PureComponent:extend("ModalBodyText")

extended.defaultProps = { contentWidth = 0 }

function extended.render(p2)
	local contentWidth = p2.props.contentWidth
	local layoutOrder = p2.props.layoutOrder
	local richText = p2.props.richText
	local text = p2.props.text

	return withStyle(function(props)
		local v6 = props.Font.Body.Font

		if p2.props.useBold == true then
			v6 = props.Font.Header1.Font
		end

		local v7 = Enum.TextXAlignment.Center

		if p2.props.alignLeft == true then
			v7 = Enum.TextXAlignment.Left
		end

		local x = if contentWidth == 0 then Enum.AutomaticSize.X else nil

		local createElement = Roact.createElement

		local v10 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		local v11 = if foundationFontFaceMigration then UDim.new(0, contentWidth) else nil

		if foundationFontFaceMigration then
			local v13

			if p2.props.useBold == true then
				v13 = props.Tokens.Typography.HeadingSmall.Font
			else
				v13 = props.Tokens.Typography.BodyLarge.Font
			end

			v6 = normalizeFontFace(v13)
		end

		return createElement(v5, {
			BackgroundTransparency = 1,
			fitAxis = v10,
			width = v11,
			Font = v6,
			LayoutOrder = layoutOrder or nil,
			RichText = richText,
			Size = UDim2.new(0, contentWidth, 0, 0),
			AutomaticSize = x,
			Text = text,
			TextColor3 = props.Theme.TextDefault.Color,
			TextSize = props.Font.Body.RelativeSize * props.Font.BaseSize,
			TextTransparency = props.Theme.TextDefault.Transparency,
			TextWrapped = true,
			TextXAlignment = v7
		})
	end)
end

return extended
