local parent = script:FindFirstAncestor("RoactUtils").Parent

local React = require(parent.React)

local function ProviderContainer(p)
	local providers = p.providers or {}
	local children = p.children

	local v = {
		PageWrapper = React.createElement("Folder", {}, children)
	}

	for i = #providers, 1, -1 do
		local provider = providers[i]
		v = {
			ProviderChildren = React.createElement(provider.class, provider.props, v)
		}
	end

	return React.createElement("Folder", nil, v)
end

return ProviderContainer
