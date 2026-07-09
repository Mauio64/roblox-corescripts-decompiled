local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local createTreeWithProviders = require(Parent.Dev.SocialTestHelpers).TestHelpers.createTreeWithProviders

return function(p1, p2) -- line: 9
	-- upvalues: React (copy), Foundation (copy), createTreeWithProviders (copy)
	return React.createElement(Foundation.FoundationProvider, {
		device = "Phone",
		theme = "Dark"
	}, {
		Element = createTreeWithProviders(p1, p2)
	})
end
