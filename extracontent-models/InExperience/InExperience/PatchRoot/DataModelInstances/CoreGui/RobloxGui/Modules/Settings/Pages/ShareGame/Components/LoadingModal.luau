local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local AppBlox = require(CorePackages.Workspace.Packages.AppBlox)
local LoadingBar = AppBlox.LoadingBar

local color = Color3.fromRGB(41, 41, 41)

return function()
	return Roact.createElement("Frame", {
		Size = UDim2.new(0, 160, 0, 160),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.1
	}, { Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }), Roact.createElement(LoadingBar) })
end
