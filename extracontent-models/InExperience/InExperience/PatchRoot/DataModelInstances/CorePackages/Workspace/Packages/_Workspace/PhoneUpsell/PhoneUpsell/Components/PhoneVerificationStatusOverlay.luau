local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Colors = UIBlox.App.Style.Colors

local function PhoneVerificationStatusOverlay(p)
	local v = useStyle()
	local createElement = React.createElement
	local v2 = {
		BackgroundTransparency = 0.3,
		BackgroundColor3 = Colors.Black,
		Size = UDim2.new(1, 0, 1, 0)
	}

	local createElement2 = React.createElement
	local v3 = { Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 }

	local v4 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 24)
		}),
		Image = p.image,
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v.Tokens.Size.Size_600),
			PaddingRight = UDim.new(0, v.Tokens.Size.Size_600)
		}),
		VerifyingText = 0
	}

	local createElement3 = React.createElement
	local v5 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = v.Font.BaseSize * v.Font.Header1.RelativeSize,
		TextColor3 = Colors.White,
		Text = p.text,
		Font = 0,
		FontFace = 0,
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		TextWrapped = true
	}
	local font

	if not FoundationFontFaceMigration then
		font = v.Font.Header1.Font
	end

	v5.Font = font
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(v.Tokens.Typography.HeadingSmall.Font)
	end

	v5.FontFace = fontFace
	v4.VerifyingText = createElement3("TextLabel", v5)
	return createElement("Frame", v2, {
		MiddleContent = createElement2("Frame", v3, v4)
	})
end

return PhoneVerificationStatusOverlay
