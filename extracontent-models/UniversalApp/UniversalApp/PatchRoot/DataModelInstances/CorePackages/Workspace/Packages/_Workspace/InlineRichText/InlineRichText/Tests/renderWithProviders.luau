local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local React = require(InlineRichTextParent.React)
local ReactTestingLibrary = require(InlineRichTextParent.Dev.ReactTestingLibrary)
local MockProviders = require(InlineRichText.MockProviders)

local function renderWithProviders(p1, p2) -- line: 7
	-- upvalues: React (copy), MockProviders (copy), ReactTestingLibrary (copy)
	local v9 = React.createElement(MockProviders, {
		themeName = "Light"
	}, {
		component = React.createElement(p1, p2)
	})
	local u10 = nil

	ReactTestingLibrary.act(function() -- line: 14
		-- upvalues: u10 (ref), ReactTestingLibrary (copy), v9 (copy)
		u10 = ReactTestingLibrary.render(v9)
	end)

	return u10, function() -- line: 17
		-- upvalues: ReactTestingLibrary (copy)
		ReactTestingLibrary.cleanup()
	end
end

return renderWithProviders
