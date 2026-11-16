local parent = script:FindFirstAncestor("InExperienceShop").Parent

local React = require(parent.React)
local ReactTestingLibrary = require(parent.Dev.ReactTestingLibrary)
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local function renderWithProviders(p)
	return ReactTestingLibrary.render(React.createElement(FoundationProvider, { colorMode = "Dark" }, p))
end

return renderWithProviders
