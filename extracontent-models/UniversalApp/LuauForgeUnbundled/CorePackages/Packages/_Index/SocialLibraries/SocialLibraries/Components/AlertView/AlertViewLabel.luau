local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local withStyle = UIBlox.Style.withStyle

local v5 = { LEFT = 22, TOP = 5, BOTTOM = 5 }

return function(data)
	local maxSize = data.maxSize
	local layoutOrder = data.layoutOrder
	local text = data.text

	return withStyle(function(props)
		local createElement = Roact.createElement
		local v7 = {
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 32)
		}
		local v8 = {
			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MaxSize = maxSize
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 22),
				PaddingTop = UDim.new(0, 5),
				PaddingBottom = UDim.new(0, 5)
			}),
			Text = 0
		}

		local createElement2 = Roact.createElement
		local v10 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			TextTruncate = 0,
			Text = 0
		}

		local v11 = if not foundationFontFaceMigration then props.Font.Header2.Font else nil
		v10.Font = v11

		local v12 = if foundationFontFaceMigration then normalizeFontFace(props.Tokens.Typography.TitleLarge.Font) else nil
		v10.FontFace = v12

		v10.TextSize = props.Font.BaseSize * props.Font.Header2.RelativeSize
		v10.TextXAlignment = Enum.TextXAlignment.Left
		v10.TextColor3 = props.Theme.TextDefault.Color
		v10.TextTransparency = props.Theme.TextDefault.Transparency
		v10.TextTruncate = Enum.TextTruncate.AtEnd

		v10.Text = text
		v8.Text = createElement2("TextLabel", v10)
		return createElement("Frame", v7, v8)
	end)
end
