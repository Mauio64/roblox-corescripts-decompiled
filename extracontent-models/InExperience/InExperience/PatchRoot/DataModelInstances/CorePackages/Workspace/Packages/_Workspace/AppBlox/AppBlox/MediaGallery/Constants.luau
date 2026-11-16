local parent = script:FindFirstAncestor("AppBlox").Parent
require(parent.UIBlox)

return {
	getDefaultStyleProps = function(p)
		return {
			borderRadius = UDim.new(0, p.Tokens.Radius.Medium),
			contentGap = p.Tokens.Size.Size_300,
			gutter = p.Tokens.Size.Size_600,
			titleFont = p.Font.Header1,
			titleTextColor = {
				Color = p.Tokens.Color.Content.Emphasis.Color3,
				Transparency = p.Tokens.Color.Content.Emphasis.Transparency
			}
		}
	end
}
