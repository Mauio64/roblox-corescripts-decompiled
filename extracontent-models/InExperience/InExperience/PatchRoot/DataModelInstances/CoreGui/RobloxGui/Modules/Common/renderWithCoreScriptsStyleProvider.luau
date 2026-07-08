local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local StyleProviderWithDefaultTheme = require(CorePackages.Workspace.Packages.Style).StyleProviderWithDefaultTheme

return function(p1, p2) -- line: 7
	-- upvalues: React (copy), StyleProviderWithDefaultTheme (copy)
	return React.createElement(StyleProviderWithDefaultTheme, {
		withUiModeSupport = not not p2 and p2.withUiModeSupport,
		withDarkTheme = not p2 or p2.withDarkTheme
	}, p1)
end
