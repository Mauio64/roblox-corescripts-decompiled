local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

CoreGui:FindFirstChild("RobloxGui"):FindFirstChild("Modules"):FindFirstChild("Shell")

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create

return {
	CreateShadow = function(p1) -- line: 14
		-- upvalues: Create (copy)
		return Create("ImageLabel")({
			Name = "Shadow",
			Image = "rbxasset://textures/ui/Shell/Buttons/Generic9ScaleShadow.png",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 3, 1, 3),
			Position = UDim2.new(0, 0, 0, 0),
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(10, 10, 28, 28),
			ZIndex = p1 or 1
		})
	end
}
