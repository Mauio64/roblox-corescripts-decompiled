local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local IconButton = UIBlox.App.Button.IconButton
local useStyle = UIBlox.Core.Style.useStyle
local IconSize = UIBlox.App.Constant.IconSize
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local ColorGradientCircle = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Components.ColorGradientCircle
local v13 = game:DefineFastFlag("AXFixColorAdjustmentQuickButtonSize", false)
local FFlagAXMigrateQuickButtonsToGlobalAutoFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateQuickButtonsToGlobalAutoFocus
local uDim = UDim.new(0, 8)
local uDim2 = UDim.new(0, 4)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 40
	-- upvalues: useTokens (copy), useStyle (copy), useSelectionCursor (copy), CursorKind (copy), v13 (copy), React (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), Focusable (copy), uDim (copy), ImageSetButton (copy), IconSize (copy), uDim2 (copy), ColorGradientCircle (copy), IconButton (copy)
	local v19 = useTokens()
	local v20 = useStyle()
	local v21 = useSelectionCursor(CursorKind.RoundedRect)
	local Theme = v20.Theme
	local v23 = if not v13 then nil else React.useRef(nil)

	if v13 then
		return React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable.Frame else "Frame", {
			Size = UDim2.fromOffset(44, 44),
			BackgroundColor3 = Theme.BackgroundMuted.Color,
			BackgroundTransparency = Theme.BackgroundMuted.Transparency,
			LayoutOrder = t1.LayoutOrder,
			ref = p1,
			defaultChild = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v23 else nil
		}, {
			Corner = React.createElement("UICorner", {
				CornerRadius = uDim
			}),
			Button = React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable[ImageSetButton] else ImageSetButton, {
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
				BackgroundTransparency = 1,
				[React.Event.Activated] = t1.onActivated,
				ref = v23,
				NextSelectionUp = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionUp else nil,
				NextSelectionDown = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionDown else nil,
				NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionLeft else nil,
				NextSelectionRight = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionRight else nil,
				SelectionImageObject = v21
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = uDim2,
					PaddingBottom = uDim2,
					PaddingLeft = uDim2,
					PaddingRight = uDim2
				}),
				Color = React.createElement(ColorGradientCircle, {
					Size = UDim2.fromScale(1, 1),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Colors = t1.colors
				})
			})
		})
	end

	return React.createElement(IconButton, {
		showBackground = true,
		position = UDim2.fromScale(0.5, 0.5),
		anchorPoint = Vector2.new(0.5, 0.5),
		layoutOrder = t1.LayoutOrder,
		iconSize = IconSize.Medium,
		onActivated = t1.onActivated,
		backgroundColor = Theme.BackgroundUIDefault,
		buttonRef = p1,
		NextSelectionUp = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionUp else nil,
		NextSelectionDown = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionDown else nil,
		NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionLeft else nil,
		NextSelectionRight = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionRight else nil
	}, {
		Color = React.createElement(ColorGradientCircle, {
			Size = UDim2.fromOffset(v19.Size.Size_700, v19.Size.Size_700),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Colors = t1.colors
		})
	})
end))
