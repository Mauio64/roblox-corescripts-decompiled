local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local useStyle = UIBlox.Core.Style.useStyle
local IconSize = UIBlox.App.Constant.IconSize
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local usePulseAnimationBinding = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.usePulseAnimationBinding
local FFlagAXMigrateQuickButtonsToGlobalAutoFocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateQuickButtonsToGlobalAutoFocus
local v14 = Images["icons/menu/transform"]
local uDim = UDim.new(0, 8)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 41
	-- upvalues: useStyle (copy), FFlagAXMigrateQuickButtonsToGlobalAutoFocus (copy), React (copy), useTokens (copy), useSelectionCursor (copy), CursorKind (copy), usePulseAnimationBinding (copy), Focusable (copy), uDim (copy), ImageSetButton (copy), IconSize (copy), v14 (copy)
	local Theme = useStyle().Theme
	local v19 = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then React.useRef(nil) else nil
	local v20 = useTokens()
	local v21 = useSelectionCursor(CursorKind.RoundedRect)
	local v22 = usePulseAnimationBinding(t1.enableFocusAnimation)

	return React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable.Frame else "Frame", {
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = Theme.BackgroundMuted.Color,
		BackgroundTransparency = Theme.BackgroundMuted.Transparency,
		LayoutOrder = t1.LayoutOrder,
		ref = p1,
		defaultChild = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v19 else nil
	}, {
		Corner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		Button = React.createElement(if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then Focusable[ImageSetButton] else ImageSetButton, {
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromOffset(IconSize.Regular, IconSize.Regular),
			BackgroundTransparency = 1,
			Image = v14,
			ImageColor3 = Theme.IconEmphasis.Color,
			ImageTransparency = 0,
			[React.Event.Activated] = t1.onActivated,
			ref = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then v19 else nil,
			NextSelectionUp = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionUp else nil,
			NextSelectionDown = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionDown else nil,
			NextSelectionLeft = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionLeft else nil,
			NextSelectionRight = if not FFlagAXMigrateQuickButtonsToGlobalAutoFocus then t1.NextSelectionRight else nil,
			SelectionImageObject = v21
		}),
		UIStroke = if not t1.enableFocusAnimation then nil else React.createElement("UIStroke", {
			Color = v20.Color.ActionEmphasis.Background.Color3,
			Thickness = v22 and v22:map(function(p2) -- line: 92
				return p2.thickness
			end),
			Transparency = v22 and v22:map(function(p3) -- line: 95
				return p3.transparency
			end)
		})
	})
end))
