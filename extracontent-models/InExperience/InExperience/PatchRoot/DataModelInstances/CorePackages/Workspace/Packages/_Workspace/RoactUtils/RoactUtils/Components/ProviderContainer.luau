local Parent = script:FindFirstAncestor("RoactUtils").Parent
local React = require(Parent.React)

local function ProviderContainer(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy)
	local v5 = t1.providers or {}
	local children = t1.children
	local t2 = {
		PageWrapper = React.createElement("Folder", {}, children)
	}

	for i = #v5, 1, -1 do
		local v9 = v5[i]

		t2 = {
			ProviderChildren = React.createElement(v9.class, v9.props, t2)
		}
	end

	return React.createElement("Folder", nil, t2)
end

return ProviderContainer
