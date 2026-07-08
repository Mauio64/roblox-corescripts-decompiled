local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact
local new = require(script.Parent.new)

local function vertical(p1) -- line: 7
	-- upvalues: Roact (copy), new (copy)
	local v6 = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	return new(v6, p1)
end

return vertical
