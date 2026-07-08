local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local LoadingBar = require(CorePackages.Workspace.Packages.AppBlox).LoadingBar
local color3 = Color3.fromRGB(41, 41, 41)

return function() -- line: 9
	-- upvalues: Roact (copy), color3 (copy), LoadingBar (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 0.1,
		Size = UDim2.new(0, 160, 0, 160),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color3
	}, {
		Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 4)
		}),
		Roact.createElement(LoadingBar)
	})
end
