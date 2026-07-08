local Foundation = script:FindFirstAncestor("Foundation")
local React = require(Foundation.Parent.React)
local Theme = require(Foundation.Enums.Theme)
local Foundation2 = require(Foundation.Providers.Foundation)

require(Foundation.Providers.Preferences.PreferencesProvider)

local View = require(Foundation.Components.View)

return function(p1, p2, p3) -- line: 12
	-- upvalues: React (copy), Foundation2 (copy), Theme (copy), View (copy)
	return React.createElement(Foundation2, {
		theme = p3 or Theme.Dark,
		preferences = p2
	}, {
		Content = React.createElement(View, {
			Size = UDim2.fromScale(1, 1)
		}, p1)
	})
end
