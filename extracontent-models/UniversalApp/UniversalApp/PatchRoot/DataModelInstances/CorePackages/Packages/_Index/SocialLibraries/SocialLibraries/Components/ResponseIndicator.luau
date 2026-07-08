local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local Roact = dependencies.Roact
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local IconSize = Foundation.Enums.IconSize

return function() -- line: 8
	-- upvalues: UIBlox (copy), Roact (copy), Foundation (copy), IconSize (copy)
	return UIBlox.Style.withStyle(function(p1) -- line: 9
		-- upvalues: Roact (copy), Foundation (copy), IconSize (copy)
		return Roact.createElement("ImageButton", {
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			BackgroundColor3 = p1.Theme.TextEmphasis.Color,
			Size = UDim2.fromScale(1, 1)
		}, {
			visibleFrame = Roact.createElement("Frame", {
				ZIndex = 10,
				BackgroundTransparency = p1.Theme.BackgroundUIContrast.Transparency,
				BackgroundColor3 = p1.Theme.BackgroundUIContrast.Color,
				Size = UDim2.fromOffset(120, 120),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5)
			}, {
				corner = Roact.createElement("UICorner"),
				spinner = Roact.createElement(Foundation.Loading, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = IconSize.Large
				})
			})
		})
	end)
end
