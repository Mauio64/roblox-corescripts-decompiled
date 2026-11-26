local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)

local button = UIBlox.App.Button.Button
local buttonType = UIBlox.App.Button.Enum.ButtonType
local standardButtonSize = UIBlox.App.Button.Enum.StandardButtonSize
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

return (React.forwardRef(function(props, p2)
	local v5 = useLocalization({ loadMore = "Feature.Catalog.Action.LoadMore" })

	local v6 = useDesignTokens()
	return React.createElement(RoactGamepad.Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_1200),
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		LayoutOrder = props.LayoutOrder
	}, {
		LoadMoreButton = React.createElement(button, {
			onActivated = props.onActivated,
			text = v5.loadMore,
			standardSize = standardButtonSize.Regular,
			buttonType = buttonType.Secondary,
			size = UDim2.fromScale(1, 1),
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.fromScale(0.5, 0.5)
		})
	})
end))
