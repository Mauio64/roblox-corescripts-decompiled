local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local imageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local contextualMenu = UIBlox.App.Menu.ContextualMenu
local menuDirection = UIBlox.App.Menu.MenuDirection

local function MoreMenu(props)
	local v5 = useDesignTokens()
	local size_900 = v5.Size.Size_900

	return React.createElement(imageSetButton, {
		Size = UDim2.fromOffset(size_900, size_900),
		AnchorPoint = Vector2.new(0.25, 0.75),
		Position = UDim2.fromScale(1, 0),
		Image = images["icons/common/overflow"],
		ImageColor3 = v5.Color.Content.Emphasis.Color3,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		[React.Event.Activated] = props.onActivated
	}, {
		Menu = React.createElement("Frame", { BackgroundTransparency = 1 }, {
			ContextualMenu = React.createElement(contextualMenu, {
				buttonProps = props.buttonProps,
				screenSize = props.screenSize,
				menuDirection = menuDirection.Down,
				openPositionY = UDim.new(0, size_900),
				openPositionX = UDim.new(0, -100),
				open = props.showMenu,
				onDismiss = props.onDismiss,
				elementHeight = 38,
				closeBackgroundVisible = false,
				contextMenuWidthOverride = UDim.new(0, 155)
			})
		})
	})
end

return MoreMenu
