local SocialLibraries = script:FindFirstAncestor("SocialLibraries")
local Roact = require(SocialLibraries.dependencies).Roact

local function new(p1, p2) -- line: 5
	-- upvalues: Roact (copy)
	local v6 = p2 or {}
	local t1 = {
		blockLayout = p1
	}

	for i, v in ipairs(v6) do
		local size = v.size
		local element = v.element

		t1[i .. "-block"] = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = size,
			LayoutOrder = i
		}, {
			child = element
		})
	end

	return t1
end

return new
