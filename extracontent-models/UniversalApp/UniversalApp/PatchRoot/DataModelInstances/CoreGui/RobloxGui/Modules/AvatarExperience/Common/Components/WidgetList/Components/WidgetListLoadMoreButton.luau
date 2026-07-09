local CorePackages = game:GetService("CorePackages")
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local UIBlox = require(CorePackages.Packages.UIBlox)
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local StandardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 17
	-- upvalues: useLocalization (copy), React (copy), RoactGamepad (copy), Button (copy), StandardButtonSize (copy), ButtonType (copy)
	local v11 = useLocalization({
		loadMore = "Feature.Catalog.Action.LoadMore"
	})

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 1),
		ref = p1,
		NextSelectionUp = t1.NextSelectionUp
	}, {
		LoadMoreButton = React.createElement(Button, {
			onActivated = t1.onActivated,
			text = v11.loadMore,
			standardSize = StandardButtonSize.Regular,
			buttonType = ButtonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end))
