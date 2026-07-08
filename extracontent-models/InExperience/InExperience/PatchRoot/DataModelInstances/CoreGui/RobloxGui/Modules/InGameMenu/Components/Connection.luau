local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local FriendStatusConnector = require(script.FriendStatusConnector)
local LastInputTypeConnector = require(script.LastInputTypeConnector)
local MouseOverrideManager = require(script.MouseOverrideManager)
local FocusHighlightManager = require(script.FocusHighlightManager)
local NativeCloseEventConnector = require(script.NativeCloseEventConnector)
local ParentParent = script.Parent.Parent
local InGameMenuPolicy = require(ParentParent.InGameMenuPolicy)
local v12 = t.strictInterface({
	isEducationalPopupEnabled = t.optional(t.boolean)
})

local function Connection(p1) -- line: 20
	-- upvalues: v12 (copy), Roact (copy), FriendStatusConnector (copy), LastInputTypeConnector (copy), MouseOverrideManager (copy), FocusHighlightManager (copy), NativeCloseEventConnector (copy)
	assert(v12)

	return Roact.createFragment({
		FriendStatusConnector = Roact.createElement(FriendStatusConnector),
		LastInputTypeConnector = Roact.createElement(LastInputTypeConnector),
		MouseOverrideManager = Roact.createElement(MouseOverrideManager),
		FocusHighlightManager = Roact.createElement(FocusHighlightManager),
		NativeCloseEventConnector = p1.isEducationalPopupEnabled and Roact.createElement(NativeCloseEventConnector) or nil
	})
end

return InGameMenuPolicy.connect(function(p2, _) -- line: 32
	return {
		isEducationalPopupEnabled = p2.enableEducationalPopup()
	}
end)(Connection)
