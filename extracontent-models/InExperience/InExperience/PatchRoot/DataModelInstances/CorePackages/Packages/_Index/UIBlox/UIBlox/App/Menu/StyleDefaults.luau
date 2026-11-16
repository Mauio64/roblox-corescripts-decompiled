local parent = script.Parent.Parent.Parent

require(parent.App.Style.StyleTypes)
local StyleDefaults = {}

function StyleDefaults.getBaseMenuDefaultTokens(p)
	assert(p.Tokens ~= nil, "Design token support is not enabled!")
	return {
		elementHeight = p.Tokens.Size.Size_1400,
		borderCornerRadius = p.Tokens.Radius.Medium,
		background = {
			Color = p.Tokens.Color.Surface.Surface_300.Color3,
			Transparency = p.Tokens.Color.Surface.Surface_300.Transparency
		}
	}
end

function StyleDefaults.getCellDefaultTokens(p)
	assert(p.Tokens ~= nil, "Design token support is not enabled!")
	return {
		iconSize = p.Tokens.Size.Size_800,
		selectedIconSize = p.Tokens.Size.Size_800,
		iconPaddingLeft = p.Tokens.Size.Size_300,
		textPadding = { left = p.Tokens.Size.Size_300, right = p.Tokens.Size.Size_300 },
		fontStyle = {
			Font = p.Tokens.Typography.TitleLarge.Font,
			RelativeSize = p.Tokens.Typography.TitleLarge.FontSize / p.Font.BaseSize,
			RelativeMinSize = p.Tokens.Typography.TitleLarge.FontSize / p.Font.BaseSize
		},
		dividerSize = p.Tokens.Stroke.Standard,
		selectedIconPaddingRight = p.Tokens.Size.Size_300
	}
end

function StyleDefaults.getDropdownMenuCellDefaultTokens(p)
	return {
		iconSize = p.Tokens.Size.Size_900,
		containerPadding = { left = p.Tokens.Size.Size_400, right = p.Tokens.Size.Size_600 },
		textFont = p.Tokens.Typography.TitleLarge,
		iconTextSpacing = p.Tokens.Size.Size_400,
		border = { cornerRadius = p.Tokens.Radius.Medium, size = p.Tokens.Stroke.Standard }
	}
end

function StyleDefaults.getDropdownMenuDefaultTokens(p)
	return {
		height = UDim.new(0, p.Tokens.Size.Size_1200),
		menuStateColors = {
			buttonDefault = {
				Color = p.Tokens.Color.ActionSubtle.Border.Color3,
				Transparency = p.Tokens.Color.ActionSubtle.Border.Transparency
			},
			contentDefault = {
				Color = p.Tokens.Color.Content.Default.Color3,
				Transparency = p.Tokens.Color.Content.Default.Transparency
			},
			alert = {
				Color = p.Tokens.Color.ActionAlert.Border.Color3,
				Transparency = p.Tokens.Color.ActionAlert.Border.Transparency
			}
		}
	}
end

return StyleDefaults
