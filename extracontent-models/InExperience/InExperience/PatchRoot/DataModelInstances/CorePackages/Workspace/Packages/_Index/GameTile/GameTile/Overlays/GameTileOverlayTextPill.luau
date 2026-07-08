local Parent = script:FindFirstAncestor("GameTile").Parent
local React = require(Parent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(Parent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Style = require(Parent.Style)
local Colors = Style.Colors
local LightTheme = Style.Themes.LightTheme
local GetTextSize = Style.GetTextSize
local useDesignTokens = Style.useDesignTokens

local function GameTileOverlayTextPill(t1: {[any]: any}) -- line: 21
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), GetTextSize (copy), Colors (copy), LightTheme (copy)
	if not t1.text or string.len(t1.text) == 0 then
		return nil
	end

	local v11 = useDesignTokens()
	local v12 = if not FFlagRenameDeprecatedUIBloxTokens then v11.Global.Space_100 else v11.Size.Size_200
	local v13 = if not FFlagRenameDeprecatedUIBloxTokens then v11.Global.Space_75 else v11.Size.Size_150
	local v14 = if not FFlagRenameDeprecatedUIBloxTokens then v11.Semantic.Typography.Title.Font else v11.Typography.HeadingLarge.Font
	local v15 = if not FFlagRenameDeprecatedUIBloxTokens then v11.Semantic.Typography.CaptionHeader.FontSize else v11.FontSize.FontSize_300
	local v16 = React.useMemo(function() -- line: 46
		-- upvalues: GetTextSize (copy), t1 (copy), v15 (copy), v14 (copy)
		return GetTextSize(t1.text, v15, v14, Vector2.new(1e999, 1e999))
	end, {
		t1.text,
		v15,
		v14
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
			PaddingTop = UDim.new(0, v13),
			PaddingLeft = UDim.new(0, v12),
			PaddingBottom = UDim.new(0, v13),
			PaddingRight = UDim.new(0, v12)
		}),
		TextLabel = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			TextWrapped = false,
			Size = UDim2.fromOffset(v16.X, v16.Y),
			Text = t1.text,
			TextColor3 = LightTheme.TextEmphasis.Color3,
			Font = v14,
			TextSize = v15,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, {
			UISizeConstraint = React.createElement("UISizeConstraint", {
				MaxSize = t1.maxWidthBinding:map(function(n1: number) -- line: 79
					-- upvalues: v12 (copy), v16 (copy)
					local v18 = n1 - v12 * 2

					if v18 > 0 then
						return (Vector2.new(v18, v16.Y))
					end

					return nil
				end)
			})
		})
	})
end

return GameTileOverlayTextPill
