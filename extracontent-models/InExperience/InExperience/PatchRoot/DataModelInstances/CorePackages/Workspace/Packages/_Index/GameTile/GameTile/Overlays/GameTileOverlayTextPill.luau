local parent = script:FindFirstAncestor("GameTile").Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Style = require(parent.Style)
local Colors = Style.Colors
local LightTheme = Style.Themes.LightTheme
local GetTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens

local function GameTileOverlayTextPill(props)
	if not props.text or string.len(props.text) == 0 then
		return nil
	end

	local v = useDesignTokens()

	local size_200 = v.Size.Size_200
	local size_150 = v.Size.Size_150

	local font = v.Typography.HeadingLarge.Font
	local fontSize_300 = v.FontSize.FontSize_300

	local v2 = React.useMemo(function()
		return GetTextSize(props.text, fontSize_300, font, Vector2.new(1e999, 1e999))
	end, { props.text, fontSize_300, font })

	local createElement = React.createElement
	local v3 = {
		BackgroundColor3 = Colors.White,
		BackgroundTransparency = 0.1,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		AutomaticSize = Enum.AutomaticSize.XY
	}
	local v4 = {
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) }),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, size_150),
			PaddingLeft = UDim.new(0, size_200),
			PaddingBottom = UDim.new(0, size_150),
			PaddingRight = UDim.new(0, size_200)
		}),
		TextLabel = 0
	}

	local createElement2 = React.createElement
	local v5 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(v2.X, v2.Y),
		Text = props.text,
		TextColor3 = LightTheme.TextEmphasis.Color3,
		Font = 0,
		FontFace = 0,
		TextSize = 0,
		TextXAlignment = 0,
		TextYAlignment = 0,
		TextWrapped = false,
		TextTruncate = 0
	}
	local font2

	if not FoundationFontFaceMigration then
		font2 = font
	end

	v5.Font = font2
	local fontFace

	if FoundationFontFaceMigration then
		fontFace = normalizeFontFace(font)
	end

	v5.FontFace = fontFace
	v5.TextSize = fontSize_300
	v5.TextXAlignment = Enum.TextXAlignment.Center
	v5.TextYAlignment = Enum.TextYAlignment.Center

	v5.TextTruncate = Enum.TextTruncate.AtEnd
	v4.TextLabel = createElement2("TextLabel", v5, {
		UISizeConstraint = React.createElement("UISizeConstraint", {
			MaxSize = props.maxWidthBinding:map(function(p: number)
				local v6 = p - size_200 * 2

				if v6 > 0 then
					return (Vector2.new(v6, v2.Y))
				end

				return nil
			end)
		})
	})
	return createElement("Frame", v3, v4)
end

return GameTileOverlayTextPill
