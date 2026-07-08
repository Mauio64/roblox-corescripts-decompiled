local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local ReactTestingLibrary = require(Parent.Dev.ReactTestingLibrary)
local FoundationProvider = require(Parent.Foundation).FoundationProvider

local function renderWithProviders(p1) -- line: 9
	-- upvalues: ReactTestingLibrary (copy), React (copy), FoundationProvider (copy)
	return ReactTestingLibrary.render(React.createElement(FoundationProvider, {
		theme = "Dark"
	}, p1))
end

return renderWithProviders
