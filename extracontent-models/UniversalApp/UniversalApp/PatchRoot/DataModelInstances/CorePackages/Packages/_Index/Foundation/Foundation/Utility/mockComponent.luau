local Foundation = script:FindFirstAncestor("Foundation")
local React = require(Foundation.Parent.React)

local ColorMode = require(Foundation.Enums.ColorMode)

local Foundation2 = require(Foundation.Providers.Foundation)
require(Foundation.Providers.Preferences.PreferencesProvider)
local View = require(Foundation.Components.View)

return function(p, preferences, p2)
	return React.createElement(Foundation2, {
		colorMode = p2 or ColorMode.Dark,
		preferences = preferences
	}, {
		Content = React.createElement(View, { Size = UDim2.fromScale(1, 1) }, p)
	})
end
