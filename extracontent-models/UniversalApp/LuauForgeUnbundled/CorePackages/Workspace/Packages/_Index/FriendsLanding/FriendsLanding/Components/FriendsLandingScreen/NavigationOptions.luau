local roact = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies").Roact
local LocalizedKeys = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Enums/LocalizedKeys")

local HeaderBarRightView = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Components/HeaderBarRightView")

return function(p2)
	return {
		headerText = {
			raw = LocalizedKeys.FriendsHeader.rawValue(),
			shouldLocalize = true
		},
		useSecondaryHeader = true,
		shouldExitNavigation = false,
		tabBarVisible = false,
		renderRight = function()
			return roact.createElement(HeaderBarRightView, p2)
		end,
		transparent = true,
		absorbInputSelectable = false
	}
end
