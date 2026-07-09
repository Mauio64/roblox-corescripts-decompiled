local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Analytics = require(ParentParent.Analytics)
local createTreeWithProviders = require(ParentParentParent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders
local React = require(ParentParentParent.React)

local function noop() -- line: 8
end

return function(p1, t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy), Analytics (copy), noop (copy), createTreeWithProviders (copy)
	return React.createElement(Analytics.Context.Provider, {
		value = t1.mockAnalytics or {
			fireAnalyticsEvent = noop
		}
	}, {
		Element = createTreeWithProviders(p1, t1)
	})
end
