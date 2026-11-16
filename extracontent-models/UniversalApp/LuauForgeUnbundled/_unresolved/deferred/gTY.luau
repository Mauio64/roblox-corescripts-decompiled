local CorePackages = game:GetService("CorePackages")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local UIBlox = require(CorePackages.Packages.UIBlox)
local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize

return (React.forwardRef(function(p2, p3)
	local v5 = useLocalization({ loadMore = "Feature.Catalog.Action.LoadMore" })

	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 1),
		ref = p3,
		NextSelectionUp = p2.NextSelectionUp
	}, {
		LoadMoreButton = React.createElement(button, {
			onActivated = p2.onActivated,
			text = v5.loadMore,
			standardSize = standardButtonSize.Regular,
			buttonType = buttonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end))
