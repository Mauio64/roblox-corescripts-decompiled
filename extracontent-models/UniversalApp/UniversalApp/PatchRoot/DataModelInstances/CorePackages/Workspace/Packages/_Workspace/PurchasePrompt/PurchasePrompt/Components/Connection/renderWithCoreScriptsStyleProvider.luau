local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local React = require(Parent.React)
local StyleProviderWithDefaultTheme = require(Parent.Style).StyleProviderWithDefaultTheme

return function(p1, p2) -- line: 8
	-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy)
	return React.createElement(StyleProviderWithDefaultTheme, {
		withUiModeSupport = not not p2 and p2.withUiModeSupport,
		withDarkTheme = not p2 or p2.withDarkTheme
	}, p1)
end
