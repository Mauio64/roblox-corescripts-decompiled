local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local extended = Roact.PureComponent:extend("InputHelpTextWithIcon")

function extended.render(p2)
	local helpText = p2.props.helpText
	local iconImage = p2.props.iconImage

	return withStyle(function(props)
		local v5 = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize
		local createElement = Roact.createElement
		local v7 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 0)
		}
		local v8 = {
			ListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Icon = Roact.createElement(imageSetLabel, {
				LayoutOrder = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = iconImage,
				ImageColor3 = props.Theme.SystemPrimaryDefault.Color,
				Size = UDim2.fromOffset(v5, v5)
			}),
			Text = 0
		}

		local createElement2 = Roact.createElement
		local v10 = {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Font = 0,
			FontFace = 0,
			Size = 0,
			Text = 0,
			TextColor3 = 0,
			TextSize = 0,
			TextWrapped = true,
			TextXAlignment = 0
		}

		local v11 = if not foundationFontFaceMigration then props.Font.CaptionBody.Font else nil
		v10.Font = v11

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.BodySmall.Font) else nil
		v10.FontFace = v12

		v10.Size = UDim2.new(1, -v5, 0, 0)
		v10.Text = helpText
		v10.TextColor3 = props.Theme.SystemPrimaryDefault.Color
		v10.TextSize = props.Font.CaptionBody.RelativeSize * props.Font.BaseSize

		v10.TextXAlignment = Enum.TextXAlignment.Left
		v8.Text = createElement2("TextLabel", v10, {
			Padding = Roact.createElement("UIPadding", { PaddingLeft = UDim.new(0, 2) })
		})
		return createElement("Frame", v7, v8)
	end)
end

return extended
