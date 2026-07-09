local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useStyle = UIBlox.Core.Style.useStyle
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Interactable = UIBlox.Core.Control.Interactable
local Images = UIBlox.App.ImageSet.Images

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local uDim2 = UDim2.new(0, 44, 0, 44)
local uDim2_2 = UDim2.new(0, 37, 0, 37)
local v13 = Images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)

return React.forwardRef(function(t1: {[any]: any}, p1) -- line: 27
	-- upvalues: useStyle (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Focusable (copy), Interactable (copy), uDim2 (copy), v13 (copy), rect (copy), ImageSetLabel (copy), uDim2_2 (copy)
	local Theme = useStyle().Theme
	local onActivated = t1.onActivated
	local BackgroundDefaultTransparency = Theme.BackgroundDefault.Transparency
	local v20 = useSelectionCursor(CursorKind.RoundedRectNoInset)
	local icon = t1.icon

	return React.createElement(Focusable[Interactable], {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = uDim2,
		Image = v13,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = BackgroundDefaultTransparency,
		ImageColor3 = Theme.BackgroundDefault.Color,
		LayoutOrder = 2,
		ClipsDescendants = false,
		[React.Event.Activated] = onActivated,
		NextSelectionRight = t1.NextSelectionRight,
		NextSelectionLeft = t1.NextSelectionLeft,
		ref = p1,
		SelectionImageObject = v20
	}, {
		Icon = React.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = uDim2_2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = icon,
			ImageTransparency = Theme.IconEmphasis.Transparency,
			ImageColor3 = Theme.IconEmphasis.Color
		})
	})
end)
