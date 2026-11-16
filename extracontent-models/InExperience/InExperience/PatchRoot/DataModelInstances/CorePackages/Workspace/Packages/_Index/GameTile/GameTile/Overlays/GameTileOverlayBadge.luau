local parent = script:FindFirstAncestor("GameTile").Parent
local Foundation = require(parent.Foundation)
local Style = require(parent.Style)
local GetTextSize = Style.GetTextSize
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require(parent.React)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useTokens = Foundation.Hooks.useTokens

local v = {}

local function GameTileOverlayBadge(props)
	local icons = props.icons or v
	local text = props.text or ""

	local v2 = #icons > 0
	local v3 = #text > 0

	local v4 = useTokens()
	local v5

	if props.styleOptions then
		v5 = props.styleOptions.backgroundColorStyle or v4.Color.Extended.White.White_90
	else
		v5 = v4.Color.Extended.White.White_90
	end

	local style

	if props.styleOptions then
		style = props.styleOptions.contentColorStyle or v4.LightMode.Content.Emphasis
	else
		style = v4.LightMode.Content.Emphasis
	end

	local cornerRadius = props.styleOptions and props.styleOptions.cornerRadius or UDim.new(1, 0)
	local v6

	if v3 or #icons > 1 then
		v6 = v4.Size.Size_200
	else
		v6 = v4.Size.Size_150
	end

	local v7

	if props.styleOptions then
		v7 = props.styleOptions.verticalPadding or v4.Size.Size_150
	else
		v7 = v4.Size.Size_150
	end

	local xSmall = v4.Padding.XSmall
	local titleSmall = v4.Typography.TitleSmall
	local size_400 = v4.Size.Size_400

	local v8 = React.useMemo(function()
		if v3 then
			return (GetTextSize(text, titleSmall.FontSize, titleSmall.Font, Vector2.new(1e999, 1e999)))
		end

		return (Vector2.new(0, 0))
	end, { text, v3, titleSmall.FontSize, titleSmall.Font })

	if not (v3 or v2) then
		return nil
	end

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v7),
			PaddingLeft = UDim.new(0, v6),
			PaddingBottom = UDim.new(0, v7),
			PaddingRight = UDim.new(0, v6)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, xSmall)
		})
	}
	local total = 0

	for k, icon in icons do
		children[`Icon{k}`] = React.createElement(Icon, {
			LayoutOrder = k,
			name = icon,
			size = IconSize.Small,
			style = style
		})

		total += size_400 + xSmall
	end

	if v3 then
		local createElement = React.createElement
		local v9 = {
			LayoutOrder = #icons + 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v8.X, v8.Y),
			Text = text,
			TextColor3 = style.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = false,
			TextTruncate = 0
		}
		local font

		if not FoundationFontFaceMigration then
			font = titleSmall.Font
		end

		v9.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(titleSmall.Font)
		end

		v9.FontFace = fontFace
		v9.TextSize = titleSmall.FontSize
		v9.TextXAlignment = Enum.TextXAlignment.Left
		v9.TextYAlignment = Enum.TextYAlignment.Center

		v9.TextTruncate = Enum.TextTruncate.AtEnd
		children.BadgeText = createElement("TextLabel", v9, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = props.maxWidthBinding:map(function(p: number)
					local v10 = p - 2 * v6 - total

					if v10 > 0 then
						return (Vector2.new(v10, 1e999))
					end

					return nil
				end)
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundColor3 = v5.Color3,
		BackgroundTransparency = v5.Transparency,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Corner = React.createElement("UICorner", { CornerRadius = cornerRadius }),
		BadgeContent = React.createElement(
			"Frame",
			{ BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.XY },
			children
		)
	})
end

return React.memo(GameTileOverlayBadge)
