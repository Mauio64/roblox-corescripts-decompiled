local ParentParent = script.Parent.Parent.Parent

require(ParentParent.App.Style.StyleTypes)

return {
	getBaseMenuDefaultTokens = function(p1) -- line: 27
		assert(p1.Tokens ~= nil, "Design token support is not enabled!")

		return {
			elementHeight = p1.Tokens.Component.MenuCell.Base.Container.Height,
			borderCornerRadius = p1.Tokens.Component.BaseMenu.BorderRadius,
			background = {
				Color = p1.Tokens.Component.BaseMenu.BackgroundColor.Color3,
				Transparency = p1.Tokens.Component.BaseMenu.BackgroundColor.Transparency
			}
		}
	end,
	getCellDefaultTokens = function(p2) -- line: 7
		assert(p2.Tokens ~= nil, "Design token support is not enabled!")

		return {
			iconSize = p2.Tokens.Component.MenuCell.Base.IconFrame.Size,
			selectedIconSize = p2.Tokens.Component.MenuCell.Base.CheckFrame.Size,
			iconPaddingLeft = p2.Tokens.Component.MenuCell.Base.Container.Spacing.Leading,
			textPadding = {
				left = p2.Tokens.Component.MenuCell.Base.TextFrame.Spacing.Leading,
				right = p2.Tokens.Component.MenuCell.Base.TextFrame.Spacing.Trailing
			},
			fontStyle = {
				Font = p2.Tokens.Component.MenuCell.Base.Text.Typography.Font,
				RelativeSize = p2.Tokens.Component.MenuCell.Base.Text.Typography.FontSize / p2.Font.BaseSize,
				RelativeMinSize = p2.Tokens.Component.MenuCell.Base.Text.Typography.FontSize / p2.Font.BaseSize
			},
			dividerSize = p2.Tokens.Component.MenuCell.Divider.Container.BorderWidth,
			selectedIconPaddingRight = p2.Tokens.Component.MenuCell.Base.Container.Spacing.Trailing
		}
	end,
	getDropdownMenuCellDefaultTokens = function(p3) -- line: 39
		return {
			iconSize = p3.Tokens.Global.Size_450,
			containerPadding = {
				left = p3.Tokens.Global.Space_200,
				right = p3.Tokens.Global.Space_300
			},
			textFont = p3.Tokens.Semantic.Typography.Subheader,
			iconTextSpacing = p3.Tokens.Global.Space_200,
			border = {
				cornerRadius = p3.Tokens.Semantic.Radius.Medium,
				size = p3.Tokens.Global.Stroke_100
			}
		}
	end,
	getDropdownMenuDefaultTokens = function(p4) -- line: 55
		return {
			height = UDim.new(0, p4.Tokens.Global.Size_600),
			menuStateColors = {
				buttonDefault = {
					Color = p4.Tokens.Semantic.Color.Action.Secondary.Border.Color3,
					Transparency = p4.Tokens.Semantic.Color.Action.Secondary.Border.Transparency
				},
				contentDefault = {
					Color = p4.Tokens.Semantic.Color.Text.Default.Color3,
					Transparency = p4.Tokens.Semantic.Color.Text.Default.Transparency
				},
				alert = {
					Color = p4.Tokens.Semantic.Color.Action.Alert.Border.Color3,
					Transparency = p4.Tokens.Semantic.Color.Action.Alert.Border.Transparency
				}
			}
		}
	end
}
