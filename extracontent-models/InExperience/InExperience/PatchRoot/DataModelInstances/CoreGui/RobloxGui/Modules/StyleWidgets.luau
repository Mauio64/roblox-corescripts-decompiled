local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
CoreGui:WaitForChild("RobloxGui")

local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local Create = AppCommonLib.Create

local StyleWidgets = {}
StyleWidgets.TabSelectionHeight = 6

function StyleWidgets.MakeTabSelectionWidget(parent)
	return (Create("ImageLabel")({
		Name = "TabSelection",
		Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuSelection.png",
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3, 1, 4, 5),
		Visible = false,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, StyleWidgets.TabSelectionHeight),
		Position = UDim2.new(0, 0, 1, -StyleWidgets.TabSelectionHeight),
		Parent = parent
	}))
end

return StyleWidgets
