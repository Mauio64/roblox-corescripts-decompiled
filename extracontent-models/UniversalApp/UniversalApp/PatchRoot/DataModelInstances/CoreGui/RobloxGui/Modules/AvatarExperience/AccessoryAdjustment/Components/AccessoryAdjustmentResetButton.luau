local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local React = require(CorePackages.Packages.React)
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useStyle = UIBlox.Core.Style.useStyle
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local Modules = CoreGui.RobloxGui.Modules
local Constants = require(Modules.AvatarExperience.AvatarRefinement.Constants)
local v14 = Images["icons/actions/reset"]

local function mapTokens(p1) -- line: 33
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		mediumIconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Icon.Size.Medium else p1.Size.Size_900
	}
end
local function ResetButton(t1: {[any]: any}) -- line: 41
	-- upvalues: useDesignTokens (copy), mapTokens (copy), useStyle (copy), useIsGamepad (copy), React (copy), Focusable (copy), ImageSetButton (copy), Constants (copy), v14 (copy)
	local v19 = useDesignTokens(mapTokens)
	local Theme = useStyle().Theme
	local v21 = useIsGamepad()

	return React.createElement(Focusable[ImageSetButton], {
		ref = t1.resetRef,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -Constants.RightMargin, 0, -9),
		Size = UDim2.new(0, v19.mediumIconSize, 0, v19.mediumIconSize),
		BackgroundTransparency = 1,
		Image = v14,
		ImageColor3 = Theme.SystemPrimaryDefault.Color,
		ImageTransparency = 0,
		LayoutOrder = 1,
		[React.Event.Activated] = t1.onResetButtonPressed,
		NextSelectionLeft = t1.NextSelectionLeft,
		ZIndex = 3,
		Visible = not v21
	})
end

return ResetButton
