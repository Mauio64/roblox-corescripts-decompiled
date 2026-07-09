local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local StyleProviderWithDefaultTheme = require(ParentParent.Style).StyleProviderWithDefaultTheme

return function(p1, p2) -- line: 8
	-- upvalues: Roact (copy), StyleProviderWithDefaultTheme (copy)
	return Roact.createElement(StyleProviderWithDefaultTheme, {
		withUiModeSupport = not not p2 and p2.withUiModeSupport,
		withDarkTheme = if not p2 then nil else p2.withDarkTheme
	}, p1)
end
