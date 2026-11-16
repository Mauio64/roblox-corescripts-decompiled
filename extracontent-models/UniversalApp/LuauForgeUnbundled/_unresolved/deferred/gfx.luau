local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local module = require("@luauforge/bundled/dTM")

return function(p2)
	return function(p3)
		local v5 = useNavigation()

		local v6 = React.useCallback(function()
			module.closeOverlay(v5)
		end, { v5 })

		return React.createElement(
			"TextButton",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				[React.Event.Activated] = v6
			},
			{ Prompt = React.createElement(p2, p3) }
		)
	end
end
