local scriptParent = script.Parent
local Colors = require(scriptParent.Colors)

local function getSelectionImageObjectRounded() -- line: 4
	-- upvalues: Colors (copy)
	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Image = "rbxasset://textures/ui/InspectMenu/selection_rounded.png"
	ImageLabel.ImageColor3 = Colors.White
	ImageLabel.ScaleType = Enum.ScaleType.Slice
	ImageLabel.SliceCenter = Rect.new(5, 5, 120, 20)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Size = UDim2.new(1, 0, 1, 0)

	return ImageLabel
end

return getSelectionImageObjectRounded
