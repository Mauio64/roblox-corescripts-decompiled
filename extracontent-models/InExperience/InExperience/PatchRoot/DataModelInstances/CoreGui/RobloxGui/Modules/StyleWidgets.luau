local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

CoreGui:WaitForChild("RobloxGui")

local Create = require(CorePackages.Workspace.Packages.AppCommonLib).Create
local t1 = {
	TabSelectionHeight = 6
}

function t1.MakeTabSelectionWidget(p1) -- line: 24
	-- upvalues: Create (copy), t1 (copy)
	return (Create("ImageLabel")({
		Name = "TabSelection",
		Image = "rbxasset://textures/ui/Settings/MenuBarAssets/MenuSelection.png",
		Visible = false,
		BackgroundTransparency = 1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(3, 1, 4, 5),
		Size = UDim2.new(1, 0, 0, t1.TabSelectionHeight),
		Position = UDim2.new(0, 0, 1, -t1.TabSelectionHeight),
		Parent = p1
	}))
end

return t1
