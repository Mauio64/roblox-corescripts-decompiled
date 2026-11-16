local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

return {
	CreateShadow = function(value)
		return Create("ImageLabel")({
			Name = "Shadow",
			Image = "rbxasset://textures/ui/Shell/Buttons/Generic9ScaleShadow.png",
			Size = UDim2.new(1, 3, 1, 3),
			Position = UDim2.new(0, 0, 0, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(10, 10, 28, 28),
			BackgroundTransparency = 1,
			ZIndex = value or 1
		})
	end
}
