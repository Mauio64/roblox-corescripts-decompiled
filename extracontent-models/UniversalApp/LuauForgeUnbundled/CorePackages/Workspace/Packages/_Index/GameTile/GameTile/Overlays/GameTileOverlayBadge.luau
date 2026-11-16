local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Foundation")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/Style").GetTextSize
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameTile/React")
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local useTokens = Foundation.Hooks.useTokens

local v5 = {}

local function GameTileOverlayBadge(props)
	local icons = props.icons or v5
	local text = props.text or ""

	local v6 = #icons > 0
	local v7 = #text > 0

	local v8 = useTokens()
	local v9

	if props.styleOptions then
		v9 = props.styleOptions.backgroundColorStyle or v8.Color.Extended.White.White_90
	else
		v9 = v8.Color.Extended.White.White_90
	end

	local v10

	if props.styleOptions then
		v10 = props.styleOptions.contentColorStyle or v8.LightMode.Content.Emphasis
	else
		v10 = v8.LightMode.Content.Emphasis
	end

	local cornerRadius = props.styleOptions and props.styleOptions.cornerRadius or UDim.new(1, 0)

	local v11 = if v7 or #icons > 1 then v8.Size.Size_200 else v8.Size.Size_150
	local v12

	if props.styleOptions then
		v12 = props.styleOptions.verticalPadding or v8.Size.Size_150
	else
		v12 = v8.Size.Size_150
	end

	local xSmall = v8.Padding.XSmall
	local titleSmall = v8.Typography.TitleSmall
	local size_400 = v8.Size.Size_400

	local v13 = React.useMemo(function()
		if v7 then
			return (getTextSize(text, titleSmall.FontSize, titleSmall.Font, Vector2.new(1e999, 1e999)))
		end

		return (Vector2.new(0, 0))
	end, { text, v7, titleSmall.FontSize, titleSmall.Font })

	if not (v7 or v6) then
		return nil
	end

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v12),
			PaddingLeft = UDim.new(0, v11),
			PaddingBottom = UDim.new(0, v12),
			PaddingRight = UDim.new(0, v11)
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

	for k, icon2 in icons do
		children[`Icon{k}`] = React.createElement(icon, {
			LayoutOrder = k,
			name = icon2,
			size = iconSize.Small,
			style = v10
		})

		total += size_400 + xSmall
	end

	if v7 then
		local createElement = React.createElement
		local v15 = {
			LayoutOrder = #icons + 1,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v13.X, v13.Y),
			Text = text,
			TextColor3 = v10.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextWrapped = false,
			TextTruncate = 0
		}
		local v16 = if not foundationFontFaceMigration then titleSmall.Font else nil
		v15.Font = v16
		local v17 = if foundationFontFaceMigration then normalizeFontFace(titleSmall.Font) else nil
		v15.FontFace = v17
		v15.TextSize = titleSmall.FontSize
		v15.TextXAlignment = Enum.TextXAlignment.Left
		v15.TextYAlignment = Enum.TextYAlignment.Center

		v15.TextTruncate = Enum.TextTruncate.AtEnd
		children.BadgeText = createElement("TextLabel", v15, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = props.maxWidthBinding:map(function(p2)
					local v18 = p2 - 2 * v11 - total

					if v18 > 0 then
						return (Vector2.new(v18, 1e999))
					end

					return nil
				end)
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundColor3 = v9.Color3,
		BackgroundTransparency = v9.Transparency,
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
