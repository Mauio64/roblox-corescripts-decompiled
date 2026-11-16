local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local StyleProviderWithDefaultTheme = Style.StyleProviderWithDefaultTheme

return function(p, p2)
	local createElement = React.createElement
	local withUiModeSupport = if p2 then p2.withUiModeSupport else false
	return createElement(StyleProviderWithDefaultTheme, {
		withUiModeSupport = withUiModeSupport,
		withDarkTheme = not p2 or p2.withDarkTheme
	}, p)
end
