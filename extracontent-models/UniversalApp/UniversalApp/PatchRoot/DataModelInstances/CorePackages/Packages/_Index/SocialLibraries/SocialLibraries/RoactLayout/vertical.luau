local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local dependencies = require(SocialLibraries.dependencies)
local roact = dependencies.Roact

local new = require(script.Parent.new)

local function vertical(p)
	return new(roact.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }), p)
end

return vertical
