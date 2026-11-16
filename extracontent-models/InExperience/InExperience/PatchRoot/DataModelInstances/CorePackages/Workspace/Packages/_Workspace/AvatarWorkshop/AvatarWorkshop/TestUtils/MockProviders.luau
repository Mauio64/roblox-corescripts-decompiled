local AvatarWorkshop = script:FindFirstAncestor("AvatarWorkshop")
local parent = AvatarWorkshop.Parent

local React = require(parent.React)

local ContextProviders = require(AvatarWorkshop.Internal.ContextProviders)

local function MockProviders(p)
	return React.createElement(ContextProviders, { theme = "Dark" }, p.children)
end

return MockProviders
