local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local IconButton = UIBlox.App.Button.IconButton
local React = require(CorePackages.Packages.React)
local HeaderBar = UIBlox.App.Bar.HeaderBar
local v7 = Images["icons/navigation/pushBack"]

local function v8(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), IconButton (copy), v7 (copy)
	return React.createElement(IconButton, {
		anchorPoint = Vector2.new(0, 0),
		icon = v7,
		onActivated = function() -- line: 26
			-- upvalues: t1 (copy)
			local navigation = t1.navigation

			t1.closeFocusedScreen(navigation)
		end
	})
end

return function(t2: {[any]: any}) -- line: 34
	-- upvalues: React (copy), HeaderBar (copy), v8 (copy)
	return React.createElement(HeaderBar, {
		backgroundTransparency = 1,
		barHeight = t2.topBarHeight,
		renderLeft = function() -- line: 38
			-- upvalues: React (copy), v8 (copy), t2 (copy)
			return React.createElement(v8, {
				navigation = t2.navigation,
				closeFocusedScreen = t2.closeFocusedScreen
			})
		end,
		title = t2.title
	})
end
