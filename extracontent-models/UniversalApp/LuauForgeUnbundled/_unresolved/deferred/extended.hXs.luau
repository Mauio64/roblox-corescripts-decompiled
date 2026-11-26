local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")

local extended = Roact.PureComponent:extend("EmailVerificationUpsellLink")

extended.defaultProps = { textPadding = 8, shouldUseAutomaticSize = false }

function extended.render(p2)
	local textKey = p2.props.textKey
	local layoutOrder = p2.props.layoutOrder
	local onActivatedCallback = p2.props.onActivatedCallback
	local isPrimaryLink = p2.props.isPrimaryLink
	local textPadding = p2.props.textPadding
	local shouldUseAutomaticSize = p2.props.shouldUseAutomaticSize

	return withStyle(function(data)
		return module({ linkText = textKey })(function(p3)
			local subHeader1 = isPrimaryLink and data.Font.SubHeader1 or data.Font.CaptionBody
			local color = onActivatedCallback and data.Theme.SystemPrimaryDefault.Color
				or data.Theme.UIDefault.Color
			local v5 = subHeader1.RelativeSize * data.Font.BaseSize

			local createElement = Roact.createElement
			local v7 = {}
			v7.BackgroundTransparency = 1
			v7.RichText = true
			v7.Text = string.format("<u>%s</u>", p3.linkText)

			local v8 = if shouldUseAutomaticSize then UDim2.new(0, 0, 0, 0) else UDim2.new(1, 0, 0, v5 + textPadding)
			v7.Size = v8

			local v9 = if shouldUseAutomaticSize then Enum.AutomaticSize.XY else nil
			v7.AutomaticSize = v9
			local v11

			if isPrimaryLink then
				v11 = data.Tokens.Typography.TitleLarge.Font
			else
				v11 = data.Tokens.Typography.BodySmall.Font
			end

			v7.FontFace = normalizeFontFace(v11)

			v7.TextColor3 = color
			v7.TextTransparency = data.Theme.TextDefault.Transparency
			v7.TextSize = v5
			v7.LayoutOrder = layoutOrder
			local tag = React.Tag
			local v12 = if fFlagLuaAppAddTestIdsForArrow and p2.props.testId then getTestId(p2.props.testId) else nil
			v7[tag] = v12

			v7[Roact.Event.Activated] = onActivatedCallback
			return createElement("TextButton", v7)
		end)
	end)
end

return extended
