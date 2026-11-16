local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/React")
local styleProviderWithDefaultTheme = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/Style").StyleProviderWithDefaultTheme

return function(p2, p3)
	local createElement = React.createElement
	local v7 = if p3 then p3.withUiModeSupport else false
	return createElement(styleProviderWithDefaultTheme, {
		withUiModeSupport = v7,
		withDarkTheme = not p3 or p3.withDarkTheme
	}, p2)
end
