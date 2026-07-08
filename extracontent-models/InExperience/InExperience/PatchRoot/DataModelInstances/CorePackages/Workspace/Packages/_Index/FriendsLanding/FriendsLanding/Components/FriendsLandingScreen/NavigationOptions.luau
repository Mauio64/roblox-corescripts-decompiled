local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)
local FriendsLandingParent = FriendsLanding.Parent
local Roact = dependencies.Roact
local LocalizedKeys = require(FriendsLanding.Enums.LocalizedKeys)
local HeaderBarRightView = require(FriendsLanding.Components.HeaderBarRightView)
local FFlagConnectionsToFriendsRename = require(FriendsLandingParent.SharedFlags).FFlagConnectionsToFriendsRename

return function(p1) -- line: 12
	-- upvalues: FFlagConnectionsToFriendsRename (copy), LocalizedKeys (copy), Roact (copy), HeaderBarRightView (copy)
	return {
		useSecondaryHeader = true,
		shouldExitNavigation = false,
		tabBarVisible = false,
		transparent = true,
		absorbInputSelectable = false,
		headerText = {
			shouldLocalize = true,
			raw = if not FFlagConnectionsToFriendsRename then LocalizedKeys.ConnectionsHeader.rawValue() else LocalizedKeys.FriendsHeader.rawValue()
		},
		renderRight = function() -- line: 23
			-- upvalues: Roact (copy), HeaderBarRightView (copy), p1 (copy)
			return Roact.createElement(HeaderBarRightView, p1)
		end
	}
end
