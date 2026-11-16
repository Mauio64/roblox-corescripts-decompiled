local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact
local LocalizedKeys = require(FriendsLanding.Enums.LocalizedKeys)

local HeaderBarRightView = require(FriendsLanding.Components.HeaderBarRightView)

return function(p)
	return {
		headerText = {
			raw = LocalizedKeys.FriendsHeader.rawValue(),
			shouldLocalize = true
		},
		useSecondaryHeader = true,
		shouldExitNavigation = false,
		tabBarVisible = false,
		renderRight = function()
			return roact.createElement(HeaderBarRightView, p)
		end,
		transparent = true,
		absorbInputSelectable = false
	}
end
