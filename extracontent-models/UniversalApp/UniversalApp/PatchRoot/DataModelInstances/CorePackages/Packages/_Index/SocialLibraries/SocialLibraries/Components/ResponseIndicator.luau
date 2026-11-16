local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact
local uiBlox = dependencies.UIBlox
local foundation = dependencies.Foundation
local iconSize = foundation.Enums.IconSize

return function()
	return uiBlox.Style.withStyle(function(p)
		return roact.createElement(
			"ImageButton",
			{
				AutoButtonColor = false,
				BackgroundColor3 = p.Theme.TextEmphasis.Color,
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1
			},
			{
				visibleFrame = roact.createElement("Frame", {
					BackgroundTransparency = p.Theme.BackgroundUIContrast.Transparency,
					BackgroundColor3 = p.Theme.BackgroundUIContrast.Color,
					Size = UDim2.fromOffset(120, 120),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					ZIndex = 10
				}, {
					corner = roact.createElement("UICorner"),
					spinner = roact.createElement(foundation.Loading, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = iconSize.Large
					})
				})
			}
		)
	end)
end
