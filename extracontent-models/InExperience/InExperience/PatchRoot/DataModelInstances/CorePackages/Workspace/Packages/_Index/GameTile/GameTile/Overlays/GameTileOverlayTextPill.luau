local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)
local Style = require(Parent.Style)
local Colors = Style.Colors
local LightTheme = Style.Themes.LightTheme
local GetTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens

local function GameTileOverlayTextPill(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), React (copy), GetTextSize (copy), Colors (copy), LightTheme (copy)
	if not t1.text or string.len(t1.text) == 0 then
		return nil
	end

	local v10 = useDesignTokens()
	local Size_200 = v10.Size.Size_200
	local Size_150 = v10.Size.Size_150
	local HeadingLargeFont = v10.Typography.HeadingLarge.Font
	local FontSize_300 = v10.FontSize.FontSize_300
	local v15 = React.useMemo(function() -- line: 32
		-- upvalues: GetTextSize (copy), t1 (copy), FontSize_300 (copy), HeadingLargeFont (copy)
		return GetTextSize(t1.text, FontSize_300, HeadingLargeFont, Vector2.new(1e999, 1e999))
	end, {
		t1.text,
		FontSize_300,
		HeadingLargeFont
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 0.1,
		BackgroundColor3 = Colors.White,
		Position = t1.Position,
		AnchorPoint = t1.AnchorPoint,
		AutomaticSize = Enum.AutomaticSize.XY
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, Size_150),
			PaddingLeft = UDim.new(0, Size_200),
			PaddingBottom = UDim.new(0, Size_150),
			PaddingRight = UDim.new(0, Size_200)
		}),
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			Size = UDim2.fromOffset(v15.X, v15.Y),
			Text = t1.text,
			TextColor3 = LightTheme.TextEmphasis.Color3,
			Font = HeadingLargeFont,
			TextSize = FontSize_300,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = t1.maxWidthBinding:map(function(n1: number) -- line: 65
					-- upvalues: Size_200 (copy), v15 (copy)
					local v17 = n1 - Size_200 * 2

					if v17 > 0 then
						return (Vector2.new(v17, v15.Y))
					end

					return nil
				end)
			})
		})
	})
end

return GameTileOverlayTextPill
