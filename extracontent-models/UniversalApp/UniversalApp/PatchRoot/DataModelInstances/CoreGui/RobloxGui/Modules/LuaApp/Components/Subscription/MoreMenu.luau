local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local ContextualMenu = UIBlox.App.Menu.ContextualMenu
local MenuDirection = UIBlox.App.Menu.MenuDirection

local function MoreMenu(t1: {[any]: any}) -- line: 24
	-- upvalues: useDesignTokens (copy), React (copy), ImageSetButton (copy), Images (copy), ContextualMenu (copy), MenuDirection (copy)
	local Semantic = useDesignTokens().Semantic
	local Medium = Semantic.Icon.Size.Medium
	local SemanticColor = Semantic.Color

	return React.createElement(ImageSetButton, {
		Size = UDim2.fromOffset(Medium, Medium),
		AnchorPoint = Vector2.new(0.25, 0.75),
		Position = UDim2.fromScale(1, 0),
		Image = Images["icons/common/overflow"],
		ImageColor3 = SemanticColor.Icon.Emphasis.Color3,
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		[React.Event.Activated] = t1.onActivated
	}, {
		Menu = React.createElement("Frame", {
			BackgroundTransparency = 1
		}, {
			ContextualMenu = React.createElement(ContextualMenu, {
				elementHeight = 38,
				closeBackgroundVisible = false,
				buttonProps = t1.buttonProps,
				screenSize = t1.screenSize,
				menuDirection = MenuDirection.Down,
				openPositionY = UDim.new(0, Medium),
				openPositionX = UDim.new(0, -100),
				open = t1.showMenu,
				onDismiss = t1.onDismiss,
				contextMenuWidthOverride = UDim.new(0, 155)
			})
		})
	})
end

return MoreMenu
