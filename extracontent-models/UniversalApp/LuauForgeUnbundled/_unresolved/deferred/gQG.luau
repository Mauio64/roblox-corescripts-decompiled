local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

local iconButton = UIBlox.App.Button.IconButton
local React = require(CorePackages.Packages.React)

local headerBar = UIBlox.App.Bar.HeaderBar
local iconsnavigationpushBack = images["icons/navigation/pushBack"]

local function fn(p2)
	return React.createElement(iconButton, {
		anchorPoint = Vector2.new(0, 0),
		icon = iconsnavigationpushBack,
		onActivated = function()
			local navigation = p2.navigation
			p2.closeFocusedScreen(navigation)
		end
	})
end

return function(props)
	return React.createElement(headerBar, {
		backgroundTransparency = 1,
		barHeight = props.topBarHeight,
		renderLeft = function()
			return React.createElement(fn, {
				navigation = props.navigation,
				closeFocusedScreen = props.closeFocusedScreen
			})
		end,
		title = props.title
	})
end
