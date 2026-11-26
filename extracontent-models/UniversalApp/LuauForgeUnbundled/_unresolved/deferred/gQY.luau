local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useStyle = UIBlox.Core.Style.useStyle
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local interactable = UIBlox.Core.Control.Interactable
local images = UIBlox.App.ImageSet.Images
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local udim = UDim2.new(0, 44, 0, 44)
local udim2 = UDim2.new(0, 37, 0, 37)
local component_assetscircle_17 = images["component_assets/circle_17"]
local rect = Rect.new(8, 8, 9, 9)

return React.forwardRef(function(props, ref)
	local theme = useStyle().Theme
	local onActivated = props.onActivated
	local transparency = theme.BackgroundDefault.Transparency
	local v5 = useSelectionCursor(cursorKind.RoundedRectNoInset)
	local icon = props.icon

	return React.createElement(focusable[interactable], {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		Size = udim,
		Image = component_assetscircle_17,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = rect,
		ImageTransparency = transparency,
		ImageColor3 = theme.BackgroundDefault.Color,
		LayoutOrder = 2,
		ClipsDescendants = false,
		[React.Event.Activated] = onActivated,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionLeft = props.NextSelectionLeft,
		ref = ref,
		SelectionImageObject = v5
	}, {
		Icon = React.createElement(imageSetLabel, {
			Size = udim2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Image = icon,
			ImageTransparency = theme.IconEmphasis.Transparency,
			ImageColor3 = theme.IconEmphasis.Color
		})
	})
end)
