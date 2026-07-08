local Parent = script:FindFirstAncestor("GameTile").Parent
local Foundation = require(Parent.Foundation)
local GetTextSize = require(Parent.Style).GetTextSize
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local React = require(Parent.React)
local useTokens = Foundation.Hooks.useTokens
local t1 = {}

local function GameTileOverlayBadge(t2: {[any]: any}) -- line: 35
	-- upvalues: t1 (copy), useTokens (copy), React (copy), GetTextSize (copy), Icon (copy), IconSize (copy)
	local v11 = t2.icons or t1
	local v12 = t2.text or ""
	local v13 = #v11 > 0
	local v14 = #v12 > 0
	local v15 = useTokens()
	local v16 = if not t2.styleOptions then v15.Color.Extended.White.White_90 else t2.styleOptions.backgroundColorStyle or v15.Color.Extended.White.White_90
	local v17 = if not t2.styleOptions then v15.LightMode.Content.Emphasis else t2.styleOptions.contentColorStyle or v15.LightMode.Content.Emphasis
	local v18 = t2.styleOptions and t2.styleOptions.cornerRadius or UDim.new(1, 0)
	local v19 = if not v14 and not (#v11 > 1) then v15.Size.Size_150 else v15.Size.Size_200
	local v20 = if not t2.styleOptions then v15.Size.Size_150 else t2.styleOptions.verticalPadding or v15.Size.Size_150
	local XSmall = v15.Padding.XSmall
	local TitleSmall = v15.Typography.TitleSmall
	local Size_400 = v15.Size.Size_400
	local v24 = React.useMemo(function() -- line: 60
		-- upvalues: v14 (copy), GetTextSize (copy), v12 (copy), TitleSmall (copy)
		if v14 then
			return (GetTextSize(v12, TitleSmall.FontSize, TitleSmall.Font, Vector2.new(1e999, 1e999)))
		end

		return (Vector2.new(0, 0))
	end, {
		v12,
		v14,
		TitleSmall.FontSize,
		TitleSmall.Font
	})

	if not v14 and not v13 then
		return nil
	end

	local t3 = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v20),
			PaddingLeft = UDim.new(0, v19),
			PaddingBottom = UDim.new(0, v20),
			PaddingRight = UDim.new(0, v19)
		}),
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, XSmall)
		})
	}
	local n1 = 0

	for v27, v28 in v11 do
		t3[`Icon{ v27 }`] = React.createElement(Icon, {
			LayoutOrder = v27,
			name = v28,
			size = IconSize.Small,
			style = v17
		})
		n1 += Size_400 + XSmall
	end

	if v14 then
		t3.BadgeText = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			LayoutOrder = #v11 + 1,
			Size = UDim2.fromOffset(v24.X, v24.Y),
			Text = v12,
			TextColor3 = v17.Color3,
			Font = TitleSmall.Font,
			TextSize = TitleSmall.FontSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = t2.maxWidthBinding:map(function(n2: number) -- line: 114
					-- upvalues: v19 (copy), n1 (ref)
					local v30 = n2 - 2 * v19 - n1

					if v30 > 0 then
						return (Vector2.new(v30, 1e999))
					end

					return nil
				end)
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundColor3 = v16.Color3,
		BackgroundTransparency = v16.Transparency,
		Position = t2.Position,
		AnchorPoint = t2.AnchorPoint,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = v18
		}),
		BadgeContent = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, t3)
	})
end

return React.memo(GameTileOverlayBadge)
