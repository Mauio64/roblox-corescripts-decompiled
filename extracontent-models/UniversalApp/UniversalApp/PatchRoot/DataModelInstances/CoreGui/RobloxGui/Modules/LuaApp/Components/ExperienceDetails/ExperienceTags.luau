local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens

return function(t1: {[any]: any}) -- line: 19
	-- upvalues: useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy)
	local v6 = useDesignTokens()
	local v7 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Global.Size_450 else v6.Size.Size_900
	local v8 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Global.Space_200 else v6.Size.Size_400
	local v9 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Semantic.Typography.Subheader.Font else v6.Typography.TitleLarge.Font
	local v10 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Global.FontSize_75 else v6.FontSize.FontSize_350
	local v11 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Semantic.Color.Text.Emphasis else v6.Color.Content.Emphasis
	local v12 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Semantic.Color.Background.OnHover else v6.Color.State.Hover
	local v13, v14 = React.useBinding(1e999)
	local v15 = if not FFlagRenameDeprecatedUIBloxTokens then v6.Global.Space_100 else v6.Size.Size_200
	local t2 = {}

	for v17, v18 in t1.contents do
		t2["Pill" .. v17] = (function(t3: {[any]: any}) -- line: 46
			-- upvalues: React (copy), v7 (copy), v12 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v13 (copy)
			return React.createElement("TextButton", {
				Size = UDim2.fromOffset(0, v7),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = v12.Color3,
				BackgroundTransparency = v12.Transparency,
				BorderSizePixel = 0,
				Text = "",
				Interactable = not not t3.onActivated,
				[React.Event.Activated] = t3.onActivated
			}, {
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				Padding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v8),
					PaddingRight = UDim.new(0, v8)
				}),
				TextLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					Text = t3.text,
					Font = v9,
					TextSize = v10,
					TextColor3 = v11.Color3,
					TextTransparency = v11.Transparency,
					TextTruncate = Enum.TextTruncate.AtEnd
				}, {
					UISizeConstraint = React.createElement("UISizeConstraint", {
						MaxSize = v13:map(function(p1) -- line: 76
							return Vector2.new(p1, 1e999)
						end)
					})
				})
			})
		end)(v18)
	end

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = t1.LayoutOrder,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p2) -- line: 42
			-- upvalues: v14 (copy)
			v14(p2.AbsoluteSize.X)
		end
	}, {
		ListLayout = React.createElement("UIListLayout", {
			Wraps = true,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v15)
		}),
		Pills = React.createElement(React.Fragment, {}, t2)
	})
end
