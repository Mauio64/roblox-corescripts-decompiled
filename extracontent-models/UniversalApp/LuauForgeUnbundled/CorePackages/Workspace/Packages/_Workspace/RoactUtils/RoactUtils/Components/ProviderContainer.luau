local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RoactUtils/React")

local function ProviderContainer(p2)
	local providers = p2.providers or {}
	local children = p2.children

	local v5 = {
		PageWrapper = React.createElement("Folder", {}, children)
	}

	for i = #providers, 1, -1 do
		local provider = providers[i]
		v5 = {
			ProviderChildren = React.createElement(provider.class, provider.props, v5)
		}
	end

	return React.createElement("Folder", nil, v5)
end

return ProviderContainer
