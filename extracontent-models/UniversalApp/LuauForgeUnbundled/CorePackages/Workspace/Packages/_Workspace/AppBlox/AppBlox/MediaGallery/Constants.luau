require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/UIBlox")

return {
	getDefaultStyleProps = function(p2)
		return {
			borderRadius = UDim.new(0, p2.Tokens.Radius.Medium),
			contentGap = p2.Tokens.Size.Size_300,
			gutter = p2.Tokens.Size.Size_600,
			titleFont = p2.Font.Header1,
			titleTextColor = {
				Color = p2.Tokens.Color.Content.Emphasis.Color3,
				Transparency = p2.Tokens.Color.Content.Emphasis.Transparency
			}
		}
	end
}
