local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 24
	-- upvalues: useLocalization (copy), useDesignTokens (copy), React (copy), RoactGamepad (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy)
	local v13 = useLocalization({
		loadMore = "Feature.Catalog.Action.LoadMore"
	})
	local v14 = useDesignTokens()

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, if not FFlagRenameDeprecatedUIBloxTokens then v14.Global.Size_600 else v14.Size.Size_1200),
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		LayoutOrder = t1.LayoutOrder
	}, {
		LoadMoreButton = React.createElement(Button, {
			onActivated = t1.onActivated,
			text = v13.loadMore,
			standardSize = StandardButtonSize.Regular,
			buttonType = ButtonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end))
